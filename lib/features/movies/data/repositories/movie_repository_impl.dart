import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_data_source.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remote;
  final MovieLocalDataSource local;
  MovieRepositoryImpl({required this.remote, required this.local});

  Future<List<Movie>> _load(
    Future<List<MovieModel>> Function() remoteCall,
    String key,
  ) async {
    try {
      final movies = await remoteCall();
      await local.save(key, movies);
      return movies;
    } catch (_) {
      final cached = local.get(key);
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getPopular() => _load(remote.getPopular, 'popular_movies');

  @override
  Future<List<Movie>> getTopRated() => _load(remote.getTopRated, 'top_rated_movies');

  @override
  Future<List<Movie>> getNowPlaying() => _load(remote.getNowPlaying, 'now_playing_movies');
}
