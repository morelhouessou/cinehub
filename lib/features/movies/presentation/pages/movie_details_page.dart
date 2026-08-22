import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/movie.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;
  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (movie.posterPath.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CachedNetworkImage(
                height: 430,
                fit: BoxFit.cover,
                imageUrl: '${ApiConstants.imageBaseUrl}${movie.posterPath}',
              ),
            ),
          const SizedBox(height: 20),
          Text(movie.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('⭐ ${movie.rating.toStringAsFixed(1)} • ${movie.releaseDate}'),
          const SizedBox(height: 20),
          Text(movie.overview.isEmpty ? 'Synopsis indisponible.' : movie.overview),
        ],
      ),
    );
  }
}
