import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:tema_curs5_flutter/src/actions/get_movies.dart';
import 'package:tema_curs5_flutter/src/data/ytsApi.dart';
import 'package:meta/meta.dart';
import 'package:tema_curs5_flutter/src/models/appState.dart';
import 'package:tema_curs5_flutter/src/models/movie.dart';

class AppMiddleware {
  const AppMiddleware({@required YtsApi ytsApi})
      : assert(ytsApi != null),
        _ytsApi = ytsApi;

  final YtsApi _ytsApi;

  List<Middleware<AppState>> get middleware {
    return <Middleware<AppState>>[
      _getMoviesMiddleware,
    ];
  }

  Future<void> _getMoviesMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is! GetMovies) {
      return;
    }

    try {
      final List<Movie> movies = await _ytsApi.getMovies();
      final GetMoviesSuccessful successful = GetMoviesSuccessful(movies);
      store.dispatch(successful);
    } catch (e) {
      final GetMoviesError error = GetMoviesError(e);
      store.dispatch(error);
    }
  }
}
