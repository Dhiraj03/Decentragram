import 'package:decentragram/core/colors.dart';
import 'package:decentragram/core/dimens.dart';
import 'package:decentragram/core/util.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:decentragram/features/user_features/user_bloc/user_bloc.dart';
import 'package:decentragram/routes/router.gr.dart';
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
              return SingleChildScrollView(
                padding: stdPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        minRadius: 90,
                        maxRadius: 90,
                        backgroundImage:
                            MemoryImage(state.profile.profileImage)),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Username",
                        style: TextStyle(fontSize: 16, color: grey)),
                    Text(
                      state.profile.username,
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
                    Text(state.profile.userAddress,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'My Posts',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: grey),
                    ),
                    if (state.posts != null)
                      ListView.separated(
                          reverse: true,
                          physics: ScrollPhysics(),
                          padding: EdgeInsets.only(left: 10, top: 0),
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              color: Colors.white,
                              height: 5,
                            );
                          },
                          shrinkWrap: true,
                          itemCount: state.posts.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (state.posts[index].isImage)
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundImage: MemoryImage(
                                            state.profile.profileImage),
                                      ),
                                      title: Text(state.profile.username),
                                      subtitle: Text(dateFromString(
                                          state.posts[index].time))),
                                  Text(
                                    state.posts[index].caption,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 300,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: MemoryImage(
                                                state.posts[index].image),
                                            alignment: Alignment.center,
                                            fit: BoxFit.fitHeight)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          iconSize: 25,
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            MaterialCommunityIcons
                                                .heart_outline,
                                          ),
                                          onPressed: () {}),
                                      Text(state.posts[index].likeCount
                                          .toString()),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 25,
                                          icon: Icon(MaterialCommunityIcons
                                              .comment_outline),
                                          onPressed: () {
                                            Scaffold.of(context)
                                                .showBottomSheet((context) {
                                              TextEditingController
                                                  commentController =
                                                  TextEditingController();

                                              return Scaffold(
                                                floatingActionButton:
                                                    FloatingActionButton(
                                                        elevation: 0,
                                                        backgroundColor:
                                                            sheetColor,
                                                        child: Icon(
                                                          MaterialCommunityIcons
                                                              .close,
                                                          color: primaryColor,
                                                        ),
                                                        onPressed: () {
                                                          Router.navigator
                                                              .pop();
                                                        }),
                                                body: Column(children: <Widget>[
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      'Comments',
                                                      style: TextStyle(
                                                          fontSize: 25),
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: state
                                                        .posts[index]
                                                        .commentCount,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int i) {
                                                      return ListTile(
                                                        title: Text(state
                                                            .posts[index]
                                                            .comments[i]
                                                            .username),
                                                        subtitle: Text(
                                                          state
                                                              .posts[index]
                                                              .comments[i]
                                                              .content,
                                                          style: TextStyle(
                                                              color: grey),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 40, top: 40),
                                                    child: ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      trailing: IconButton(
                                                          icon: Icon(
                                                            MaterialCommunityIcons
                                                                .send,
                                                            color: primaryColor,
                                                          ),
                                                          onPressed: () {
                                                            Router.navigator
                                                                .pop();
                                                            bloc
                                                              ..add(AddComment(
                                                                  followAddress: state
                                                                      .profile
                                                                      .userAddress,
                                                                  comment:
                                                                      commentController
                                                                          .text,
                                                                  postID: index,
                                                                  userAddress: state
                                                                      .profile
                                                                      .userAddress));
                                                          }),
                                                      leading: CircleAvatar(
                                                        backgroundImage:
                                                            MemoryImage(state
                                                                .profile
                                                                .profileImage),
                                                      ),
                                                      title: TextFormField(
                                                        cursorWidth: 1.5,
                                                        controller:
                                                            commentController,
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            hintText:
                                                                "Add a comment",
                                                            border:
                                                                OutlineInputBorder()),
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                              );
                                            });
                                          }),
                                      Text(state.posts[index].commentCount
                                          .toString()),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              );
                            else
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundImage: MemoryImage(
                                            state.profile.profileImage),
                                      ),
                                      title: Text(state.profile.username),
                                      subtitle: Text(dateFromString(
                                          state.posts[index].time))),
                                  Text(
                                    state.posts[index].caption,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    state.posts[index].text,
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          iconSize: 25,
                                          padding: EdgeInsets.zero,
                                          icon: state.posts[index].isLiked
                                              ? Icon(
                                                  MaterialCommunityIcons.heart,
                                                  color: red,
                                                )
                                              : Icon(
                                                  MaterialCommunityIcons
                                                      .heart_outline,
                                                  color: red,
                                                ),
                                          onPressed: () {
                                            if (!state.posts[index].isLiked) {
                                              bloc
                                                ..add(LikePost(
                                                    followAddress: state
                                                        .profile.userAddress,
                                                    postID: index,
                                                    userAddress: state
                                                        .profile.userAddress));
                                              bloc..add(GetMyProfile());
                                            }
                                          }),
                                      Text(state.posts[index].likeCount
                                          .toString()),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 25,
                                          icon: Icon(
                                              MaterialCommunityIcons
                                                  .comment_outline,
                                              color: secondaryColor),
                                          onPressed: () {
                                            Scaffold.of(context)
                                                .showBottomSheet(
                                              (context) {
                                                TextEditingController
                                                    commentController =
                                                    TextEditingController();

                                                return Scaffold(
                                                  floatingActionButton:
                                                      FloatingActionButton(
                                                          elevation: 0,
                                                          backgroundColor:
                                                              sheetColor,
                                                          child: Icon(
                                                            MaterialCommunityIcons
                                                                .close,
                                                            color: primaryColor,
                                                          ),
                                                          onPressed: () {
                                                            Router.navigator
                                                                .pop();
                                                          }),
                                                  body:
                                                      Column(children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        'Comments',
                                                        style: TextStyle(
                                                            fontSize: 25),
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: state
                                                          .posts[index]
                                                          .commentCount,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int i) {
                                                        return ListTile(
                                                          title: Text(state
                                                              .posts[index]
                                                              .comments[i]
                                                              .username),
                                                          subtitle: Text(
                                                            state
                                                                .posts[index]
                                                                .comments[i]
                                                                .content,
                                                            style: TextStyle(
                                                                color: grey),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 40, top: 40),
                                                      child: ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        trailing: IconButton(
                                                            icon: Icon(
                                                              MaterialCommunityIcons
                                                                  .send,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                            onPressed: () {
                                                              Router.navigator
                                                                  .pop();
                                                              bloc
                                                                ..add(AddComment(
                                                                    followAddress: state
                                                                        .profile
                                                                        .userAddress,
                                                                    comment:
                                                                        commentController
                                                                            .text,
                                                                    postID:
                                                                        index,
                                                                    userAddress: state
                                                                        .profile
                                                                        .userAddress));
                                                            }),
                                                        leading: CircleAvatar(
                                                          backgroundImage:
                                                              MemoryImage(state
                                                                  .profile
                                                                  .profileImage),
                                                        ),
                                                        title: TextFormField(
                                                          cursorWidth: 1.5,
                                                          controller:
                                                              commentController,
                                                          decoration: InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      left: 10),
                                                              hintText:
                                                                  "Add a comment",
                                                              border:
                                                                  OutlineInputBorder()),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                                );
                                              },
                                            );
                                          }),
                                      Text(state.posts[index].commentCount
                                          .toString()),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              );
                          })
                  ],
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
          listener: (BuildContext context, UserState state) {
            if (state is Success) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: secondaryColor,
              ));
            }
          },
        ),
      ),
    );
  }
}
