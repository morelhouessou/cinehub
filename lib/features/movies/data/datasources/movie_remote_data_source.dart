import 'package:dio/dio.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  final Dio dio;
  MovieRemoteDataSource(this.dio);

  Future<List<MovieModel>> _get(String path) async {
    final response = await dio.get(path);
    final data = response.data;
    if (data is! Map || data['results'] is! List) {
      throw const FormatException('Réponse TMDB invalide.');
    }
    return (data['results'] as List)
        .whereType<Map>()
        .map((item) => MovieModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<List<MovieModel>> getPopular() => _get('/movie/popular');
  Future<List<MovieModel>> getTopRated() => _get('/movie/top_rated');
  Future<List<MovieModel>> getNowPlaying() => _get('/movie/now_playing');
}
