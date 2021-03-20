import 'package:decentragram/core/colors.dart';
import 'package:decentragram/core/dimens.dart';
import 'package:decentragram/database/firestore_repository.dart';
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
      create: (BuildContext context) =>
          bloc..add(GetSearchUserProfile(userAddress: user.userAddress)),
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
        body: BlocConsumer<UserBloc, UserState>(
          builder: (BuildContext context, UserState state) {
            if (state is SearchUserProfile) {
              return Padding(
                padding: stdPadding,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          minRadius: 90,
                          maxRadius: 90,
                          backgroundImage: MemoryImage(user.profileImage)),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Username",
                          style: TextStyle(fontSize: 16, color: grey)),
                      Text(
                        user.username,
                        style: TextStyle(fontSize: 27),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text("User Address",
                          style: TextStyle(fontSize: 16, color: grey)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        user.userAddress,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      state.following
                          ? FlatButton.icon(
                              onPressed: () {
                                // bloc
                                //   ..add(FollowProfile(
                                //       userAddress: user.userAddress));
                              },
                              icon: Icon(
                                FlutterIcons.user_following_sli,
                                color: primaryColor,
                              ),
                              label: Text('Following'))
                          : FlatButton.icon(
                              onPressed: () {
                                bloc
                                  ..add(FollowProfile(
                                      userAddress: user.userAddress));
                              },
                              icon: Icon(
                                Ionicons.md_person_add,
                                color: primaryColor,
                              ),
                              label: Text('Follow'))
                    ],
                  ),
                ),
              );
            } else 
              return Center(child: CircularProgressIndicator());
          },
          buildWhen: (UserState prevState, UserState currState) {
            if (currState is Loading || currState is Success) {
              return false;
            }
            return true;
          },
          listener: (BuildContext context, UserState state) {
            if(state is Loading)
            Scaffold.of(context)
            .showSnackBar(SnackBar(content: CircularProgressIndicator(), backgroundColor: secondaryColor,));
             else if (state is Success)
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(state.txHash), backgroundColor: secondaryColor,));
          },
        ),
      ),
    );
  }
}
