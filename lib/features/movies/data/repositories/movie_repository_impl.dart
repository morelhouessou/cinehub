import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failures.dart';
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
    } on DioException catch (error) {
      final cached = local.get(key);
      if (cached.isNotEmpty) return cached;
      throw MovieFailure(
        error.type == DioExceptionType.connectionError ||
                error.type == DioExceptionType.connectionTimeout
            ? 'Connexion impossible. Vérifiez votre connexion internet.'
            : 'Le service des films est temporairement indisponible.',
      );
    } catch (_) {
      final cached = local.get(key);
      if (cached.isNotEmpty) return cached;
      throw const MovieFailure('Impossible de charger les films.');
    }
  }

  @override
  Future<List<Movie>> getPopular() =>
      _load(remote.getPopular, ApiConstants.popularKey);

  @override
  Future<List<Movie>> getTopRated() =>
      _load(remote.getTopRated, ApiConstants.topRatedKey);

  @override
  Future<List<Movie>> getNowPlaying() =>
      _load(remote.getNowPlaying, ApiConstants.nowPlayingKey);
}
