import 'package:decentragram/core/colors.dart';
import 'package:decentragram/core/dimens.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:decentragram/features/user_features/user_bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  UserBloc bloc = UserBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (_) => bloc..add(GetMyProfile()),
      child: Scaffold(
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
        body: BlocConsumer<UserBloc, UserState>(
          builder: (BuildContext context, UserState state) {
            if (state is UserProfile) {
              return Container(
                alignment: Alignment.center,
                padding: searchBarPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        minRadius: 90,
                        maxRadius: 90,
                        backgroundImage:
                            MemoryImage(state.profile.profileImage)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Username", style:TextStyle(
                      fontSize: 16,
                      color: grey
                    )),
                    Text(
                      state.profile.username,
                      style: TextStyle(fontSize: 27),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("User Address", style:TextStyle(
                      fontSize: 16,
                      color: grey
                    )),
                    Text(state.profile.userAddress, style: TextStyle(fontSize: 20,), overflow: TextOverflow.ellipsis,),
                  ],
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
          listener: (BuildContext context, UserState state) {},
        ),
      ),
    );
  }
}
