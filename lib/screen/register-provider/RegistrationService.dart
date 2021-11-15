import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //registration with email and password
  Future createNewUser(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
