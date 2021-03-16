import 'package:decentragram/features/auth/data/user_repository.dart';
import 'package:decentragram/features/auth/presentation/bloc/new_user_bloc/new_user_bloc.dart';
import 'package:decentragram/features/dashboard_screen.dart';
import 'package:decentragram/features/new_user_profile/new_user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;
  HomeScreen({@required this.userRepository});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserRepository get userRepository => widget.userRepository;
  // ignore: close_sinks
  final NewUserBloc bloc = NewUserBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NewUserBloc>(
        create: (context) => bloc,
        child: BlocConsumer(
            bloc: bloc..add(CheckIfUserExists()),
            builder: (context, state) {
              if (state is NewUserInitial)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else if (state is UserExists)
                return DashboardScreen();
              else if (state is UserDoesNotExist)
                return NewUserDetailsScreen();
            },
            listener: (context, state) {}),
      ),
    );
  }
}
