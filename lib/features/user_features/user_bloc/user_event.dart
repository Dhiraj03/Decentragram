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
  final String userAddress;
  GetMyProfile({@required this.userAddress});
  @override
  List<Object> get props => [userAddress];
}
