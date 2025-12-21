import 'package:flutter/material.dart';

import '../models/user.dart';
import '../methods/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Users? _user;
  final AuthMethode _authMethode = AuthMethode();

  Users? get user => _user;

  Future refreshUser() async {
    Users user = await _authMethode.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
