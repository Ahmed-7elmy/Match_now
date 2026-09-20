import 'package:bloc/bloc.dart';

import 'standings_event.dart';
import 'standings_state.dart';

class StandingsBloc extends Bloc<StandingsEvent, StandingsState> {
  StandingsBloc() : super(const StandingsInitial()) {
    on<StandingsRequested>((event, emit) => emit(const StandingsInitial()));
  }
}
