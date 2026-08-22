import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cinehub/features/movies/data/datasources/movie_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late MovieRemoteDataSource dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = MovieRemoteDataSource(dio);
  });

  test('parses TMDB results into movie models', () async {
    when(() => dio.get('/movie/popular')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/movie/popular'),
        data: {
          'results': [
            {
              'id': 1,
              'title': 'Test',
              'overview': 'Overview',
              'poster_path': null,
              'vote_average': 8.5,
              'release_date': '2026-01-01',
            },
          ],
        },
      ),
    );

    final movies = await dataSource.getPopular();

    expect(movies.single.title, 'Test');
    expect(movies.single.rating, 8.5);
  });

  test('rejects malformed TMDB responses', () {
    when(() => dio.get('/movie/popular')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/movie/popular'),
        data: {'items': []},
      ),
    );

    expect(dataSource.getPopular, throwsFormatException);
  });
}