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
