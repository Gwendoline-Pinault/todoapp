import 'package:flutter/material.dart';
import 'package:todoapp/services/tasks_service.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key, required this.title});

  final String title;

  @override
  State<AddTaskPage> createState() => _AddTaskPage();
}

enum Prio {low, medium, high}

class _AddTaskPage extends State<AddTaskPage> {
  final TextEditingController taskController = TextEditingController();
  // TextEditingController priorityController = TextEditingController();
  final TasksService taskService = TasksService();

  Prio prioSelected = Prio.medium;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Création de tâche"),
      ),
      body: Center(
        child: Form(
          child: SizedBox(
            width: 500,
            child: Column(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nouvelle tâche", 
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.blue.shade600
                  ),
                ),
                TextField(
                  controller: taskController,
                  decoration: InputDecoration(labelText: 'Description', labelStyle: TextStyle(fontSize: 14))
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("Priorité : "),
                    Expanded(child: 
                      Center(child: 
                        SegmentedButton(
                          segments: [
                            ButtonSegment(value: Prio.low, label: Text("Faible")),
                            ButtonSegment(value: Prio.medium, label: Text("Moyenne")),
                            ButtonSegment(value: Prio.high, label: Text("Haute")),
                          ], 
                          selected: <Prio>{prioSelected},
                          onSelectionChanged: (Set<Prio> selection) {
                            setState(() {
                              prioSelected = selection.first;
                            });
                          }
                        ),
                      )
                    )
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 25,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue.shade600), 
                        foregroundColor:  WidgetStateProperty.all(Colors.white),
                        overlayColor: WidgetStateProperty.all(Colors.blue.shade800),
                      ),
                      onPressed: () {
                        String newTitle = taskController.text;
                        String newPriority = switch (prioSelected) {
                          Prio.low => "faible",
                          Prio.medium => "moyenne",
                          Prio.high => "haute",
                        };
                        //String newPriority = priorityController.text;
                        taskService.addTask(newTitle, false, newPriority, context);
                        Navigator.pop(context);
                      },
                      child: Text('Création'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue.shade600), 
                        foregroundColor:  WidgetStateProperty.all(Colors.white),
                        overlayColor: WidgetStateProperty.all(Colors.blue.shade800),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Annuler'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}