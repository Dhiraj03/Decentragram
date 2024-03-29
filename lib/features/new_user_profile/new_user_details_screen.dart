import 'dart:io';

import 'package:decentragram/core/colors.dart';
import 'package:decentragram/core/dimens.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:decentragram/features/dashboard_screen.dart';
import 'package:decentragram/features/new_user_profile/new_user_profile_bloc/new_user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class NewUserDetailsScreen extends StatefulWidget {
  @override
  _NewUserDetailsScreenState createState() => _NewUserDetailsScreenState();
}

class _NewUserDetailsScreenState extends State<NewUserDetailsScreen> {
  NewUserProfileBloc bloc = NewUserProfileBloc();
  final usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<NewUserProfileBloc>(
      create: (context) => bloc,
      child: BlocConsumer<NewUserProfileBloc, NewUserProfileState>(buildWhen:
          (NewUserProfileState prevState, NewUserProfileState currState) {
        if (prevState is NewUserProfileInitial &&
            (currState is Success || currState is Failure)) {
          return false;
        }
        return true;
      }, builder: (BuildContext context, NewUserProfileState state) {
        if (state is RedirectToDashboard)
          return DashboardScreen();
        else if (state is NewUserProfileInitial)
          return Scaffold(
            appBar: AppBar(
              title: Text("Save Profile"),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                    icon: Icon(FlutterIcons.log_out_fea),
                    onPressed: () =>
                        BlocProvider.of<AuthBloc>(context)..add(LoggedOut()))
              ],
            ),
            body: Container(
              child: ListView(
                padding: stdPadding,
                physics: ScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: state.image == null
                                ? DecorationImage(
                                    image: AssetImage("assets/person_icon.png"),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter)
                                : DecorationImage(
                                    image: FileImage(File(state.image.path)),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2)),
                      ),
                    ),
                  ),
                  Center(
                    child: IconButton(
                        icon: Icon(
                          MaterialCommunityIcons.image_plus,
                          color: Theme.of(context).primaryColor.withAlpha(220),
                          size: 25,
                        ),
                        onPressed: () async {
                          bloc..add(SaveProfileImage());
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          icon: Icon(FlutterIcons.person_mdi),
                          labelText: "Username"),
                    ),
                  ),
                  Center(
                    child: FlatButton(
                        shape: flatButtonBorder,
                        color: Theme.of(context).primaryColor.withAlpha(220),
                        child: Text('Save Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        onPressed: () {
                          BlocProvider.of<NewUserProfileBloc>(context)
                            ..add(
                                SubmitForm(username: usernameController.text));
                        }),
                  )
                ],
              ),
            ),
          );
      }, listener: (BuildContext context, NewUserProfileState state) {
        if (state is Success) {
          Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: successColor,
              content: Text("Success! Transaction Hash: " + state.txHash)));
        } else if (state is Failure) {
          Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: successColor,
              content: Text("Failure! " + state.errorMessage)));
        }
      }),
    ));
  }
}
