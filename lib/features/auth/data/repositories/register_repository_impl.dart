import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiso/core/error/exceptions.dart';
import 'package:hiso/core/network/network_info.dart';
import 'package:hiso/features/auth/data/datasources/register_datasource.dart';
import 'package:meta/meta.dart';
import 'package:hiso/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:hiso/features/auth/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  RegisterRepositoryImpl({
    @required this.registerDataSource,
    @required this.networkInfo,
  });

  final RegisterDataSource registerDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, FirebaseUser>> registerWithEmail(
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final user =
            await registerDataSource.registerWithEmail(email, password);
        return Right(user);
      } on FirebaseRegisterException catch (e) {
        String errorMessage = '';
        switch (e.code) {
          case 'ERROR_WEAK_PASSWORD':
            errorMessage = 'A senha digitada não é forte o bastante.';
            break;
          case 'ERROR_INVALID_EMAIL':
            errorMessage = 'O e-mail digitado é inválido.';
            break;
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            errorMessage =
                'Já existe uma conta associada a esse endereço de e-mail.';
            break;
          default:
            errorMessage = 'Ocorrou um erro inesperado';
        }
        return Left(FirebaseLoginFailure(message: errorMessage));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, FirebaseUser>> registerWithFacebook() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, FirebaseUser>> registerWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, FirebaseUser>> registerWithTwitter() {
    throw UnimplementedError();
  }
}
