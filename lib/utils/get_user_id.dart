import 'package:firebase_auth/firebase_auth.dart';

String? getUserId() {
  return FirebaseAuth.instance.currentUser?.uid;
}
