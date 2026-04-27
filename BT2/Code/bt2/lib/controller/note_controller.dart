import 'package:bt2/data/models/note.dart';
import 'package:bt2/data/repository/note_repository.dart';

class NoteController {
  final NoteRepository _repository = NoteRepository();

  Future<List<Note>> getAllNotes({int? categoryId}) async {
    return await _repository.getAll(categoryId: categoryId);
  }

  Future<void> addNote(Note note) async {
    await _repository.insert(note);
  }

  Future<void> updateNote(Note note) async {
    await _repository.update(note);
  }

  Future<void> deleteNote(int id) async {
    await _repository.delete(id);
  }
}