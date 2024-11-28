class Note {
  final int? id; // Note ID, nullable for new notes
  final String title; // Title of the note
  final String content; // Content of the note
  final int color; // Color of the note (stored as an integer)
  final String dateTime; // Date and time the note was created or updated

  // Constructor for the Note class
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
  });

  /// Converts the Note object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'dateTime': dateTime,
    };
  }

  /// Creates a Note object from a database map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      color: map['color'] as int,
      dateTime: map['dateTime'] as String,
    );
  }

  /// Creates a copy of the Note object with updated fields
  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? color,
    String? dateTime,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
