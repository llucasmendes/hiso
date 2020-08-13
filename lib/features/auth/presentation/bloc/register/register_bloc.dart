import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:hiso/core/singletons/user.dart';
import 'package:hiso/features/auth/domain/usecases/register/register_user_data.dart';
import 'package:hiso/features/auth/domain/usecases/register/register_with_email.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    @required this.registerWithEmail,
    @required this.registerUserData,
  })  : assert(registerWithEmail != null),
        assert(registerUserData != null),
        super(RegisterInitial());

  final RegisterWithEmail registerWithEmail;
  final RegisterUserData registerUserData;

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterEmailStarted) {
      yield* _mapToEmailStarted(event);
    }
    if (event is RegisterButtomPressed) {
      yield RegisterButtom(estado: event.estado);
    }
  }

  Stream<RegisterState> _mapToEmailStarted(RegisterEmailStarted event) async* {
    if (event.password.length < 6) {
      yield RegisterFailure(message: 'A senha deve ter no mínimo 6 caracteres');
      return;
    }
    if (event.password != event.passwordRepeat) {
      yield RegisterFailure(message: 'Primeira senha diferente da segunda');
      return;
    }
    yield RegisterLoadInProgress();
    final result = await registerWithEmail(
      AuthParams(
        email: event.email,
        password: event.password,
      ),
    );
    yield* result.fold(
      (failure) async* {
        yield RegisterFailure(message: failure.message);
      },
      (user) async* {
        User.instance.setId(user.firebaseUser.uid);
        User.instance.setEmail(user.firebaseUser.email);
        yield* _mapToRegisterUserData(event);
      },
    );
  }

  Stream<RegisterState> _mapToRegisterUserData(
      RegisterEmailStarted event) async* {
    final result = await registerUserData(
      DataParams(
        name: event.name,
        accountType: event.accountType,
        phone: event.phone,
      ),
    );
    yield result.fold(
      (failure) => RegisterFailure(
        message: 'Ocorreu uma falha ao salvar seus dados. '
            'Reinicie o aplicativo e tente novamente.',
      ),
      (_) => RegisterSuccess(),
    );
  }
}
