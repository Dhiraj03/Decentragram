import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:decentragram/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Dashboard'),
      ),
    );
  }
}
