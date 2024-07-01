// cubit/book_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gutendex_elibrary/helpers/services/api_service.dart';
import 'package:gutendex_elibrary/models/book.dart';
import 'package:hive/hive.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final ApiService apiService;

  BookCubit(this.apiService) : super(BookInitial()) {
    _loadCachedBooks();
  }

  Future<void> _loadCachedBooks() async {
    final box = await Hive.openBox<Book>('booksCache');
    final cachedBooks = box.values.toList();
    if (cachedBooks.isNotEmpty) {
      emit(BookLoaded(cachedBooks, ''));
    }
  }

  void fetchBooks() async {
    if (state is BookLoading) return;

    final currentState = state;

    var oldBooks = <Book>[];
    if (currentState is BookLoaded) {
      oldBooks = currentState.books;
    }

    emit(BookLoading(oldBooks, isFirstFetch: true));

    try {
      final response = await apiService.fetchBooks();
      emit(BookLoaded(response.books, response.nextUrl));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> fetchMoreBooks(String nextUrl) async {
    if (state is BookLoaded) {
      final currentState = state as BookLoaded;
      try {
        final response = await apiService.fetchBooksFromUrl(nextUrl);
        emit(BookLoaded(
          currentState.books + response.books,
          response.nextUrl,
        ));
      } catch (e) {
        emit(BookError(e.toString()));
      }
    }
  }
}
