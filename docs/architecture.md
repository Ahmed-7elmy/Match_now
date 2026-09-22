# Architecture & Project Structure

The application follows a **feature-first architecture** combined with a lightweight layered approach.

Instead of grouping the entire application by technical type, such as putting every screen in one folder and every model in another, the project is divided by **features**.

Each feature owns the code related to its responsibility, while common functionality used by multiple features is placed inside `core/`.

At a high level:

```text
lib/
│
├── main.dart
├── app.dart
├── firebase_options.dart
│
├── core/
│   ├── config/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── routes/
│   ├── theme/
│   ├── utils/
│   └── widgets/
│
└── features/
    ├── auth/
    ├── home/
    ├── matches/
    ├── profile/
    └── splash/
```

The separation can be viewed as:

```text
Application
│
├── Core
│   └── Shared infrastructure used by multiple features
│
└── Features
    └── Independent application capabilities
```

This makes the project easier to navigate and allows features to evolve without tightly coupling them to unrelated parts of the application.

---

# Feature-First Architecture

Every major application capability is placed inside `features/`.

For complex features, the internal structure is separated into:

```text
feature/
│
├── data/
├── logic/
└── presentation/
```

The general responsibility of each layer is:

```text
Presentation
     │
     │ sends Events / reads State
     ▼
Logic / BLoC
     │
     │ requests application data
     ▼
Repository
     │
     ▼
Remote Data Source
     │
     ▼
External Service / API
```

Or more simply:

```text
UI
 ↓
BLoC
 ↓
Repository
 ↓
Remote Data Source
 ↓
API / Firebase
```

This ensures that widgets do not directly communicate with APIs or Firebase.

---

# Presentation Layer

The `presentation/` folder contains everything related to what the user sees and interacts with.

Examples include:

```text
presentation/
├── login_screen.dart
├── matches_screen.dart
└── widgets/
    ├── match_card.dart
    └── matches_filter_bar.dart
```

Its responsibilities include:

* Displaying application data.
* Rendering loading, success, empty, and error states.
* Collecting user input.
* Sending events to BLoC.
* Listening to states produced by BLoC.
* Showing UI-specific feedback such as snackbars.

The presentation layer does **not** directly call Firebase, Dio, or API-Football.

For example:

```text
User types "Arsenal"
        │
        ▼
MatchesScreen
        │
        ▼
SearchQueryChanged
        │
        ▼
MatchesBloc
        │
        ▼
New MatchesState
        │
        ▼
MatchesScreen rebuilds
```

---

# Logic Layer

The `logic/` folder contains the state management of the feature.

The application uses the **BLoC pattern**.

A typical BLoC feature contains:

```text
logic/
├── feature_bloc.dart
├── feature_event.dart
└── feature_state.dart
```

For example:

```text
matches/
└── logic/
    ├── matches_bloc.dart
    ├── matches_event.dart
    └── matches_state.dart
```

### Events

Events describe something that happened in the application.

Examples:

```text
MatchesRequested
MatchesRefreshed
SearchQueryChanged
LeagueFilterChanged
StatusFilterChanged
LoginSubmitted
GoogleLoginRequested
LogoutRequested
```

### BLoC

The BLoC receives events and decides how the application state should change.

For example:

```text
SearchQueryChanged("Arsenal")
           │
           ▼
      MatchesBloc
           │
           ▼
Filter already loaded matches
           │
           ▼
     MatchesState
```

Search and filtering are performed locally on previously fetched data instead of sending a new API request for every user interaction.

### State

State represents the information required by the UI at a specific moment.

For Matches, state can contain information such as:

```text
Loading status
All matches
Filtered matches
Search query
Selected competition
Selected match status
Refresh status
Failure information
```

The UI simply reacts to these state changes.

---

# Data Layer

The `data/` folder contains code responsible for retrieving and transforming data.

A data layer generally contains:

```text
data/
│
├── models/
├── remote_data_source.dart
└── repository.dart
```

The Matches feature currently follows this structure:

```text
matches/
└── data/
    ├── models/
    │   ├── league_model.dart
    │   ├── match_model.dart
    │   └── team_model.dart
    │
    ├── competition_catalog.dart
    ├── football_remote_data_source.dart
    └── football_repository.dart
```

## Models

Models represent structured application data.

Examples:

```text
MatchModel
TeamModel
LeagueModel
```

They convert raw JSON returned by the API into strongly typed Dart objects.

For example:

```text
API JSON
   │
   ▼
MatchModel.fromJson()
   │
   ▼
MatchModel
```

The rest of the application therefore works with Dart objects instead of raw JSON maps.

---

## Remote Data Source

The Remote Data Source communicates directly with the external service.

For football data:

```text
FootballRemoteDataSource
          │
          ▼
      ApiClient
          │
          ▼
    API-Football
```

It is responsible for:

* Selecting the correct endpoint.
* Building query parameters.
* Reading the API response.
* Checking API-level errors.
* Converting JSON into models.

It does not contain UI logic.

---

## Repository

The Repository sits between the BLoC and the data source.

```text
MatchesBloc
     │
     ▼
FootballRepository
     │
     ▼
FootballRemoteDataSource
```

The repository hides implementation details from the BLoC.

The BLoC does not need to know whether the data came from Dio, Firebase, an API, or eventually a local cache.

For example:

```text
BLoC / UI
    │
    ▼
FootballRepository
    │
    ▼
FootballRemoteDataSource
    │
    ▼
ApiClient
    │
    ▼
API-Football JSON
    │
    ▼
MatchModel.fromJson()
    │
    ▼
List<MatchModel>
```

The repository also converts technical errors into application-friendly results.

---

# Core Layer

The `core/` folder contains infrastructure and reusable components that are not specific to one feature.

```text
core/
│
├── config/
├── constants/
├── errors/
├── network/
│   └── interceptors/
├── routes/
├── theme/
├── utils/
└── widgets/
```

Each folder has a separate responsibility.

---

## `core/config`

```text
core/config/
├── app_config.dart
└── env.dart
```

This folder manages application configuration and environment variables.

The project loads values such as:

```text
API_FOOTBALL_BASE_URL
API_FOOTBALL_KEY
```

from `.env`.

The configuration flow is:

```text
.env
 │
 ▼
Env
 │
 ▼
AppConfig
 │
 ▼
Application infrastructure
```

This avoids scattering environment values throughout the codebase.

---

# API Configuration & Network Architecture

The football API network flow is:

```text
                    .env
                      │
                      ▼
                     Env
                      │
                      ▼
                 AppConfig
                      │
                      ▼
                     Dio
                      │
                      ▼
              ApiInterceptor
                      │
              x-apisports-key
                      │
                      ▼
                 ApiClient
                      │
                      ▼
               API-Football
                      │
               ┌──────┴──────┐
               │             │
               ▼             ▼
            Success         Error
               │             │
               ▼             ▼
             JSON       ErrorHandler
                             │
                             ▼
                          Failure
```

Each component has a specific responsibility.

### `Env`

Reads environment variables from `.env`.

### `AppConfig`

Provides application configuration to the rest of the project without requiring other classes to access `.env` directly.

### Dio

Dio is the HTTP client used to communicate with API-Football.

It provides:

* HTTP requests.
* Query parameters.
* Timeouts.
* Interceptors.
* Structured HTTP errors.

### `ApiInterceptor`

The interceptor automatically adds API authentication information to outgoing requests.

For API-Football:

```text
x-apisports-key
```

This means individual repositories and data sources do not repeatedly add the API key.

Conceptually:

```text
Request
   │
   ▼
ApiInterceptor
   │
   ├── Add x-apisports-key
   │
   ▼
API-Football
```

### `ApiClient`

`ApiClient` wraps Dio and provides a shared interface for HTTP communication.

Instead of every feature constructing its own Dio client:

```text
FootballRemoteDataSource
          │
          ▼
       ApiClient
          │
          ▼
         Dio
```

This centralizes HTTP configuration.

---

## `core/network`

```text
core/network/
├── api_client.dart
├── network_info.dart
└── interceptors/
    └── api_interceptor.dart
```

### `api_client.dart`

Provides the configured Dio client and shared HTTP operations.

### `network_info.dart`

Provides information about network connectivity.

Connectivity is treated as a useful signal, while the actual HTTP request remains the final authority on whether communication succeeded.

### `interceptors/`

Contains request/response interceptors.

Currently the API interceptor handles API-Football authentication headers.

---

# Error Handling

```text
core/errors/
├── auth_failure_mapper.dart
├── error_handler.dart
├── exceptions.dart
└── failures.dart
```

The project separates **technical exceptions** from **application failures**.

The general flow is:

```text
Dio / Firebase Exception
          │
          ▼
     ErrorHandler
          │
          ▼
        Failure
          │
          ▼
      Repository
          │
          ▼
         BLoC
          │
          ▼
          UI
```

Instead of allowing the UI to understand errors such as:

```text
DioException
SocketException
FirebaseAuthException
HTTP 429
HTTP 500
```

they are converted into application-level failures such as:

```text
NetworkFailure
TimeoutFailure
UnauthorizedFailure
RateLimitFailure
ServerFailure
ParsingFailure
UnknownFailure
```

The UI therefore receives a predictable error representation.

---

## `exceptions.dart`

Contains low-level exceptions that can occur while retrieving or parsing data.

Examples include:

```text
ServerException
NetworkException
TimeoutException
UnauthorizedException
RateLimitException
ParsingException
```

---

## `failures.dart`

Contains application-level failure classes.

These failures are safe for the repository/BLoC layer to work with.

---

## `error_handler.dart`

Maps network and technical errors into the correct `Failure`.

Example:

```text
HTTP 429
   │
   ▼
DioException
   │
   ▼
ErrorHandler
   │
   ▼
RateLimitFailure
   │
   ▼
MatchesBloc
   │
   ▼
User-friendly error
```

---

## `auth_failure_mapper.dart`

Authentication has its own Firebase-specific error mapping.

For example:

```text
FirebaseAuthException
        │
        ▼
AuthFailureMapper
        │
        ▼
User-friendly Failure
```

This allows errors such as invalid credentials or an existing email account to be displayed in a consistent way.

---

# `core/constants`

```text
core/constants/
├── api_constants.dart
├── date_constants.dart
└── route_constants.dart
```

Constants are centralized so values are not repeated throughout the application.

### `api_constants.dart`

Contains API-related values such as:

* Endpoint names.
* Header names.
* Network timeouts.

### `date_constants.dart`

Contains reusable date-related constants.

### `route_constants.dart`

Contains route paths such as:

```text
/splash
/login
/signup
/forgot-password
/home
/matches
/profile
```

This avoids hardcoding route strings throughout widgets.

---

# Routing

```text
core/routes/
├── app_router.dart
└── routes.dart
```

The application uses **GoRouter** for navigation.

`AppRouter` defines the routes and also contains the central authentication guard.

The router is responsible for deciding which routes can be accessed depending on Firebase authentication state.

Routes include:

```text
Splash
Login
Signup
Forgot Password
Home
Matches
Profile
```

---

# Authentication Guards & Navigation

Authentication navigation is controlled centrally by `AppRouter`.

Widgets do not manually decide where authentication should send the user.

The startup flow is:

```text
                     APP START
                         │
                         ▼
                       Splash
                         │
                         ▼
          AuthBloc receives Firebase state
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
       Unauthenticated         Authenticated
              │                     │
              ▼                     ▼
            Login                  Home
          /       \               /    \
         ▼         ▼             ▼      ▼
      Signup     Forgot       Matches  Profile
                                         │
                                         ▼
                                       Logout
                                         │
                                         ▼
                                       Login
```

## How authentication navigation works

### 1. Application startup

`app.dart` creates one application-level `AuthBloc`.

That bloc listens to Firebase authentication state through:

```text
FirebaseAuth
     │
     ▼
AuthRemoteDataSource
     │
     ▼
AuthRepository
     │
     ▼
AuthBloc
```

Firebase remains the source of truth for the user's session.

---

### 2. Firebase reports authentication state

Firebase exposes:

```text
authStateChanges()
```

When Firebase returns a user:

```text
Firebase User
     │
     ▼
AuthUserChanged
     │
     ▼
AuthAuthenticated
```

When Firebase returns no user:

```text
null
 │
 ▼
AuthUserChanged
 │
 ▼
AuthUnauthenticated
```

---

### 3. Splash waits for Firebase

While Firebase is determining the initial session, the application remains on the Splash screen.

The Splash screen itself does not perform authentication logic or manually navigate.

Its only responsibility is to display the startup UI.

---

### 4. GoRouter reacts to authentication

When the final authentication state changes, GoRouter reevaluates its `redirect()` guard.

For a signed-out user:

```text
Allowed:
Login
Signup
Forgot Password

Protected:
Home
Matches
Profile
```

Trying to open a protected route redirects the user to Login.

For a signed-in user:

```text
Allowed:
Home
Matches
Profile
```

Trying to open:

```text
Splash
Login
Signup
Forgot Password
```

redirects the user to Home.

---

### 5. Login screen does not navigate to Home

A login button only sends:

```text
LoginSubmitted
```

to `AuthBloc`.

The complete flow is:

```text
LoginScreen
     │
     ▼
LoginSubmitted
     │
     ▼
AuthBloc
     │
     ▼
AuthRepository
     │
     ▼
FirebaseAuth
     │
     ▼
Firebase session changes
     │
     ▼
AuthAuthenticated
     │
     ▼
GoRouter redirect
     │
     ▼
Home
```

This means the screen never needs:

```text
Login succeeded → manually push Home
```

Navigation is driven by authentication state.

---

### 6. Logout uses the same architecture

Profile sends:

```text
LogoutRequested
```

The flow becomes:

```text
ProfileScreen
     │
     ▼
LogoutRequested
     │
     ▼
AuthBloc
     │
     ▼
FirebaseAuth.signOut()
     │
     ▼
authStateChanges() → null
     │
     ▼
AuthUnauthenticated
     │
     ▼
GoRouter guard
     │
     ▼
Login
```

---

# Why Keep Authentication Guards in `AppRouter`?

Without a central guard, every protected screen would need logic such as:

```text
if user is not logged in
    navigate to login
```

That duplicates logic and makes it easier to accidentally leave a protected screen accessible.

Instead:

```text
AppRouter.redirect()
```

protects all routes in one location.

The responsibilities remain clear:

```text
Firebase
→ owns the authentication session

AuthBloc
→ represents authentication state

GoRouter
→ controls navigation

Screens
→ display UI and dispatch user actions
```

---

# `core/theme`

```text
core/theme/
├── app_colors.dart
├── app_dimensions.dart
├── app_radius.dart
├── app_spacing.dart
├── app_text_styles.dart
└── app_theme.dart
```

The theme folder defines the application's visual design system.

### `app_colors.dart`

Centralizes application colors.

### `app_spacing.dart`

Provides consistent spacing values.

### `app_radius.dart`

Defines common border-radius values.

### `app_dimensions.dart`

Contains reusable sizing and layout dimensions.

### `app_text_styles.dart`

Contains reusable typography definitions where custom styles are required.

### `app_theme.dart`

Builds the application's Material theme and configures shared styling for components such as:

* Buttons.
* Text fields.
* Cards.
* App bars.
* Colors.
* Typography.

This avoids styling every widget independently.

---

# `core/utils`

```text
core/utils/
├── date_formatter.dart
├── result.dart
├── snackbar_utils.dart
└── validators.dart
```

Utilities contain small reusable functions or types that do not belong to a particular feature.

### `date_formatter.dart`

Formats dates and times used by match information and UI.

### `result.dart`

Defines the result type used between repositories and BLoCs.

Conceptually:

```text
Repository Result
      │
 ┌────┴────┐
 ▼         ▼
Success   FailureResult
```

This prevents BLoCs from needing to catch infrastructure exceptions.

### `snackbar_utils.dart`

Centralizes Snackbar behavior so success/error feedback looks consistent across screens.

### `validators.dart`

Contains reusable form validation functions used by authentication screens.

Examples include validating:

```text
Email
Password
Required fields
```

---

# Shared Widgets

```text
core/widgets/
├── app_button.dart
├── app_empty_view.dart
├── app_error_view.dart
├── app_logo_background.dart
└── app_text_field.dart
```

Shared widgets prevent common UI components from being recreated inside every feature.

### `AppButton`

Reusable application button with consistent styling and loading support.

### `AppTextField`

Reusable text/form field used by authentication and other forms.

### `AppEmptyView`

Displays consistent empty-state UI.

For example:

```text
No matches today
```

or:

```text
No matches match your filters
```

### `AppErrorView`

Displays reusable error UI with retry support.

### `AppLogoBackground`

Contains shared branding/background presentation used by application screens.

Feature-specific widgets remain inside their feature instead.

For example:

```text
features/matches/presentation/widgets/
├── competition_quick_selector.dart
├── matches_filter_bar.dart
└── match_card.dart
```

These widgets are specific to football matches and therefore should not be placed in `core/widgets`.

---

# Features

The application currently contains the following feature modules:

```text
features/
├── auth/
├── home/
├── matches/
├── profile/
└── splash/
```

---

# Authentication Feature

```text
auth/
│
├── data/
│   ├── auth_remote_data_source.dart
│   └── auth_repository.dart
│
├── logic/
│   ├── auth_bloc.dart
│   ├── auth_event.dart
│   └── auth_state.dart
│
└── presentation/
    ├── login_screen.dart
    ├── signup_screen.dart
    ├── forgot_password_screen.dart
    │
    └── widgets/
        ├── auth_form_fields.dart
        ├── auth_form_scaffold.dart
        └── auth_submit_button.dart
```

The Auth feature handles:

* Email/password registration.
* Email/password login.
* Google Sign-In.
* Password reset.
* Logout.
* Firebase session persistence.
* Authentication state tracking.

Its architecture is:

```text
Auth Screen
     │
     ▼
AuthEvent
     │
     ▼
AuthBloc
     │
     ▼
AuthRepository
     │
     ▼
AuthRemoteDataSource
     │
     ▼
Firebase Authentication
```

`AuthBloc` also listens to Firebase's authentication state stream so Firebase remains the source of truth.

---

# Matches Feature

The Matches feature contains the largest application flow.

```text
matches/
│
├── data/
│   ├── models/
│   │   ├── league_model.dart
│   │   ├── match_model.dart
│   │   └── team_model.dart
│   │
│   ├── competition_catalog.dart
│   ├── football_remote_data_source.dart
│   └── football_repository.dart
│
├── logic/
│   ├── matches_bloc.dart
│   ├── matches_event.dart
│   └── matches_state.dart
│
└── presentation/
    ├── matches_screen.dart
    │
    └── widgets/
        ├── competition_quick_selector.dart
        ├── matches_filter_bar.dart
        └── match_card.dart
```

Its full architecture is:

```text
MatchesScreen
      │
      │ User action
      ▼
 MatchesEvent
      │
      ▼
 MatchesBloc
      │
      ▼
FootballRepository
      │
      ▼
FootballRemoteDataSource
      │
      ▼
   ApiClient
      │
      ▼
 API-Football
      │
      ▼
     JSON
      │
      ▼
MatchModel.fromJson()
      │
      ▼
List<MatchModel>
      │
      ▼
 MatchesBloc
      │
      ▼
 MatchesState
      │
      ▼
MatchesScreen
```

Search and filtering do not make unnecessary API requests.

After matches are loaded:

```text
API
 │
 ▼
allMatches
```

User interactions operate locally:

```text
allMatches
   │
   ├── Search
   ├── Competition filter
   └── Status filter
          │
          ▼
    filteredMatches
          │
          ▼
          UI
```

This is particularly important because API-Football has request quotas.

---

# Home Feature

```text
home/
└── presentation/
    └── home_screen.dart
```

The Home feature currently acts as the main landing screen for authenticated users.

It provides access to the application's major sections and does not currently require its own data or BLoC layer.

This demonstrates an important architectural principle:

> Not every feature needs every layer.

A feature should only introduce data or state-management layers when its complexity requires them.

---

# Profile Feature

```text
profile/
└── presentation/
    └── profile_screen.dart
```

The Profile screen displays information about the authenticated Firebase user and provides account actions such as logout.

Because authentication state is already controlled globally by `AuthBloc`, the Profile feature does not need its own BLoC.

Logout simply dispatches:

```text
LogoutRequested
```

to the existing application-level `AuthBloc`.

---

# Splash Feature

```text
splash/
└── presentation/
    └── splash_screen.dart
```

Splash is intentionally simple.

It does not decide whether the user is authenticated.

Instead:

```text
Splash
   │
   ▼
wait for AuthBloc
   │
   ▼
GoRouter guard
   │
   ├── Authenticated → Home
   │
   └── Unauthenticated → Login
```

This keeps authentication logic out of the UI.

---

# Application Bootstrap

The top-level application files are:

```text
lib/
├── main.dart
├── app.dart
└── firebase_options.dart
```

## `main.dart`

Responsible for startup configuration such as:

* Flutter initialization.
* Environment variable loading.
* Firebase initialization.
* Google Sign-In initialization.
* Device orientation configuration.
* Starting the Flutter application.

Conceptually:

```text
main()
 │
 ├── Load .env
 ├── Initialize Firebase
 ├── Initialize Google Sign-In
 ├── Configure orientation
 │
 ▼
runApp()
```

---

## `app.dart`

Acts as the application's **composition root**.

This is where long-lived application dependencies are created and connected.

For example:

```text
ApiClient
    │
    ▼
FootballRemoteDataSource
    │
    ▼
FootballRepository


FirebaseAuth
    │
    ▼
AuthRemoteDataSource
    │
    ▼
AuthRepository
    │
    ▼
AuthBloc
```

The application then provides those dependencies to the widget tree.

This keeps object creation centralized instead of constructing repositories or API clients inside individual screens.

---

## `firebase_options.dart`

Generated by FlutterFire and contains the platform-specific Firebase configuration required to initialize Firebase.

---

# Overall Application Architecture

The full architecture can be summarized as:

```text
                         UI
                          │
                          ▼
                  Presentation Layer
                          │
                       Events
                          │
                          ▼
                        BLoC
                          │
                          ▼
                      Repository
                          │
                          ▼
                  Remote Data Source
                          │
                ┌─────────┴──────────┐
                │                    │
                ▼                    ▼
          API-Football          Firebase Auth
                │                    │
                ▼                    ▼
              Models            Firebase User
                │                    │
                └─────────┬──────────┘
                          ▼
                        State
                          │
                          ▼
                          UI
```

The architecture follows several key principles:

* **Feature-first organization** keeps related code together.
* **BLoC** separates application state from widgets.
* **Repository pattern** separates business/state logic from data-access details.
* **Remote data sources** isolate communication with external services.
* **Models** convert external JSON into typed Dart objects.
* **Core infrastructure** prevents shared logic from being duplicated.
* **GoRouter guards** centralize protected navigation.
* **Firebase remains the source of truth for authentication.**
* **Dio and interceptors** centralize networking and API authentication.
* **Centralized error handling** prevents technical exceptions from leaking into the UI.
* **Reusable themes and widgets** create a consistent user interface.
* **Local search/filtering** reduces unnecessary API requests.

This structure keeps the application maintainable while remaining lightweight enough for the current project size.
