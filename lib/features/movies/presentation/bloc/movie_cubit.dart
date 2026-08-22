import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';

class MovieState {
  final bool loading;
  final String? error;
  final List<Movie> popular;
  final List<Movie> topRated;
  final List<Movie> nowPlaying;
  const MovieState({
    this.loading = false, this.error,
    this.popular = const [], this.topRated = const [], this.nowPlaying = const [],
  });
}

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository repository;
  MovieCubit(this.repository) : super(const MovieState());

  Future<void> loadHome() async {
    emit(MovieState(loading: true));
    try {
      final results = await Future.wait([
        repository.getPopular(),
        repository.getTopRated(),
        repository.getNowPlaying(),
      ]);
      emit(MovieState(popular: results[0], topRated: results[1], nowPlaying: results[2]));
    } catch (e) {
      emit(MovieState(error: 'Impossible de charger les films. Vérifiez votre connexion.'));
    }
  }
}
