import 'package:flutter/material.dart';
import 'package:todoapp/services/tasks_service.dart';

// ouvre une modale avec le formulaire de création
void openModal(BuildContext context) {
  final TextEditingController taskController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  final TasksService taskService = TasksService();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Créer nouvelle tâche'),
        content: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(labelText: 'Titre de la tâche'),
            ),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(labelText: 'Priorité'),
            ),
          ],
        ), 
        actions: [
          TextButton(
            onPressed: () {
              String newTitle = taskController.text;
              String newPriority = priorityController.text;
              taskService.addTask(newTitle, false, newPriority, context);
              Navigator.pop(context);
            },
            child: Text('Création'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Annuler'),
          ),
        ],
      );
    },
  );
}

/// Show a snackbar displaying the given message.
/// The boolean is for the displayed color
void notification(context, String message, bool error){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: 
    Center(child: Text(message)),
    duration: const Duration(milliseconds: 1500),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    backgroundColor: error ? Colors.red : Colors.blue,
  ));
}