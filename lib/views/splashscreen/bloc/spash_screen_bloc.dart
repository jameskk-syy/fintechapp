import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'spash_screen_event.dart';
part 'spash_screen_state.dart';

class SpashScreenBloc extends Bloc<SpashScreenEvent, SpashScreenState> {
  SpashScreenBloc() : super(SpashScreenInitial()) {
    on<SpashScreenInitialEvent>(SpashScreenInitialEvents);
  }

  Future<void> SpashScreenInitialEvents(SpashScreenInitialEvent event, Emitter<SpashScreenState> emit) async {
     emit(SplashScreenLoading());
    try{
      await Future.delayed(const Duration(seconds: 3), () {
      emit(SplashScreenLoaded());
    });
    }catch(e){ 
      emit(SplashScreenError(e.toString()));
    }
  }
}
