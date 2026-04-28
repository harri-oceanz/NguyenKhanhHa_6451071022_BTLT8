import 'package:bt2/controller/category_controller.dart';
import 'package:bt2/data/models/category.dart';
import 'package:bt2/data/models/note.dart';
import 'package:bt2/widget/note_item.dart';
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
  List<Category> categories = [];
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadData();
  }

  void loadCategories() async {
  final data = await CategoryController().getAll();
  setState(() => categories = data);
}

  void loadData() async {
   final data = await controller.getAllNotes(categoryId: selectedCategoryId);
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

  void showAddCategoryDialog() {
  final TextEditingController nameController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Add Category"),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          hintText: "Enter category name",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (nameController.text.isEmpty) return;

            await CategoryController().add(
              Category(name: nameController.text),
            );

            Navigator.pop(context);

            loadCategories();
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: Colors.teal,
       actions: [
        Row(
          children: [
            const Text(
              "6451071022",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.category),
              onPressed: showAddCategoryDialog,
            ),
          ],
        ),
      ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButton<int>(
              isExpanded: true,
              hint: const Text("Filter"),
              value: selectedCategoryId ?? -1,
              items: [
                const DropdownMenuItem<int>(
                  value: -1,
                  child: Text("All"),
                ),
                ...categories.map((c) => DropdownMenuItem<int>(
                      value: c.id!,
                      child: Text(c.name),
                    ))
              ],
              onChanged: (value) {
                setState(() => selectedCategoryId = value);
                loadData();
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) {
                return NoteItem(
                  note: notes[index],
                  onTap: () => goToForm(note: notes[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}