import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<User?> currentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<String?> CurrentDisplayName() async {
    return FirebaseAuth.instance.currentUser!.displayName;
  }
}
