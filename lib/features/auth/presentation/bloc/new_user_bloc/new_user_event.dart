part of 'new_user_bloc.dart';

abstract class NewUserEvent extends Equatable {
  const NewUserEvent();

  @override
  List<Object> get props => [];
}

class CheckIfUserExists extends NewUserEvent {}