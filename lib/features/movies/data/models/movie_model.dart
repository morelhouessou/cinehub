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
    return MovieModel(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      overview: (json['overview'] ?? '') as String,
      posterPath: (json['poster_path'] ?? '') as String,
      rating: ((json['vote_average'] ?? 0) as num).toDouble(),
      releaseDate: (json['release_date'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'overview': overview,
    'poster_path': posterPath, 'vote_average': rating,
    'release_date': releaseDate,
  };
}
