// cubit/book_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gutendex_elibrary/models/book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  BookCubit() : super(BookInitial());

  final String _baseUrl = 'https://gutendex.com/books';
  String? _nextUrl;

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
        final List<Book> books = List<Book>.from(
            jsonResponse['results'].map((book) => Book.fromJson(book)));

        emit(BookLoaded(books: oldBooks + books));
      } else {
        emit(BookError('Failed to fetch books'));
      }
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
}
