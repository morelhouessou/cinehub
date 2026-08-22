class ApiConstants {
  static const tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const cacheBox = 'cinehub_cache';
  static const popularKey = 'popular_movies';
  static const topRatedKey = 'top_rated_movies';
  static const nowPlayingKey = 'now_playing_movies';

  static String get tmdbApiKey =>
      const String.fromEnvironment('TMDB_API_KEY');
}
