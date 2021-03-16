import 'dart:io';

import 'package:decentragram/core/dimens.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:decentragram/features/auth/presentation/dashboard_screen.dart';
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
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.backspace),
              onPressed: () =>
                  BlocProvider.of<AuthBloc>(context)..add(LoggedOut())),
        ),
        body: BlocProvider<NewUserProfileBloc>(
          create: (context) => bloc,
          child: BlocConsumer<NewUserProfileBloc, NewUserProfileState>(
              builder: (BuildContext context, NewUserProfileState state) {
            if (state is RedirectToDashboard)
              return DashboardScreen();
            else
              return Container(
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
                              image: bloc.image == null
                                  ? DecorationImage(
                                      image: AssetImage(
                                          "assets/person_icon.png"),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter)
                                  : DecorationImage(
                                      image: FileImage(File(bloc.image.path)),
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
                            color:
                                Theme.of(context).primaryColor.withAlpha(220),
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
                            labelText: "Name"),
                      ),
                    ),
                    Center(
                      child: FlatButton(
                          color: Theme.of(context).primaryColor.withAlpha(220),child: Text('Save Profile'),
                          onPressed: () {
                            BlocProvider.of<NewUserProfileBloc>(context)..add(SubmitForm(username: usernameController.text));
                          }),
                    )
                  ],
                ),
              );
          }, listener: (BuildContext context, NewUserProfileState state) {
            if (state is SubmittedProfile) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          }),
        ));
  }
}
