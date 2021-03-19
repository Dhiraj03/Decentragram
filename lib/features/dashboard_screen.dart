import 'package:decentragram/core/colors.dart';
import 'package:decentragram/core/dimens.dart';
import 'package:decentragram/features/user_features/add_post_screen.dart';
import 'package:decentragram/features/user_features/my_profile_screen.dart';
import 'package:decentragram/features/user_features/search_user_screen.dart';
import 'package:decentragram/features/user_features/user_bloc/user_bloc.dart';
import 'package:decentragram/features/user_features/user_feed_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  PageController pageController;
  TabController tabController;
  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          height: 50,
          child: TabBar(
              labelColor: primaryColor,
              indicatorColor: primaryColor,
              unselectedLabelColor: grey,
              controller: tabController,
              onTap: (tabIndex) {
                pageController.jumpToPage(tabIndex);
              },
              tabs: [
                Tab(
                    iconMargin: iconMargin,
                    icon: Icon(MaterialCommunityIcons.home)),
                Tab(
                    iconMargin: iconMargin,
                    icon: Icon(MaterialCommunityIcons.account_search)),
                Tab(
                iconMargin: iconMargin,
                icon: Icon(FlutterIcons.account_box_mco)),
                Tab(
                iconMargin: iconMargin,
                icon: Icon(MaterialCommunityIcons.plus_box_outline,)),
              ]),
        ),
        body: PageView(
          onPageChanged: (pageIndex) {
            tabController.index = pageIndex;
          },
          pageSnapping: true,
          controller: pageController,
          children: [UserFeed(), SearchUserScreen(), MyProfileScreen(), AddPostScreen()],
        ));
  }
}
