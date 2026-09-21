import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _registeredUsersKey = 'registered_users_list';
  static const String _activeUserEmailKey = 'active_user_email';

  bool _isLoggedIn = false;
  bool _isInitialized = false;
  UserModel? _currentUser;
  List<UserModel> _registeredUsers = [];

  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _isInitialized;
  UserModel? get currentUser => _currentUser;
  List<UserModel> get registeredUsers => List.unmodifiable(_registeredUsers);

  AuthProvider() {
    checkLoginStatus();
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load registered users list
    final String? usersJson = prefs.getString(_registeredUsersKey);
    if (usersJson != null && usersJson.isNotEmpty) {
      try {
        final List<dynamic> decodedList = json.decode(usersJson);
        _registeredUsers = decodedList
            .map((item) => UserModel.fromMap(Map<String, dynamic>.from(item)))
            .toList();
      } catch (e) {
        _registeredUsers = [];
      }
    } else {
      _registeredUsers = [];
    }

    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    final String? activeEmail = prefs.getString(_activeUserEmailKey);

    if (_isLoggedIn && activeEmail != null && activeEmail.isNotEmpty) {
      final index = _registeredUsers.indexWhere(
        (u) => u.email.trim().toLowerCase() == activeEmail.trim().toLowerCase(),
      );
      if (index != -1) {
        _currentUser = _registeredUsers[index];
      } else {
        // Fallback default user if active account not in list
        _currentUser = UserModel(
          name: 'Rider',
          email: activeEmail,
          phone: '',
          password: '',
          bikeStatus: 'Don\'t have bike',
        );
      }
    } else {
      _currentUser = null;
    }

    _isInitialized = true;
    notifyListeners();
    return _isLoggedIn;
  }

  Future<void> registerUser(UserModel newUser) async {
    final prefs = await SharedPreferences.getInstance();

    final existingIndex = _registeredUsers.indexWhere(
      (u) => u.email.trim().toLowerCase() == newUser.email.trim().toLowerCase(),
    );

    if (existingIndex != -1) {
      _registeredUsers[existingIndex] = newUser;
    } else {
      _registeredUsers.add(newUser);
    }

    // Save updated users list
    final String encodedUsers = json.encode(_registeredUsers.map((u) => u.toMap()).toList());
    await prefs.setString(_registeredUsersKey, encodedUsers);
    notifyListeners();
  }

  Future<String?> loginUser(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    final userIndex = _registeredUsers.indexWhere(
      (u) => u.email.trim().toLowerCase() == cleanEmail,
    );

    if (userIndex == -1) {
      return 'No account found with "$email". Please register first.';
    }

    final user = _registeredUsers[userIndex];
    if (user.password != cleanPassword) {
      return 'Incorrect password. Please try again.';
    }

    // Successful login
    _currentUser = user;
    _isLoggedIn = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_activeUserEmailKey, user.email);

    return null; // Null means no error
  }

  Future<void> loginDirect(UserModel user) async {
    await registerUser(user);
    _currentUser = user;
    _isLoggedIn = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_activeUserEmailKey, user.email);
  }

  Future<void> updateCurrentUser(UserModel updatedUser) async {
    _currentUser = updatedUser;
    await registerUser(updatedUser);
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.setString(_activeUserEmailKey, '');
  }
}
