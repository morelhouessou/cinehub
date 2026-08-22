import 'package:hive/hive.dart';
import '../models/movie_model.dart';

class MovieLocalDataSource {
  final Box box;
  MovieLocalDataSource(this.box);

  Future<void> save(String key, List<MovieModel> movies) async {
    await box.put(key, movies.map((m) => m.toJson()).toList());
  }

  List<MovieModel> get(String key) {
    final raw = box.get(key);
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
