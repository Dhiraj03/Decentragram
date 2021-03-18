import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Text("My Profile"),
    centerTitle: true,
    elevation: 0,
    actions: [
      IconButton(
      icon: Icon(FlutterIcons.log_out_fea),
      onPressed: () =>
          BlocProvider.of<AuthBloc>(context)..add(LoggedOut()))
    ],
    ),
    );
  }
}