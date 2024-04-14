import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class Todo {
  String? task;
  RxBool? completed;

  Todo({
    this.task,
    required bool completed,
  }) : completed = completed.obs;
}

class TodoController extends GetxController {
  var todos = <Todo>[].obs;

  void addTodo(String task) {
    todos.add(Todo(task: task, completed: false));
    update();
  }

  void toggleTodo(int index) {
    todos[index].completed?.toggle();
    update();
  }

  void removeTodo(int index) {
    todos.removeAt(index);
    update();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TodoController todoController = Get.put(TodoController());
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('GetX TODO App'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onSubmitted: (value) {
                  todoController.addTodo(value);
                },
                decoration: InputDecoration(
                  hintText: 'Add a new task...',
                ),
              ),
            ),
            Expanded(
              child: GetBuilder<TodoController>(builder: (_) {
                return ListView.builder(
                  itemCount: todoController.todos.length,
                  itemBuilder: (context, index) {
                    final todo = todoController.todos[index];

                    return ListTile(
                      title: Text(todo.task!),
                      leading: Checkbox(
                        value: todo.completed!.value,
                        onChanged: (value) {
                          todoController.toggleTodo(index);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          todoController.removeTodo(index);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
