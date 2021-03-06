import 'package:dartz/dartz.dart';
import 'package:hiso/core/error/failures.dart';
import 'package:hiso/features/auth/domain/entities/auth_user.dart';

abstract class RegisterRepository {
  Future<Either<Failure, AuthUser>> registerWithEmail(
    String email,
    String password,
  );

  Future<Either<Failure, void>> registerUserData(
    String name,
    String accountType,
    String phone,
  );
}
