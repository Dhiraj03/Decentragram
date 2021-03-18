import 'package:decentragram/core/colors.dart';
import 'package:decentragram/features/auth/data/user_repository.dart';
import 'package:decentragram/home_screen.dart';
import 'package:decentragram/routes/router.gr.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'features/auth/presentation/bloc/auth_bloc/auth_states.dart';
import 'features/auth/presentation/screens/Login_Screen.dart';
import 'features/auth/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserRepository _userRepository = UserRepository();
  AuthBloc _authBloc;
  //An instance of user_Repository and AuthBloc is created
  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(repository: _userRepository);
    _authBloc.add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return BlocProvider(
      create: (BuildContext context) => _authBloc,
      child: MaterialApp(
        initialRoute: Router.homePage,
        navigatorKey: Router.navigator.key,
        onGenerateRoute: Router.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(
            textTheme: GoogleFonts.montserratTextTheme(TextTheme(
              bodyText1: TextStyle(color: Colors.white),
              bodyText2: TextStyle(color: Colors.white),
              caption: TextStyle(color: Colors.white),
              headline1: TextStyle(color: Colors.white),
              headline2: TextStyle(color: Colors.white),
              headline3: TextStyle(color: Colors.white),
              headline4: TextStyle(color: Colors.white),
              headline5: TextStyle(color: Colors.white),
              headline6: TextStyle(color: Colors.white),
              overline: TextStyle(color: Colors.white),
              subtitle1: TextStyle(color: Colors.white),
              subtitle2: TextStyle(color: Colors.white),
              button: TextStyle(color: Colors.white),
            )),
            colorScheme: ColorScheme(
              primary: Color(0xFFBB86FC),
              primaryVariant: Color(0xFF3700B3),
              secondary: Color(0xFFefb7ff),
              secondaryVariant: Color(0xFF03DAC6),
              surface: Color(0xFF121212),
              background: Color(0xFF121212),
              error: Color(0xFFCF6679),
              onPrimary: Color(0xFF000000),
              onSecondary: Color(0xFF000000),
              onSurface: Color(0xFFFFFFFF),
              onBackground: Color(0xFFFFFFFF),
              onError: Color(0xFF000000),
              brightness: Brightness.light,
            )),
        home: BlocBuilder<AuthBloc, AuthState>(
            bloc: _authBloc,
            builder: (BuildContext context, AuthState state) {
              if (state is AppStarted) return SplashScreen();
              if (state is Authenticated)
                return HomeScreen(
                  userRepository: _userRepository,
                );
              if (state is Unauthenticated)
                return LoginScreen(userRepository: _userRepository);
              return Container();
            }),
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }
}
