import 'package:decentragram/core/colors.dart';
import 'package:decentragram/core/dimens.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:decentragram/features/user_features/user_bloc/user_bloc.dart';
import 'package:decentragram/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  UserBloc bloc = UserBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (BuildContext context) => bloc..add(GetPostType()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                MaterialCommunityIcons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Router.navigator.pop();
              }),
          title: Text("Add a new post"),
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
              if (state is AskPostType) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton.icon(
                          splashColor: primaryColor,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: primaryColor
                          ),
                          borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            bloc..add(PostType(type: "Image"));
                          },
                          icon: Icon(MaterialCommunityIcons.image),
                          label: Text("Image", style: TextStyle(
                            fontSize: 30
                          ),)),
                        SizedBox(
                          height: 50,
                        ),
                      FlatButton.icon(
                      splashColor: primaryColor,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: primaryColor
                      ),
                      borderRadius: BorderRadius.circular(5)),
                      onPressed: () {
                        bloc..add(PostType(type: "Text"));
                      },
                      icon: Icon(MaterialCommunityIcons.text),
                      label: Text("Text", style: TextStyle(
                        fontSize: 30
                      ),)),
                    ],
                  ),
                );
              }
            },
            listener: (BuildContext context, UserState state) {}),
      ),
    );
  }
}
