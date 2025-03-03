part of 'color_bloc.dart';

class ColorState extends Equatable {
  final Color color;
  ColorState({
    required this.color,
  });

  factory ColorState.initail() {
    return ColorState(color: Colors.red);
  }

  @override
  List<Object> get props => [color];

  ColorState copyWith({
    Color? color,
  }) {
    return ColorState(
      color: color ?? this.color,
    );
  }

  @override
  String toString() => 'ColorState(color: $color)';
}
