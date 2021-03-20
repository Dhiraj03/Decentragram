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

class UserProfile extends UserState {
  final UserModel profile;
  UserProfile({@required this.profile});
  @override
  List<Object> get props => [profile];
}

class Failure extends UserState {
  final String errorMessage;
  Failure({@required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class Loading extends UserState {
  @override
  List<Object> get props => [];
}

class AskPostType extends UserState {
  @override
  List<Object> get props => [];
}

class ImagePostType extends UserState {
  final File image;
  ImagePostType({this.image});
  @override
  List<Object> get props => [image];
}

class TextPostType extends UserState {
  @override
  List<Object> get props => [];
}

class Success extends UserState {
  final String txHash;
  Success({@required this.txHash});
  @override
  List<Object> get props => [txHash];
}

class RedirectToDashboard extends UserState {
  @override
  List<Object> get props => [];
}
