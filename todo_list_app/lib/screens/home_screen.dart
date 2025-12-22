import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  String filter = 'all'; // all, done, undone

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('todos');

    if (savedData != null) {
      List decoded = jsonDecode(savedData);
      setState(() {
        todos = decoded.map((e) => Todo.fromJson(e)).toList();
      });
    }
  }

  Future<void> saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('todos', jsonEncode(todos.map((e) => e.toJson()).toList()));
  }

  void addTodo(String title) {
    setState(() {
      todos.add(
        Todo(
          id: DateTime.now().toString(),
          title: title,
          createdAt: DateTime.now(),
        ),
      );
    });
    saveTodos();
  }

  void toggleTodo(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
    });
    saveTodos();
  }

  Future<void> deleteTodo(int index) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah kamu yakin ingin menghapus todo ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      setState(() {
        todos.removeAt(index);
      });
      saveTodos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo berhasil dihapus')),
      );
    }
  }

  void editTodo(int index, String newTitle) {
    setState(() {
      todos[index].title = newTitle;
    });
    saveTodos();
  }

  List<Todo> get filteredTodos {
    if (filter == 'done') return todos.where((t) => t.isCompleted).toList();
    if (filter == 'undone') return todos.where((t) => !t.isCompleted).toList();
    return todos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List App'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => filter = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'all', child: Text('Semua')),
              PopupMenuItem(value: 'done', child: Text('Selesai')),
              PopupMenuItem(value: 'undone', child: Text('Belum Selesai')),
            ],
          )
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTodos.length,
        itemBuilder: (context, index) {
          Todo todo = filteredTodos[index];
          int realIndex = todos.indexOf(todo);

          return TodoItem(
            todo: todo,
            onToggle: () => toggleTodo(realIndex),
            onDelete: () => deleteTodo(realIndex), // pakai konfirmasi
            onEdit: (newTitle) => editTodo(realIndex, newTitle),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          TextEditingController controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Tambah Todo Baru'),
              content: TextField(controller: controller),
              actions: [
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text('Tambah'),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      addTodo(controller.text.trim());
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}