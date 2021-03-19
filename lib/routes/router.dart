import 'package:auto_route/auto_route_annotations.dart';
import 'package:decentragram/features/user_features/add_post_screen.dart';
import 'package:decentragram/main.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  HomePage homePage;
  AddPostScreen addPostScreen;
}
