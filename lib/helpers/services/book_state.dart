// cubit/book_state.dart
part of 'book_cubit.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {
  final List<Book> oldBooks;
  final bool isFirstFetch;

  const BookLoading(this.oldBooks, {this.isFirstFetch = false});

  @override
  List<Object?> get props => [oldBooks, isFirstFetch];
}

class BookLoaded extends BookState {
  final List<Book> books;
  final String? nextUrl;

  const BookLoaded(this.books, this.nextUrl);

  @override
  List<Object> get props => [books, nextUrl ?? ''];
}

class BookError extends BookState {
  final String message;

  const BookError(this.message);

  @override
  List<Object?> get props => [message];
}
