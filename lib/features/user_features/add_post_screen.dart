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
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          splashColor: primaryColor.withOpacity(0.1),
                          onTap: () {
                            bloc..add(PostType(type: "Image"));
                          },
                          child: Stack(
                            children: [
                              Opacity(
                                  opacity: 0.1,
                                  child: Center(
                                      child: Image(
                                          image: AssetImage("assets/image.png"),
                                          width: 340,
                                          height: 320,
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment.center))),
                              Center(
                                  child: Text(
                                "Image",
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            splashColor: primaryColor.withOpacity(0.1),
                            onTap: () {
                              bloc..add(PostType(type: "Image"));
                            },
                            child: Stack(
                              children: [
                                Opacity(
                                    opacity: 0.1,
                                    child: Center(
                                        child: Image(
                                      image: AssetImage("assets/text.png"),
                                      width: 340,
                                      height: 320,
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.center,
                                    ))),
                                Center(
                                    child: Text(
                                  "Text",
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ))
                              ],
                            ),
                          )),
                    ],
                  ),
                );
              } else
                return CircularProgressIndicator();
            },
            listener: (BuildContext context, UserState state) {}),
      ),
    );
  }
}
