import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../color/color_bloc.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  int incrementSize = 1;
  final ColorBloc colorBloc;
  late final StreamSubscription colorSubscriprion;

  CounterBloc({
    required this.colorBloc,
  }) : super(CounterState.initial()) {
    colorSubscriprion = colorBloc.stream.listen((ColorState colorState) {
      if (colorState.color == Colors.red) {
        incrementSize = 1;
      } else if (colorState.color == Colors.green) {
        incrementSize = 10;
      } else if (colorState.color == Colors.blue) {
        incrementSize = 100;
        add(ChangeCounterEvent());
      }
    });

    on<ChangeCounterEvent>((event, emit) {
      emit(state.copyWith(counter: state.counter + incrementSize));
    });
    on<IncrementCounterEvent>((event, emit) {
      emit(state.copyWith(counter: state.counter + 1));
    });
    on<DecrementCounterEvent>(_decrementCounter);
  }

  void _decrementCounter(
    DecrementCounterEvent event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(counter: state.counter - 1));
  }

  @override
  Future<void> close() {
    colorSubscriprion.cancel();
    return super.close();
  }
}
