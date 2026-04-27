import 'package:bt1/data/models/note.dart';
import 'package:bt1/widget/note_item.dart';
import 'package:flutter/material.dart';
import '../controller/note_controller.dart';
import 'note_form_view.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  final NoteController controller = NoteController();
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final data = await controller.getAllNotes();
    setState(() => notes = data);
  }

  void goToForm({Note? note}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteFormView(note: note),
      ),
    );
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: Colors.teal, actions: [Padding(padding: const EdgeInsets.all(16), child: Text("6451071022", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),)],),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (_, index) {
          return NoteItem(
            note: notes[index],
            onTap: () => goToForm(note: notes[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}