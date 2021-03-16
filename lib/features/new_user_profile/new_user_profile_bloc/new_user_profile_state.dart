part of 'new_user_profile_bloc.dart';

abstract class NewUserProfileState extends Equatable {
  const NewUserProfileState();

  @override
  List<Object> get props => [];
}

class NewUserProfileInitial extends NewUserProfileState {}

class RedirectToDashboard extends NewUserProfileState {}

class SubmittedProfile extends NewUserProfileState {
  String message;
  SubmittedProfile({@required this.message});
  @override
  List<Object> get props => [message];
}
