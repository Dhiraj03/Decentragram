part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserFound extends UserState {
  final String userAddress;
  UserFound({@required this.userAddress});
  @override
  List<Object> get props => [userAddress];
}

class Failure extends UserState {
  final String errorMessage;
  Failure({@required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
