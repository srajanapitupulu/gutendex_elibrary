import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gutendex_elibrary/helpers/services/api_service.dart';
import 'package:gutendex_elibrary/models/book.dart';

part 'recommendation_state.dart';

class RecommendedBooksCubit extends Cubit<RecommendedBooksState> {
  final ApiService apiService;

  RecommendedBooksCubit(this.apiService) : super(RecommendedBooksInitial());

  void fetchBooksByAuthor(String authorLastName) async {
    emit(RecommendedBooksLoading());
    try {
      final response = await apiService.fetchBooksByAuthor(authorLastName);
      emit(RecommendedBooksLoaded(response.books, response.nextUrl));
    } catch (e) {
      emit(RecommendedBooksError(e.toString()));
    }
  }

  void fetchBooksByKeyword(String keyword) async {
    emit(RecommendedBooksLoading());
    try {
      final response = await apiService.fetchBooksByKeyword(keyword);
      emit(RecommendedBooksLoaded(response.books, response.nextUrl));
    } catch (e) {
      emit(RecommendedBooksError(e.toString()));
    }
  }

  Future<void> fetchMoreBooks(String nextUrl) async {
    if (state is RecommendedBooksLoaded) {
      final currentState = state as RecommendedBooksLoaded;
      try {
        final response = await apiService.fetchBooksFromUrl(nextUrl);
        emit(RecommendedBooksLoaded(
          currentState.books + response.books,
          response.nextUrl,
        ));
      } catch (e) {
        emit(RecommendedBooksError(e.toString()));
      }
    }
  }
}
