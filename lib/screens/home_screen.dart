import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../model/notes_model.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
      _filteredNotes = notes; // Initially, show all notes.
    });
  }

  void _filterNotes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNotes = _notes;
      } else {
        _filteredNotes = _notes
            .where((note) =>
        note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _deleteNote(int id) async {
    await _databaseHelper.deleteNoteById(id);
    _loadNotes();
  }

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
        title: !_isSearching
            ? const Text(
          "My Simple Notes",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White color for "My Simple Notes".
          ),
        )
            : TextField(
          onChanged: _filterNotes,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search Notes...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white, // Ensure the search icon is visible.
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _filteredNotes = _notes; // Reset the filter.
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.notes, color: Colors.white),
            onPressed: () {
              setState(() {
                _filteredNotes = List.from(_notes); // Reset to show all notes.
              });

              // Show a SnackBar message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Displaying all notes."),
                  duration: Duration(seconds: 5), // Message will be visible for 2 seconds
                ),
              );
            },
          ),

        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: _filteredNotes.length,
          itemBuilder: (context, index) {
            final note = _filteredNotes[index];
            final color = Color(note.color);

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      note.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDateTime(note.dateTime),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditNoteScreen(note: note),
                          ),
                        );
                        _loadNotes();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () async {
            setState(() {
            _filteredNotes = List.from(_notes); // Reset to show all notes.
            });

            // Show a SnackBar message
            ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
            content: Text("Notes deleted Successfully."),
            duration: Duration(seconds: 5), // Message will be visible for 2 seconds
            ),
            );

            _deleteNote(note.id!);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditNoteScreen(),
            ),
          );
          _loadNotes();
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.greenAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
