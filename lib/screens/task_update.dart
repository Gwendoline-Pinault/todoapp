import 'package:flutter/material.dart';
import 'package:todoapp/services/tasks_service.dart';

class UpdateTaskPage extends StatefulWidget {
  const UpdateTaskPage({super.key, required this.documentId, required this.data});

  final String documentId;
  final Map<String, dynamic> data;

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPage();
}

enum Prio {low, medium, high}

class _UpdateTaskPage extends State<UpdateTaskPage> {
  Prio prioSelected = Prio.medium;

  @override
  void initState() {
    super.initState();

    switch (widget.data['priority'] as String) {
      case "faible":
        setState(() {
          prioSelected = Prio.low;
        });
        break;
      case "moyenne" :
        setState(() {
          prioSelected = Prio.medium;
        });
        break;
      case "haute" :
        setState(() {
          prioSelected = Prio.high;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

  final TextEditingController taskController = TextEditingController(text: widget.data['title']);
  final TasksService taskService = TasksService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Modification de tâche"),
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
                  "Modifier la tâche", 
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.blue.shade600
                  ),
                ),
                TextField(
                  controller: taskController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 30),
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
                SizedBox(height: 20),
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
                        
                        taskService.updateTask(widget.documentId, newTitle, widget.data['status'], newPriority, context);
                        Navigator.pop(context);
                      },
                      child: Text('Modifier'),
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