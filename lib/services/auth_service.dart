import 'package:firebase_auth/firebase_auth.dart';

bool isConnected() {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null;
}

void logoutUser() async {
  var auth = AuthService();
  await auth.signOut();
  print("L'utilisateur a bien été déconnecté.");
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Vérifier l'utilisateur connecté
  User? get currentUser => _auth.currentUser;
  // Inscription utilisateur
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Erreur d'inscription : $e");
      return null;
    }
  }
  
// Connexion utilisateur
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Erreur de connexion : $e");
      return null;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

