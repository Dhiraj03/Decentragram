part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserFound extends UserState {
  final UserModel user;
  UserFound({@required this.user});
  @override
  List<Object> get props => [user];
}

class Failure extends UserState {
  final String errorMessage;
  Failure({@required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
