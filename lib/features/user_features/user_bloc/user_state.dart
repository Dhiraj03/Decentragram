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
  final List<PostModel> posts;
  UserProfile({@required this.profile, @required this.posts});
  @override
  List<Object> get props => [profile, posts];
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
  final String message;
  Success({@required this.message});
  @override
  List<Object> get props => [message];
}

class RedirectToDashboard extends UserState {
  @override
  List<Object> get props => [];
}

class SearchUserProfile extends UserState {
  final bool following;
  final String followAddress;
  final UserModel user;
  final List<PostModel> posts;
  SearchUserProfile(
      {@required this.following, @required this.posts, @required this.user, @required this.followAddress});
  @override
  List<Object> get props => [];
}

class UserPosts extends UserState {
  final List<PostModel> posts;
  UserPosts({@required this.posts});
  @override
  List<Object> get props => [posts];
}
