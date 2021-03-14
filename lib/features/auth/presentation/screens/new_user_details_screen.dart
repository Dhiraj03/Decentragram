import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewUserDetailsScreen extends StatefulWidget {
  @override
  _NewUserDetailsScreenState createState() => _NewUserDetailsScreenState();
}

class _NewUserDetailsScreenState extends State<NewUserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.backspace), onPressed: () => BlocProvider.of<AuthBloc>(context)..add(LoggedOut())),
      ),
      body: Center(
        child: Text('New User Details Screen'),
      ),
    );
  }
}
