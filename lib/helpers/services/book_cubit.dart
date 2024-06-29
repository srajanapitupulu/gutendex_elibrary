// cubit/book_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gutendex_elibrary/models/book.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  BookCubit() : super(BookInitial()) {
    _loadCachedBooks();
  }

  final String _baseUrl = 'https://gutendex.com/books';
  String? _nextUrl;

  Future<void> _loadCachedBooks() async {
    final box = await Hive.openBox<Book>('books');
    final cachedBooks = box.values.toList();
    if (cachedBooks.isNotEmpty) {
      emit(BookLoaded(books: cachedBooks));
    }
  }

  void fetchBooks() async {
    if (state is BookLoading) return;

    final currentState = state;

    var oldBooks = <Book>[];
    if (currentState is BookLoaded) {
      oldBooks = currentState.books;
    }

    emit(BookLoading(oldBooks, isFirstFetch: _nextUrl == null));

    try {
      final response = await http.get(Uri.parse(_nextUrl ?? _baseUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _nextUrl = jsonResponse['next'];
        print("Next page: $_nextUrl");
        final List<Book> books = List<Book>.from(
            jsonResponse['results'].map((book) => Book.fromJson(book)));

        final box = await Hive.openBox<Book>('books');

        for (var book in books) {
          print(book.title);
          box.put(book.id, book);
        }

        emit(BookLoaded(books: oldBooks + books));
      } else {
        emit(const BookError('Failed to fetch books'));
      }
    } catch (e) {
      emit(BookError(e.toString()));
    }

    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`");
  }
}
