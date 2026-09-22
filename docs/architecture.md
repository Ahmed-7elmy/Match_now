# Architecture Guide

## Project Structure

Match Point follows a **feature-first architecture** with a lightweight layered
approach. Features own the code for a product capability, while `core/` owns
cross-feature infrastructure and reusable UI.

```text
lib/
  main.dart
  app.dart
  firebase_options.dart
  core/
    config/ constants/ errors/ network/ routes/ theme/ utils/ widgets/
  features/
    auth/ home/ matches/ profile/ splash/ standings/
```

```mermaid
flowchart TB
  Application[Application] --> Core[core: shared infrastructure]
  Application --> Features[features: product capabilities]
  Features --> Auth[auth]
  Features --> Matches[matches]
  Features --> Home[home]
  Features --> Profile[profile]
  Features --> Splash[splash]
```

This organization keeps unrelated capabilities decoupled and makes it easy to
find the code that owns a behavior.

## Feature Layers

Complex features use three local layers:

```text
feature/
  data/           # Models, repository, remote data source
  logic/          # BLoC, events, states
  presentation/   # Screens and feature-only widgets
```

```mermaid
flowchart TD
  Presentation[Presentation] -->|events| Bloc[Logic: BLoC]
  Bloc -->|repository contract| Repository[Data: Repository]
  Repository --> Remote[Data: Remote data source]
  Remote --> Service[API-Football or Firebase]
  Service --> Remote
  Remote --> Repository
  Repository -->|Success or FailureResult| Bloc
  Bloc -->|state| Presentation
```

### Presentation

`presentation/` contains screens and widgets. It renders loading, success,
empty, and error states; collects user input; sends BLoC events; and displays
UI feedback. It does not call Firebase, Dio, or API-Football directly.

```mermaid
sequenceDiagram
  participant User
  participant Screen as MatchesScreen
  participant Bloc as MatchesBloc
  User->>Screen: Search for Arsenal
  Screen->>Bloc: SearchQueryChanged
  Bloc->>Bloc: Filter loaded matches
  Bloc-->>Screen: Updated MatchesState
  Screen-->>User: Rebuilt match list
```

### Logic

`logic/` uses the BLoC pattern. Events represent intent, the BLoC coordinates
work, and immutable states describe what the UI can render.

Examples of events include `MatchesRequested`, `MatchesRefreshed`,
`SearchQueryChanged`, `LoginSubmitted`, `GoogleLoginRequested`, and
`LogoutRequested`.

`MatchesBloc` caches fixture responses and performs search, league, and status
filtering against already-loaded data. This reduces API-Football requests and
keeps the presentation layer simple.

```mermaid
stateDiagram-v2
  [*] --> initial
  initial --> loading: MatchesRequested
  loading --> success: fixtures loaded
  loading --> failure: request failed
  success --> success: search or filter change
  success --> loading: request new fixtures
  failure --> loading: retry
```

### Data

`data/` retrieves and transforms external data. It contains models, repository
contracts/implementations, and remote data sources.

```text
matches/data/
  models/league_model.dart
  models/match_model.dart
  models/team_model.dart
  competition_catalog.dart
  football_remote_data_source.dart
  football_repository.dart
```

Models transform API JSON into typed Dart data. The rest of the app works with
`MatchModel`, `TeamModel`, and `LeagueModel`, rather than raw JSON maps.

## Repository and Remote Source

The repository sits between BLoC logic and external systems. BLoCs use a stable
repository contract and do not need to know whether data comes from Dio,
Firebase, or a future cache.

```mermaid
flowchart LR
  MatchesBloc --> FootballRepository
  FootballRepository --> FootballRemoteDataSource
  FootballRemoteDataSource --> ApiClient
  ApiClient --> Dio
  Dio --> APIFootball[API-Football]
  APIFootball --> JSON
  JSON --> MatchModel[MatchModel.fromJson]
  MatchModel --> MatchesBloc
```

`FootballRemoteDataSourceImpl` builds fixture query parameters, calls
`ApiClient`, validates API-level errors, and maps the `response` payload to
models. `FootballRepositoryImpl` converts exceptions into `Result` values,
allowing the BLoC to handle expected failures without infrastructure-specific
`try/catch` code.

The authentication feature follows the same boundary:

```mermaid
flowchart LR
  AuthBloc --> AuthRepository
  AuthRepository --> FirebaseSource[FirebaseAuthRemoteDataSource]
  FirebaseSource --> Firebase[Firebase Authentication]
  Firebase --> FirebaseSource
  FirebaseSource --> AuthRepository
  AuthRepository --> AuthBloc
```

## Core Infrastructure

`core/` contains reusable code that should not belong to a single feature.

| Area | Purpose |
| --- | --- |
| `config/` | Reads `.env` values through `Env` and exposes them through `AppConfig` |
| `constants/` | Centralizes API, date, and route constants |
| `network/` | Configures Dio, shared API calls, and API authentication headers |
| `errors/` | Converts technical exceptions into app-level failures |
| `routes/` | Defines GoRouter routes and the authentication redirect guard |
| `theme/` | Defines colors, spacing, radius, dimensions, and Material theme settings |
| `utils/` | Provides `Result`, validators, date formatting, and Snackbar helpers |
| `widgets/` | Provides shared buttons, text fields, branded background, empty, and error views |

### Network Flow

```mermaid
flowchart TD
  DotEnv[.env] --> Env[Env]
  Env --> AppConfig
  AppConfig --> ApiClient
  ApiClient --> Dio
  Dio --> Interceptor[ApiInterceptor]
  Interceptor --> Header[x-apisports-key]
  Header --> APIFootball[API-Football]
```

The API base URL and key remain in `.env`, rather than being distributed across
features. `ApiClient` centralizes Dio timeouts and JSON configuration, and
`ApiInterceptor` adds the API-Football key to outgoing requests.

### Error Handling

Technical exceptions are converted to predictable application failures before
they reach a BLoC or UI.

```mermaid
flowchart LR
  Technical[Dio or Firebase exception] --> Mapper[ErrorHandler or AuthFailureMapper]
  Mapper --> Failure[Network, timeout, unauthorized, rate limit, server, parsing, or unknown failure]
  Failure --> Repository
  Repository --> Result[FailureResult]
  Result --> Bloc
  Bloc --> UI[User-facing state and feedback]
```

## Routing and Authentication Guard

`AppRouter` is the single navigation authority. It observes `AuthBloc` and
keeps protected routes unavailable to signed-out users. The splash route remains
visible until Firebase resolves the initial session.

```mermaid
flowchart TD
  Start[App start] --> Splash
  Splash --> Resolved{Auth state resolved?}
  Resolved -- No --> Splash
  Resolved -- Yes --> SignedIn{Authenticated?}
  SignedIn -- No --> AuthRoutes[Login, sign up, reset password]
  SignedIn -- Yes --> Home
  Home --> Matches
  Home --> Profile
  Profile -->|LogoutRequested| AuthRoutes
```

Authentication navigation is state-driven. A login screen dispatches
`LoginSubmitted`; it does not manually push Home. Firebase emits the new auth
state, `AuthBloc` emits `AuthAuthenticated`, and the router redirects to Home.

## Feature Notes

### Authentication

Supports email/password registration and sign-in, Google Sign-In on supported
non-web platforms, password reset, logout, and session persistence through
Firebase `authStateChanges()`.

### Matches

Fetches API-Football fixtures; supports competition, date, season, status, and
text filters; caches fixture requests; and renders loading, empty, failure,
retry, and refresh states.

### Home and Profile

Home is an authenticated landing screen with links to matches and profile.
Profile reads from the global `AuthBloc`, shows available Firebase user data,
and dispatches logout through the same BLoC.

### Splash and Standings

Splash is a branded auth-resolution screen. `standings/` is reserved for a
future feature and currently has no implementation.

## Bootstrap

`main.dart` initializes Flutter bindings, `.env`, Firebase, Google Sign-In
where supported, and portrait orientation before starting `EyeGoApp`.

`app.dart` is the composition root. It creates and provides the long-lived
repositories, API client, remote sources, application-level `AuthBloc`, dark
theme, and router configuration.