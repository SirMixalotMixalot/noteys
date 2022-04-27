import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Blox extends StatefulWidget {
  const Blox({Key? key}) : super(key: key);

  @override
  State<Blox> createState() => _BloxState();
}

class _BloxState extends State<Blox> {
  late final TextEditingController _controller;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Blocky"),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalid) ? state.invalidValue : null;
            return Center(
              child: Column(
                children: [
                  Text("Current value => ${state.value}"),
                  Visibility(
                    child: Text("Invalid input '$invalidValue'"),
                    visible: invalidValue != null,
                  ),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a number here',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(DecrementEvent(_controller.text));
                        },
                        child: const Text("Decrement (-)"),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(IncrementEvent(_controller.text));
                        },
                        child: const Text("Increment (+)"),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalid extends CounterState {
  final String invalidValue;
  const CounterStateInvalid({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid((0))) {
    on<IncrementEvent>(
      (event, emit) {
        final value = int.tryParse(event.value);
        if (value != null) {
          emit(
            CounterStateValid(value + state.value),
          );
        } else {
          emit(
            CounterStateInvalid(
              invalidValue: event.value,
              previousValue: state.value,
            ),
          );
        }
      },
    );
    on<DecrementEvent>(
      (event, emit) {
        final value = int.tryParse(event.value);
        if (value != null) {
          emit(
            CounterStateValid(state.value - value),
          );
        } else {
          emit(
            CounterStateInvalid(
              invalidValue: event.value,
              previousValue: state.value,
            ),
          );
        }
      },
    );
  }
}
