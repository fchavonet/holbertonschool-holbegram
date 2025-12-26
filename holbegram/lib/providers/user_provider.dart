import 'package:flutter/material.dart';

import '../models/user.dart';
import '../methods/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Users? _user;
  final AuthMethode _authMethode = AuthMethode();

  /// Returns the currently authenticated user.
  Users? get user => _user;

  /// Fetches the latest user data from Firestore and updates the state.
  Future<void> refreshUser() async {
    final Users fetchedUser = await _authMethode.getUserDetails();
    _user = fetchedUser;
    notifyListeners();
  }
}
