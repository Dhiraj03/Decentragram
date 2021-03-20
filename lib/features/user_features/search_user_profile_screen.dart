import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:decentragram/features/user_features/user_bloc/user_bloc.dart';
import 'package:decentragram/models/user_model.dart';
import 'package:decentragram/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SearchUserProfileScreen extends StatefulWidget {
  final UserModel user;
  SearchUserProfileScreen({@required this.user});
  @override
  _SearchUserProfileScreenState createState() =>
      _SearchUserProfileScreenState();
}

class _SearchUserProfileScreenState extends State<SearchUserProfileScreen> {
  UserModel get user => widget.user;
  UserBloc bloc = UserBloc();
  @override
  Widget build(BuildContext context) {
    print(user.userAddress);
    return BlocProvider<UserBloc>(
      create: (BuildContext context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 30,
          automaticallyImplyLeading: false,
          title: Text(user.username),
          elevation: 0,
          actions: [
            IconButton(
            icon: Icon(
              MaterialCommunityIcons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Router.navigator.pop();
            }),
          ],
        ),
      ),
    );
  }
}
