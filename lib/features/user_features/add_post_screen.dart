import 'package:decentragram/core/colors.dart';
import 'package:decentragram/core/dimens.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:decentragram/features/auth/presentation/bloc/new_user_bloc/new_user_bloc.dart';
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
  TextEditingController captionController = TextEditingController();
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
                          bloc..add(PostType(type: "Text"));
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
          } else if (state is ImagePostType) {
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    state.image != null
                        ? Center(
                            child: Image(
                            image: FileImage(state.image),
                            height: 320,
                            fit: BoxFit.fitWidth,
                          ))
                        : Opacity(
                            opacity: 0.1,
                            child: Center(
                              child: Image(
                                image: AssetImage("assets/upload_image.png"),
                                height: 320,
                                color: grey,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton.icon(
                        splashColor: primaryColor.withOpacity(0.1),
                        onPressed: () {
                          bloc..add(PickImagePost());
                        },
                        icon: Icon(
                          MaterialCommunityIcons.image_plus,
                          color: primaryColor,
                        ),
                        label: Text(
                          "Choose image",
                          style: TextStyle(fontSize: 20),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13.0),
                      child: TextFormField(
                          maxLength: 256,
                          maxLines: 3,
                          maxLengthEnforced: true,
                          style: TextStyle(fontSize: 17, height: 1.35),
                          controller: captionController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(13),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor.withOpacity(0.1)),
                                  borderRadius: BorderRadius.circular(5)))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton(
                        backgroundColor: primaryColor,
                        child: Icon(
                          Icons.publish,
                          size: 40,
                        ),
                        onPressed: () {
                          bloc
                            ..add(PublishImagePost(
                                caption: captionController.text.isEmpty
                                    ? "null"
                                    : captionController.text));
                        })
                  ],
                ),
              ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        }, buildWhen: (UserState prevState, UserState currState) {
          if (currState is Success ||
              currState is Failure ||
              currState is RedirectToDashboard) {
            return false;
          }
          return true;
        }, listener: (BuildContext context, UserState state) {
          if (state is Success) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(state.txHash)));
          } else if (state is Failure) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is RedirectToDashboard) {
            Router.navigator.pop();
          }
        }),
      ),
    );
  }
}
