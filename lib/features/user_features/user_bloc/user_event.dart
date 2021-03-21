part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SearchUser extends UserEvent {
  final String username;
  SearchUser({@required this.username});
  @override
  List<Object> get props => [username];
}

class GetMyProfile extends UserEvent {
  GetMyProfile();
  @override
  List<Object> get props => [];
}

class GetPostType extends UserEvent {
  GetPostType();
  @override
  List<Object> get props => [];
}

class PostType extends UserEvent {
  final String type;
  PostType({@required this.type});
  @override
  List<Object> get props => [type];
}

class PickImagePost extends UserEvent {
  @override
  List<Object> get props => [];
}

class PublishImagePost extends UserEvent {
  final String caption;
  PublishImagePost({@required this.caption});
  @override
  List<Object> get props => [caption];
}

class PublishTextPost extends UserEvent {
  final String caption;
  final String text;
  PublishTextPost({@required this.caption, @required this.text});
  @override
  List<Object> get props => [caption, text];
}

class GetSearchUserProfile extends UserEvent {
  final String userAddress;
  GetSearchUserProfile({@required this.userAddress});
  @override
  List<Object> get props => [userAddress];
}

class FollowProfile extends UserEvent {
  final String userAddress;
  FollowProfile({@required this.userAddress});
  @override
  List<Object> get props => [userAddress];
}

class GetUserPosts extends UserEvent {
  @override
  List<Object> get props => [];
}

class LikePost extends UserEvent {
  final String userAddress;
  final String followAddress;
  final int postID;
  LikePost(
      {@required this.followAddress,
      @required this.postID,
      @required this.userAddress});
  @override
  List<Object> get props => [userAddress, followAddress, postID];
}
