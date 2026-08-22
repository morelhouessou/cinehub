import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.rating,
    required super.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    if (id is! int || title is! String || title.trim().isEmpty) {
      throw const FormatException('Film TMDB invalide: id ou titre manquant.');
    }

    return MovieModel(
      id: id,
      title: title,
      overview: (json['overview'] ?? '') as String,
      posterPath: (json['poster_path'] ?? '') as String,
        rating: (json['vote_average'] is num)
          ? (json['vote_average'] as num).toDouble()
          : 0,
      releaseDate: (json['release_date'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'overview': overview,
    'poster_path': posterPath, 'vote_average': rating,
    'release_date': releaseDate,
  };
}
