part of 'new_user_profile_bloc.dart';

abstract class NewUserProfileEvent extends Equatable {
  const NewUserProfileEvent();

  @override
  List<Object> get props => [];
}

class SubmitForm extends NewUserProfileEvent {
  String username;
  SubmitForm({@required this.username});

  @override
  List<Object> get props => [username];
}

class SaveProfileImage extends NewUserProfileEvent {
  @override
  List<Object> get props => [];
}
