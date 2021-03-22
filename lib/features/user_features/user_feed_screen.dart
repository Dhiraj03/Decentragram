import 'package:decentragram/core/colors.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:decentragram/features/user_features/user_bloc/user_bloc.dart';
import 'package:decentragram/routes/router.gr.dart';
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
      create: (_) => bloc..add(GetUserPosts(self: true)),
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  MaterialCommunityIcons.plus_box_outline,
                  color: Colors.black,
                ),
                onPressed: () {
                  Router.navigator.pushNamed(Router.addPostScreen);
                }),
            title: Text("Feed"),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                  icon: Icon(FlutterIcons.log_out_fea),
                  onPressed: () =>
                      BlocProvider.of<AuthBloc>(context)..add(LoggedOut()))
            ],
          ),
          body: BlocConsumer<UserBloc, UserState>(
              builder: (BuildContext context, UserState state) {
                if (state is UserPosts) {
                  return ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (state.posts[index].isImage)
                          return Text('image');
                        else
                          return Text(state.posts[index].text);
                      });
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              },
              listener: (BuildContext context, UserState state) {})),
    );
  }
}
