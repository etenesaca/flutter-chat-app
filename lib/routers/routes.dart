import 'package:flutter/material.dart';
import '../screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  ChatScreen.routeName: (_) => const ChatScreen(),
  LoadingScreen.routeName: (_) => const LoadingScreen(),
  LoginScreen.routeName: (_) => const LoginScreen(),
  RegisterScreen.routeName: (_) => const RegisterScreen(),
  UsuariosScreen.routeName: (_) => const UsuariosScreen(),
};

final String iniAppRoute = LoginScreen.routeName;
