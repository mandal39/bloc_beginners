part of 'counter_bloc.dart';

class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class IncrementCounterEvent extends CounterEvent {}

class DecrementCounterEvent extends CounterEvent {}

class ChangeCounterEvent extends CounterEvent {
  final int incrementSize;
  ChangeCounterEvent({
    required this.incrementSize,
  });

  @override
  List<Object> get props => [incrementSize];
}
