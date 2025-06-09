import 'package:flutter/material.dart';
import 'bloc/task_bloc.dart';
import 'models/task.dart';
import 'widgets/task_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do Stream App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TaskPage(),
    );
  }
}

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _bloc = TaskBloc();
  final _controller = TextEditingController();
  final List<String> _marcas = ['Personal', 'Trabajo', 'Estudio'];
  String _marcaSeleccionada = 'Personal';

  

  @override
  void dispose() {
    _bloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_controller.text.trim().isNotEmpty) {
      _bloc.addTask(_controller.text.trim(), _marcaSeleccionada);
      _controller.clear();
    }
  }

  void _editTask(Task task) {
    final titleController = TextEditingController(text: task.title);
    String selectedMarca = task.marca;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              DropdownButton<String>(
                value: selectedMarca,
                onChanged: (String? value) {
                  setState(() {
                    selectedMarca = value!;
                  });
                },
                items: _marcas.map((String marca) {
                  return DropdownMenuItem<String>(
                    value: marca,
                    child: Text(marca),
                  );
                }).toList(),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _bloc.updateTask(task, titleController.text, selectedMarca);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tareas')),
      body: Container(
       color: const Color.fromARGB(255, 241, 238, 227),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Nueva tarea',
                            filled: true,
                            fillColor: Color.fromARGB(255, 224, 207, 207),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addTask,
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: _marcaSeleccionada,
                    onChanged: (String? newValue) {
                      setState(() {
                        _marcaSeleccionada = newValue!;
                      });
                    },
                    items: _marcas.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
              Expanded(
                child: StreamBuilder<List<Task>>(
                  stream: _bloc.taskStream,
                  builder: (context, snapshot) {
                    final tasks = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskItem(
                          task: task,
                          onToggle: () => setState(() => _bloc.toggleTask(task)),
                          onDelete: () => setState(() => _bloc.removeTask(task)),
                          onEdit: () => _editTask(task),
                        );
                      },
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}