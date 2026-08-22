import 'package:dio/dio.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  final Dio dio;
  MovieRemoteDataSource(this.dio);

  Future<List<MovieModel>> _get(String path) async {
    final response = await dio.get(path);
    final results = (response.data['results'] as List).cast<Map<String, dynamic>>();
    return results.map(MovieModel.fromJson).toList();
  }

  Future<List<MovieModel>> getPopular() => _get('/movie/popular');
  Future<List<MovieModel>> getTopRated() => _get('/movie/top_rated');
  Future<List<MovieModel>> getNowPlaying() => _get('/movie/now_playing');
}
