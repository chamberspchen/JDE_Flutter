import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class Todo {
  String task;
  RxBool completed;

  Todo({
    this.task,
    bool completed,
  }) : completed = completed.obs;
}

class TodoController extends GetxController {
  var todos = <Todo>[].obs;

  void addTodo(String task) {
    todos.add(Todo(task: task, completed: false));
  }

  void toggleTodo(int index) {
    todos[index].completed.toggle();
  }

  void removeTodo(int index) {
    todos.removeAt(index);
  }
}

class MyApp extends StatelessWidget {
  final TodoController todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
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
              child: Obx(
                () => ListView.builder(
                  itemCount: todoController.todos.length,
                  itemBuilder: (context, index) {
                    final todo = todoController.todos[index];

                    return ListTile(
                      title: Text(todo.task),
                      leading: Obx(() => Checkbox(
                            value: todo.completed.value,
                            onChanged: (value) {
                              todoController.toggleTodo(index);
                            },
                          )),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          todoController.removeTodo(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
