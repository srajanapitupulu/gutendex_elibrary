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

  Book({
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

  // Convert a Book object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors.join(','),
      'coverUrl': coverUrl,
    };
  }

  // Convert a Map object into a Book object
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      authors: map['authors'].split(','),
      coverUrl: map['coverUrl'],
    );
  }
}

// Run the following command to generate the `book.g.dart` file:
// flutter packages pub run build_runner build

// import 'package:equatable/equatable.dart';

// class Book extends Equatable {
//   final int id;
//   final String title;
//   final List<String> authors;
//   final String coverUrl;

//   const Book({
//     required this.id,
//     required this.title,
//     required this.authors,
//     required this.coverUrl,
//   });

//   factory Book.fromJson(Map<String, dynamic> json) {
//     return Book(
//       id: json['id'],
//       title: json['title'],
//       authors:
//           List<String>.from(json['authors'].map((author) => author['name'])),
//       coverUrl: json['formats']['image/jpeg'],
//     );
//   }

//   @override
//   List<Object?> get props => [id, title, authors, coverUrl];
// }
