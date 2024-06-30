import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<String> authors;

  @HiveField(3)
  final String coverUrl;

  @HiveField(4)
  final List<String> subjects;

  @HiveField(5)
  final List<String> languages;

  @HiveField(6)
  final String mediatype;

  @HiveField(7)
  final String bookUrl;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.coverUrl,
    required this.subjects,
    required this.languages,
    required this.mediatype,
    required this.bookUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      authors:
          List<String>.from(json['authors'].map((author) => author['name'])),
      subjects: List<String>.from(json['subjects'].map((subject) => subject)),
      languages:
          List<String>.from(json['languages'].map((languages) => languages)),
      coverUrl: json['formats']['image/jpeg'] ?? " ",
      mediatype: json['media_type'] ?? "Text",
      bookUrl: json['formats']['text/html'] ?? " ",
    );
  }

  // Convert a Book object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors.join(','),
      'subjects': subjects.join(','),
      'languages': languages.join(','),
      'coverUrl': coverUrl,
      'mediatype': mediatype,
      'bookUrl': bookUrl,
    };
  }

  // Convert a Map object into a Book object
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      authors: map['authors'].split(','),
      subjects: map['subjects'].split(','),
      languages: map['languages'].split(','),
      coverUrl: map['coverUrl'],
      mediatype: map['mediatype'],
      bookUrl: map['bookUrl'],
    );
  }
}
