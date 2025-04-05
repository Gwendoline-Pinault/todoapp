import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/widgets/tasks_widget.dart';

class TasksService {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addTask(String title, bool status, String priority, context) async {
    await FirebaseFirestore.instance.collection('users/$userId/tasks')
        .add({
          'date': FieldValue.serverTimestamp(),
          'title': title,
          'status': status,
          'priority': priority,
        })
        .then((value) => notification(context, "Tâche ajoutée avec succès", false))
        .catchError((error) => notification(context, "Erreur lors de la création : $error", true));
  }

  Future<void> updateTask(String docId, title, bool status, String priority, context) async {
    await FirebaseFirestore.instance.collection('users/$userId/tasks')
      .doc(docId)
      .update({
        'title': title,
        'status': status,
        'priority': priority,
      })
      .then((value) => notification(context, "Tâche modfiée avec succès !", false))
      .catchError((error) => notification(context, "Erreur lors de la modfication de la tâche : $error", true));
  }

  Future<void> removeTask(String docId) async {
    await FirebaseFirestore.instance.collection('users/$userId/tasks').doc(docId).delete();
  }
}
