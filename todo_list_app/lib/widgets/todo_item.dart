import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final ValueChanged<String> onEdit;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                TextEditingController controller =
                    TextEditingController(text: todo.title);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Edit Todo'),
                    content: TextField(controller: controller),
                    actions: [
                      TextButton(
                        child: const Text('Batal'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text('Simpan'),
                        onPressed: () {
                          if (controller.text.trim().isNotEmpty) {
                            onEdit(controller.text.trim());
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(), // langsung panggil callback delete
            ),
          ],
        ),
      ),
    );
  }
}
