import 'package:flutter_movies_udemy/login/login_api.dart';
import 'package:flutter_movies_udemy/utils/progress_bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final progress = ProgressBloc();

  login(LoginInput input) async {
    progress.setProgress(true); //sink é onde enviamos as informações para os ouvintes, nesse caso ficará girando

    try {
      return await LoginApi.login(input);
    } finally {
      progress.setProgress(false); // aqui ao passar 'false' ele para de girar
    }
  }

  close() {
    progress.close();
  }
}
