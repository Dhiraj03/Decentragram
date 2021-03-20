// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:decentragram/main.dart';
import 'package:decentragram/features/user_features/add_post_screen.dart';
import 'package:decentragram/features/user_features/search_user_profile_screen.dart';
import 'package:decentragram/models/user_model.dart';

class Router {
  static const homePage = '/';
  static const addPostScreen = '/add-post-screen';
  static const searchUserProfileScreen = '/search-user-profile-screen';
  static final navigator = ExtendedNavigator();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.homePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => HomePage(),
          settings: settings,
        );
      case Router.addPostScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddPostScreen(),
          settings: settings,
        );
      case Router.searchUserProfileScreen:
        if (hasInvalidArgs<UserModel>(args, isRequired: true)) {
          return misTypedArgsRoute<UserModel>(args);
        }
        final typedArgs = args as UserModel;
        return MaterialPageRoute<dynamic>(
          builder: (_) => SearchUserProfileScreen(user: typedArgs),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
