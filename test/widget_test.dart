// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cinehub/app.dart';
import 'package:cinehub/features/auth/domain/repositories/auth_repository.dart';
import 'package:cinehub/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:cinehub/features/movies/domain/repositories/movie_repository.dart';
import 'package:cinehub/features/movies/presentation/bloc/movie_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  testWidgets('displays the CineHub home sections', (tester) async {
    final repository = MockMovieRepository();
    final movieCubit = MovieCubit(repository);
    final authRepository = MockAuthRepository();
    when(() => authRepository.isConfigured).thenReturn(true);
    when(() => authRepository.isAuthenticated).thenReturn(true);
    final authCubit = AuthCubit(authRepository)..checkSession();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authCubit),
          BlocProvider.value(value: movieCubit),
        ],
        child: const CineHubApp(),
      ),
    );

    expect(find.text('CineHub'), findsOneWidget);
    expect(find.text('Films populaires'), findsOneWidget);
    expect(find.text('Mieux notés'), findsOneWidget);
    expect(find.text('À l’affiche', skipOffstage: false), findsOneWidget);

    await movieCubit.close();
    await authCubit.close();
  });
}
