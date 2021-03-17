import 'package:decentragram/core/colors.dart';
import 'package:decentragram/core/dimens.dart';
import 'package:decentragram/features/user_features/user_bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SearchUserScreen extends StatefulWidget {
  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  UserBloc bloc = UserBloc();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (_) => bloc,
      child: Container(
        child: Scaffold(
            // appBar: AppBar(
            //   title: Text("Search for a user"),
            //   centerTitle: true,
            // ),
            body: Padding(
          padding: searchBarPadding,
          child: BlocConsumer<UserBloc, UserState>(
            builder: (BuildContext context, UserState state) {
              return Column(children: [
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          gapPadding: 0),
                      icon:
                          Icon(MaterialCommunityIcons.account_search_outline)),
                  onChanged: (_) {
                    bloc..add(SearchUser(username: searchController.text));
                  },
                  controller: searchController,
                  autofocus: true,
                ),
                state is Failure
                    ? Padding(
                      padding:  EdgeInsets.only(left: 10.0, right: 10, top: 30),
                      child: Center(
                          child: Column(
                            children: [
                              Image(
                                height: 80,
                                image: AssetImage(
                                  "assets/code-error.png",
                                ),
                                color: grey,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Sorry, we could not find the user you are looking for.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: grey,
                                ),
                              )
                            ],
                          ),
                        ),
                    )
                    : Text('lol')
              ]);
            },
            listener: (BuildContext context, UserState state) {},
          ),
        )),
      ),
    );
  }
}
