import 'package:bt2/controller/category_controller.dart';
import 'package:bt2/data/models/note.dart';
import 'package:bt2/data/models/category.dart';
import 'package:flutter/material.dart';
import '../controller/note_controller.dart';

class NoteFormView extends StatefulWidget {
  final Note? note;
  
  const NoteFormView({super.key, this.note});

  @override
  State<NoteFormView> createState() => _NoteFormViewState();
}

class _NoteFormViewState extends State<NoteFormView> {
  final controller = NoteController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<Category> categories = [];
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    loadCategories();

    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      selectedCategoryId = widget.note!.categoryId;
    }
  }

  void loadCategories() async {
  final data = await CategoryController().getAll();
  setState(() => categories = data);
}

  void save() async {
  try {
    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select category")),
      );
      return;
    }

    final note = Note(
      id: widget.note?.id,
      title: titleController.text,
      content: contentController.text,
      categoryId: selectedCategoryId,
    );

    if (widget.note == null) {
      await controller.addNote(note);
    } else {
      await controller.updateNote(note);
    }

    print("SAVE SUCCESS");
    Navigator.pop(context);

  } catch (e) {
    print("ERROR SAVE: $e");
  }
}

  void delete() async {
    if (widget.note != null && widget.note!.id != null) {
      await controller.deleteNote(widget.note!.id!);
      Navigator.pop(context);
    }
  }
 @override
  void dispose() {
    titleController.dispose();   
    contentController.dispose();  
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Add Note" : "Edit Note"),
        actions: [
          if (widget.note != null)
            IconButton(
              onPressed: delete,
              icon: const Icon(Icons.delete),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: selectedCategoryId,
              hint: const Text("Select Category"),
              items: categories.map((c) {
                return DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(c.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedCategoryId = value);
              },
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: "Content"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: save,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}