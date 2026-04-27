import 'package:bt1/data/models/note.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  void save() async {
    try {
    final note = Note(
      id: widget.note?.id,
      title: titleController.text,
      content: contentController.text,
    );

    if (widget.note == null) {
      await controller.addNote(note);
    } else {
      await controller.updateNote(note);
    }

    print("SAVE SUCCESS"); // 👈 debug
    Navigator.pop(context);

  } catch (e) {
    print("ERROR: $e"); // 👈 sẽ hiện lỗi thật
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