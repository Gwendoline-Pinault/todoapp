import 'package:flutter/material.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/services/auth_service.dart';
import 'package:todoapp/widgets/tasks_widget.dart';

void navHome(context) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Mes tâches")));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  void loginUser(context) async {
    var user = await authService.signIn(emailController.text, passwordController.text);
    if (user != null) {
      notification(context, "Connexion réussie : ${user.email}", false);
      navHome(context);
    } else {
      notification(context, "Échec de la connexion", true);
    }
  }
  
  void registerUser(context) async {
    var user = await authService.signUp(emailController.text, passwordController.text);
    if (user != null) {
      notification(context, "Inscription réussie : ${user.email}", false);
    } else {
      notification(context, "Échec de l'inscription", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Connexion", style: TextStyle(color: Colors.white),),
        ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              Title(
                title: 'Gestionnaire de tâches', 
                color: Colors.black, 
                child: Text(
                  "Connexion Firebase",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.blue.shade600
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Mot de passe"),
                obscureText: true,
              ),
              SizedBox(height: 20), // ajoute un espace après les inputs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 25,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue.shade600),
                      foregroundColor:  WidgetStateProperty.all(Colors.white),
                      overlayColor: WidgetStatePropertyAll(Colors.blue.shade800),
                    ),
                    onPressed: () {
                      loginUser(context);
                    }, 
                    child: const Text("Se connecter"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue.shade600),
                      foregroundColor:  WidgetStateProperty.all(Colors.white),
                      overlayColor: WidgetStatePropertyAll(Colors.blue.shade800),
                    ),
                    onPressed: () {
                      registerUser(context);
                    } ,
                    child: Text("S'inscrire"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}