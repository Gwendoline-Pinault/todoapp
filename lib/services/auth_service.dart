import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/widgets/tasks_widget.dart';

bool isConnected() {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null;
}

void logoutUser(context) async {
  var auth = AuthService();
  await auth.signOut();
  notification(context, "L'utilisateur a bien été déconnecté", false);
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Verify if user is logged in
  User? get currentUser => _auth.currentUser;
  
  // User inscription
  Future<User?> signUp(context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      notification(context, "Erreur lors de l'inscription", true);
      return null;
    }
  }
  
// Connexion utilisateur
  Future<User?> signIn(context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      notification(context, "Erreur de connexion : utilisateur inconnu ou identifiants incorrects", true);
      return null;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

