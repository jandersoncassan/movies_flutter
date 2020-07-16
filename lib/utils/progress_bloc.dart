import 'package:flutter_movies_udemy/login/login_api.dart';
import 'package:rxdart/rxdart.dart';

class ProgressBloc {
  final controller = BehaviorSubject<bool>(); //BehaviorSubject é uma stream do dart encapsula as streams e podemos tipar, nesse caso bool
  get stream => controller.stream; //aqui é onde fica ouvindo

  void setProgress(bool b) {
    controller.sink.add(b); //sink é onde enviamos as informações para os ouvintes, nesse caso ficará girando ou não
  }

//  void setProgressNull(bool b) {
//    _progressController.sink.add(null);
//  }

  close() {
    controller.close();
  }
}
