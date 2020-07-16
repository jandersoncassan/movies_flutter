import 'package:flutter/material.dart';
import 'package:flutter_movies_udemy/movies/movie.dart';
import 'package:flutter_movies_udemy/movies/movie_bloc.dart';

class MoviePage extends StatefulWidget {
  final Movie movie;

  MoviePage(this.movie);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final _bloc = MovieBloc(); //bloc local, nesse caso não utilizamos o provider, porque esse cara tem o escopo somete nessa tela, ao sair da tela eliminamos ele , esse caso precisamos chamar o dispose lá em baixo !

  Movie get movie => widget.movie; //é uma forma de deixar facil a utilização do que recebemos no construtor da classe

  @override
  void initState() {
    super.initState();

    _bloc.fetchFavorito(movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar( //esse widget é muito legal, tem um lance da rolagem e
        backgroundColor: Colors.deepOrange, //app bar, quando houver a rolagem pra cima
        expandedHeight: 350, // esse tamanho, dai precisamos ver qual o layout para cada situação
        pinned: false, //queremos que o app bar fique oculto e só apareça no momento da rolagem, se colocar 'true' ela fica direto ao fazer o scroll
        actions: <Widget>[
          IconButton(
            icon: StreamBuilder<bool>(
              initialData: false, //já ssumimos 'false' para caso ainda não esteja 'favoritado' o coração apareça sem a cor vermelha
              stream: _bloc.getFavoritos, //fica ligado na stream para verificar se é true ou false, no onclick setamos esses valores
              builder: (context, snapshot) {
                return Icon( //icone do coração para favoritar
                  Icons.favorite,
                  size: 34,
                  color: snapshot.data ? Colors.red : Colors.white,
                );
              },
            ),
            onPressed: () {
              _onClickFavoritar();
            },
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          title: Text("${movie.title}"),
          background: Container(
            child: Hero(
              tag: movie.tag,
              child: Image.network(
                movie.urlFoto,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      SliverList(delegate: _sliver())
    ]);
  }

  _sliver() {
    return SliverChildListDelegate(
      [
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _card(Icons.favorite, movie.vote_count),
                  _card(Icons.star, movie.vote_average),
                ],
              ),
              Row(
                children: <Widget>[
                  _card(Icons.movie, movie.popularity),
                  _card(Icons.date_range, movie.release_date),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(26),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [Colors.red, Colors.deepOrange],
            ),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.description,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Descrição",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 26,
              ),
              Text(
                movie.overview,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(
                height: 26,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _card(IconData icone, dynamic texto) {
    return Container(
      child: Expanded(
        flex: 1,
        child: InkWell(
          onTap: () {
            print("Tap > $texto");
          },
          child: Container(
            padding: EdgeInsets.only(top: 30, bottom: 30, left: 15, right: 15),
            margin: EdgeInsets.all(15),
            decoration: new BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                Icon(
                  icone,
                  color: Colors.deepOrange,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "$texto",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _onClickFavoritar() async {
    _bloc.favoritar(movie);
  }

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
  }
}
