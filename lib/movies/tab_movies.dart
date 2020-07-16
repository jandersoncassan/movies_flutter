import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies_udemy/movies/movie.dart';
import 'package:flutter_movies_udemy/movies/movie_page.dart';
import 'package:flutter_movies_udemy/movies/movies_bloc.dart';
import 'package:flutter_movies_udemy/utils/nav.dart';
import 'package:flutter_movies_udemy/widgets/text_empty.dart';
import 'package:flutter_movies_udemy/widgets/text_error.dart';

class TabMovies extends StatefulWidget {
  @override
  _TabMoviesState createState() => _TabMoviesState();
}

class _TabMoviesState extends State<TabMovies>
    with AutomaticKeepAliveClientMixin<TabMovies> { //AutomaticKeepAliveClientMixin mantem o estado

  @override
  bool get wantKeepAlive => true; //manter estado, não ficar atualizando toda hora

  //BlocProvider tem a responsabilidade de fazer a gestão do estado, chamando o dispose e etc, para isso funcionar, precisamos declarar esses blocks, nesse caso
  //declaramos no arquivo home_page.dart, porque ele só chama o dispose quando a minha tela que declara não estiver mais em memória,
  // mas poderia ser no arquivo main tbm sem problemas! mas dai só seria chamado o dispose se saissemos do aplicativo
  final bloc = BlocProvider.getBloc<MoviesBloc>();

  @override
  void initState() {
    super.initState();

    bloc.fetch(); //chamaos o fetch aqui para carregar a lista de filmes
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.stream, //ficamos escutando a stream para atualização
      builder: (context, snapshot) {
        if (snapshot.hasError) { //tratamos o erro com hasError para seguir o padrão qdo utilizamos Stream
          // Erro
          return Center(
            child: TextError(
              snapshot.error, //mensagem de erro que adicionamos lá na integração
              onRefresh: _onRefreshError, // ao clicar tentamos buscar a lista novamente
            ),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(), // tratamos lá no bloc, quando for refresh adicionamos o null para mostrar esse lance
          );
        }

        List<Movie> movies = snapshot.data;

        return movies.isEmpty
            ? TextEmpty("Nenhum filme.")
            : _griView(movies, context);
      },
    );
  }

  _griView(List<Movie> movies, context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: GridView.builder(
        gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return _item(movies, index, context);
        },
      ),
    );
  }

  _item(List<Movie> movies, index, context) {
    Movie m = movies[index];

    // Tag para a animação do Hero
    m.tag = m.title;

    return Material(
      child: InkWell(
        child: Hero(
          tag: m.tag,
          child: Image.network(
            m.urlFoto,
            fit: BoxFit.cover,
          ),
        ),
        onTap: () {
          _onClickMovie(m);
        },
      ),
    );
  }

  void _onClickMovie(Movie m) {
    push(context, MoviePage(m));
  }

  Future<void> _onRefresh() {
    return bloc.fetch();
  }

  Future<void> _onRefreshError() {
    return bloc.fetch(isRefresh: true);
  }
}
