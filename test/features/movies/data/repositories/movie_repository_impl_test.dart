import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cinehub/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:cinehub/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:cinehub/features/movies/data/models/movie_model.dart';
import 'package:cinehub/features/movies/data/repositories/movie_repository_impl.dart';

class MockRemote extends Mock implements MovieRemoteDataSource {}
class MockLocal extends Mock implements MovieLocalDataSource {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late MovieRepositoryImpl repository;

  final movie = const MovieModel(
    id: 1, title: 'Test', overview: 'Overview',
    posterPath: '', rating: 8.0, releaseDate: '2026-01-01',
  );

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repository = MovieRepositoryImpl(remote: remote, local: local);
  });

  test('returns remote popular movies when API succeeds', () async {
    when(() => remote.getPopular()).thenAnswer((_) async => [movie]);
    when(() => local.save(any(), any())).thenAnswer((_) async {});
    when(() => local.get('popular_movies')).thenReturn([]);
    final result = await repository.getPopular();
    expect(result.length, 1);
    expect(result.first.title, 'Test');
  });

  test('returns cache when API fails', () async {
    when(() => remote.getPopular()).thenThrow(Exception('offline'));
    when(() => local.get('popular_movies')).thenReturn([movie]);
    final result = await repository.getPopular();
    expect(result.first.id, 1);
  });

  test('throws when API and cache both fail', () async {
    when(() => remote.getPopular()).thenThrow(Exception('offline'));
    when(() => local.get('popular_movies')).thenReturn([]);
    expect(() => repository.getPopular(), throwsException);
  });
}
