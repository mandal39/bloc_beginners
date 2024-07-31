import 'dart:math';

import 'package:bloc_inc_dec/blocs/color/color_bloc.dart';
import 'package:bloc_inc_dec/blocs/theme/theme_bloc.dart';
import 'package:bloc_inc_dec/show_me_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_inc_dec/blocs/counter/counter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ColorBloc>(
          create: (context) => ColorBloc(),
        ),
        BlocProvider<CounterBloc>(
          create: (context) => CounterBloc(),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Event Payload',
            theme: state.appTheme == AppTheme.light
                ? ThemeData.light()
                : ThemeData.dark(),
            home: const MyHomePage(title: 'Theme'),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int incrementSize = 1;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ColorBloc, ColorState>(
      listener: (context, colorState) {
        if (colorState.color == Colors.red) {
          incrementSize = 1;
        } else if (colorState.color == Colors.green) {
          incrementSize = 10;
        } else if (colorState.color == Colors.blue) {
          incrementSize = 100;
          context
              .read<CounterBloc>()
              .add(ChangeCounterEvent(incrementSize: incrementSize));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: context.watch<ColorBloc>().state.color,
        body: BlocListener<CounterBloc, CounterState>(
          listener: (context, state) {
            if (state.counter == 3) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('counter is ${state.counter}'),
                  );
                },
              );
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text(
                    'ChangeTheme',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    final int randInt = Random().nextInt(10);
                    print(randInt);
                    context
                        .read<ThemeBloc>()
                        .add(ChangeThemeEvent(randInt: randInt));
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text(
                    'Change Color',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    context.read<ColorBloc>().add(ChangeColorEvent());
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text(
                    'Increment Counter',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    context
                        .read<CounterBloc>()
                        .add(ChangeCounterEvent(incrementSize: incrementSize));
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text(
                    'Show Me Counter',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (contex) {
                        return ShowMeCounter();
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                BlocProvider.of<CounterBloc>(context)
                    .add(IncrementCounterEvent());
              },
              heroTag: 'increment',
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: () {
                BlocProvider.of<CounterBloc>(context)
                    .add(DecrementCounterEvent());
              },
              heroTag: 'decrement',
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}
