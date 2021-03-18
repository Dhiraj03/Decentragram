import 'package:decentragram/core/colors.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:decentragram/features/user_features/user_bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UserFeed extends StatefulWidget {
  @override
  _UserFeedState createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed> {
  UserBloc bloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
          icon: Icon(FlutterIcons.log_out_fea),
          onPressed: () =>
              BlocProvider.of<AuthBloc>(context)..add(LoggedOut()))
        ],
        ),
        body: Center(
          child: Text('Dashboard'),
        ),
      ),
    );
  }
}
