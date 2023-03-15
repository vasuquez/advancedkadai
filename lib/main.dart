import 'package:advanced_kadai/riverpod_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListView(),
    );
  }
}

class TodoListView extends ConsumerWidget {
  const TodoListView({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Todo リストの内容に変化があるとウィジェットが更新される
    List<Todo> todos = ref.watch(todosProvider);

    // スクロール可能なリストビューで Todo リストの内容を表示
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('ToDoリスト'),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) => ref.read(todosProvider.notifier).reorderTodos(oldIndex, newIndex),
        children: [
          for (final todo in todos)
            Padding(
              key: ValueKey(todo.id),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 2,
                child: ListTile(
                  title: Text(todo.description),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (value) => ref.read(todosProvider.notifier).toggle(todo.id),
                  ),
                  trailing: IconButton(
                    onPressed: () => ref.read(todosProvider.notifier).removeTodo(todo.id),
                    icon: Icon(Icons.delete),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newTodo = Todo(
            id: UniqueKey().toString(),
            description: 'task',
            completed: false,
          );
          ref.read(todosProvider.notifier).addTodo(newTodo);
        },
        child: const Icon(Icons.add),
      ),
    );


  }
}