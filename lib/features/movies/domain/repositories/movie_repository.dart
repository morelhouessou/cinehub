import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getPopular();
  Future<List<Movie>> getTopRated();
  Future<List<Movie>> getNowPlaying();
}
