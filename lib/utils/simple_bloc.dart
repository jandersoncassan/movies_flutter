import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_movies_udemy/utils/progress_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SimpleBloc<T> extends BlocBase {
  final progress = ProgressBloc();

  // stream
  final _controller = BehaviorSubject<T>(); //BehaviorSubject controla todos streams do dart
  get stream => _controller.stream; // os ouvintes precisam dessa stream ficam ecutando

  get add => _controller.sink.add; //adiciona os objetos

  get addError => _controller.sink.addError; //adicviona os objetos de erro

  @override
  void dispose() {
    super.dispose();

    _controller.close();

    progress.close();
  }

}
