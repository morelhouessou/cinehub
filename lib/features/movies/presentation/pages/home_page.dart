import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_constants.dart';
import '../bloc/movie_cubit.dart';
import 'movie_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineHub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MovieCubit>().loadHome(),
          ),
        ],
      ),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          if (state.error != null && state.popular.isEmpty) {
            return Center(child: Text(state.error!));
          }
          return RefreshIndicator(
            onRefresh: () => context.read<MovieCubit>().loadHome(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (state.error != null)
                  Card(child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Mode hors-ligne : données en cache affichées.'),
                  )),
                _section(context, 'Films populaires', state.popular),
                _section(context, 'Mieux notés', state.topRated),
                _section(context, 'À l’affiche', state.nowPlaying),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _section(BuildContext context, String title, List movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 10),
        SizedBox(
          height: 245,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (_, i) {
              final movie = movies[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie)),
                ),
                child: Container(
                  width: 145,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            width: 145,
                            fit: BoxFit.cover,
                            imageUrl: movie.posterPath.isEmpty
                                ? 'https://via.placeholder.com/300x450'
                                : '${ApiConstants.imageBaseUrl}${movie.posterPath}',
                            errorWidget: (_, __, ___) => const Icon(Icons.movie),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('⭐ ${movie.rating.toStringAsFixed(1)}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
