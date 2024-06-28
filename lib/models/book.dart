// models/book.dart
import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int id;
  final String title;
  final List<String> authors;
  final String coverUrl;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.coverUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      authors:
          List<String>.from(json['authors'].map((author) => author['name'])),
      coverUrl: json['formats']['image/jpeg'],
    );
  }

  @override
  List<Object?> get props => [id, title, authors, coverUrl];
}
