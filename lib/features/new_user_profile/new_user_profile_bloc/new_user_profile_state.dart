part of 'new_user_profile_bloc.dart';

abstract class NewUserProfileState extends Equatable {
  const NewUserProfileState();

  @override
  List<Object> get props => [];
}

class NewUserProfileInitial extends NewUserProfileState {
  File image;
  NewUserProfileInitial({@required this.image});
  @override
  List<Object> get props => [image];
}

class RedirectToDashboard extends NewUserProfileState {}

class Success extends NewUserProfileState {
  String txHash;
  Success({@required this.txHash});
  @override
  List<Object> get props => [txHash];
}

class Failure extends NewUserProfileState {
  String errorMessage;
  Failure({@required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
