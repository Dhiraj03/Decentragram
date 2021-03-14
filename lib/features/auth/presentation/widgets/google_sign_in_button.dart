import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback _onPressed;

  GoogleSignInButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      elevation: 0.5,
      icon: Icon(MaterialCommunityIcons.google),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Color.fromRGBO(255, 62, 48, 1),
      onPressed: _onPressed,
      label: Text('Sign In with Google'),
    );
  }
}
