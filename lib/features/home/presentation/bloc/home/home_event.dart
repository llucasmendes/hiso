part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => throw UnimplementedError();
}

class HomeGetMedicalPacients extends HomeEvent {}

class HomeLogoutStarted extends HomeEvent {}

class HomeGetUserData extends HomeEvent {}
