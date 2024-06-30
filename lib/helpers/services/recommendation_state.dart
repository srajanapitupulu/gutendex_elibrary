part of 'recommendation_cubit.dart';

abstract class RecommendedBooksState extends Equatable {
  const RecommendedBooksState();
  @override
  List<Object> get props => [];
}

class RecommendedBooksInitial extends RecommendedBooksState {}

class RecommendedBooksLoading extends RecommendedBooksState {}

class RecommendedBooksLoaded extends RecommendedBooksState {
  final List<Book> books;
  final String? nextUrl;

  const RecommendedBooksLoaded(this.books, this.nextUrl);

  @override
  List<Object> get props => [books];
}

class RecommendedBooksError extends RecommendedBooksState {
  final String message;

  const RecommendedBooksError(this.message);

  @override
  List<Object> get props => [message];
}
