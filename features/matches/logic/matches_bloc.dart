import 'package:bloc/bloc.dart';

import 'matches_event.dart';
import 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  MatchesBloc() : super(const MatchesInitial()) {
    on<MatchesRequested>((event, emit) => emit(const MatchesLoading()));
  }
}
