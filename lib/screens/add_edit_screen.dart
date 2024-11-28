import 'package:flutter/material.dart';
import '../model/notes_model.dart';
import '../services/database_helper.dart';


class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int _selectedColor = Colors.blue.value; // Default note color

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = widget.note!.color;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }

    final note = Note(
      id: widget.note?.id, // Use existing ID if editing
      title: title,
      content: content,
      color: _selectedColor,
      dateTime: DateTime.now().toIso8601String(),
    );

    if (widget.note == null) {
      await DatabaseHelper().insertNote(note); // Add new note
    } else {
      await DatabaseHelper().updateNote(note); // Update existing note
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fixed black background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.greenAccent, // Fixed green app bar
        title: const SizedBox.shrink(), // Remove default app bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Title Below App Bar
            Text(
              widget.note == null ? "Add Note" : "Edit Note",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Title Input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade400,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
            const Divider(thickness: 1.2, color: Colors.grey),
            // Content Input
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: "Type your content here...",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, // White text
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            const Divider(thickness: 1.2, color: Colors.grey),
            // Color Picker
            const Text(
              "Pick a Color:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildColorCircle(Colors.blue.value),
                  _buildColorCircle(Colors.red.value),
                  _buildColorCircle(Colors.green.value),
                  _buildColorCircle(Colors.yellow.value),
                  _buildColorCircle(Colors.orange.value),
                  _buildColorCircle(Colors.purple.value),
                  _buildColorCircle(Colors.brown.value),
                  _buildColorCircle(Colors.teal.value),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Save Button
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Save button in green
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Save Note",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // White text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(int colorValue) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = colorValue;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(colorValue),
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == colorValue
                ? Colors.white // Highlight selected color with white border
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
