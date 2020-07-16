import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_movies_udemy/utils/progress_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SimpleBloc<T> extends BlocBase {
  final progress = ProgressBloc(); //esse bloc é para controlar o lance de progressCircular

  // stream
  final _controller = BehaviorSubject<T>(); //BehaviorSubject controla todos streams do dart
  get stream => _controller.stream; // os ouvintes precisam dessa stream ficam ecutando

  get add => _controller.sink.add; //adiciona os objetos, retornamos uma função

  get addError => _controller.sink.addError; //adicviona os objetos de erro, retornamos uma função

  @override
  void dispose() {
    super.dispose();

    _controller.close();

    progress.close();
    print('>> DISPOSE AO VIVO ');
  }

}
