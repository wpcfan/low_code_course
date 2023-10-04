import 'package:auth/blocs/blocs.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockAuthState extends Fake implements AuthState {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {}
