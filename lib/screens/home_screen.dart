import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/screens/login_screen.dart';
import 'package:todoapp/screens/task_creation.dart';
import 'package:todoapp/screens/task_update.dart';
import 'package:todoapp/services/auth_service.dart';
import 'package:todoapp/services/tasks_service.dart';
import 'package:todoapp/widgets/tasks_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Prio {none, low, medium, high}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController taskController = TextEditingController();
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
  final taskService = TasksService();
  String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
  String userId = FirebaseAuth.instance.currentUser!.uid;

  Prio filter = Prio.none;
  String prioFilter = 'moyenne';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        actions: [
          Row(
            spacing: 5,
            children: [
              Icon(Icons.person, color: Colors.white),
              Text(userEmail, style: TextStyle(color: Colors.white)),
            ],
          ),
          VerticalDivider(color: Colors.blue.shade100),
          TextButton(
            style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.blue.shade600)),
            onPressed: () {
              logoutUser;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            }, 
            child: Text("Se déconnecter", style: TextStyle(color: Colors.white))),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: filter == Prio.none 
          ? FirebaseFirestore.instance.collection('users/$userId/tasks').orderBy('status', descending: false).snapshots() 
          : FirebaseFirestore.instance.collection('users/$userId/tasks').where('priority', isEqualTo: prioFilter).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            notification(context, "Une erreur est survenue.", true);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Center(
                    child: SegmentedButton(
                      segments: [
                        ButtonSegment(value: Prio.none, label: Text("Aucun filtre")),
                        ButtonSegment(value: Prio.low, label: Text("Priorité Faible")),
                        ButtonSegment(value: Prio.medium, label: Text("Priorité Moyenne")),
                        ButtonSegment(value: Prio.high, label: Text("Priorité Haute")),
                      ], 
                      selected: <Prio>{filter},
                      onSelectionChanged: (Set<Prio> selection) {
                        setState(() {
                          filter = selection.first;

                          switch (filter) {
                            case Prio.none :
                              break;
                            case Prio.low :
                              prioFilter = 'faible';
                              break;
                            case Prio.medium :
                              prioFilter = 'moyenne';
                              break;
                            case Prio.high :
                              prioFilter = 'haute';
                              break;
                          }
                        });
                      }
                    ),
                  ),
                  SizedBox(height: 30),  
                  Expanded(child: ListView(
                    children : snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      Color prioColor;

                      switch (data['priority']) {
                        case 'haute' : 
                          prioColor =  Colors.red;
                          break;
                        case 'moyenne':
                          prioColor = Colors.orange;
                          break;
                        case'faible': 
                        prioColor = Colors.green;
                        default: 
                        prioColor = Colors.black;
                      }

                      return  Card(
                        elevation: 2,
                        color: Colors.white,
                        margin: EdgeInsets.all(5),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['title'],
                                          style: TextStyle(
                                            fontSize: 18, 
                                            decoration: data['status'] ? TextDecoration.lineThrough : TextDecoration.none),
                                        ),
                                        Row(
                                          children: [
                                            Text("Priorité : "),
                                            Text(
                                              data['priority'],
                                              style: TextStyle(color: prioColor),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // état de la tâche (faite ou non)
                                Checkbox(
                                  value: data['status'],
                                  onChanged: (value) {
                                    FirebaseFirestore.instance
                                        .collection('users/$userId/tasks')
                                        .doc(document.id)
                                        .update({
                                      'status': value,
                                    });
                                  },
                                ), // bouton pour modifier la tâche
                                IconButton(
                                  onPressed: () {
                                    var documentId = document.id;
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTaskPage(documentId: documentId, data: data)));
                                  },
                                  icon: Icon(Icons.edit)
                                ),
                                // bouton pour supprimer la tâche
                                IconButton(
                                  onPressed: () {
                                    taskService.removeTask(document.id);
                                  },
                                  icon: Icon(Icons.delete)
                                ),
                              ],
                            ),
                          )
                        );
                      }).toList(),
                    )
                  )
                ]
              )
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        hoverColor: Colors.blue.shade800,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage(title: 'Nouvelle tâche')));
        }, 
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}