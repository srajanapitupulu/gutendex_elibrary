import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gutendex_elibrary/helpers/services/book_cubit.dart';
import 'package:gutendex_elibrary/models/book.dart';
import 'package:gutendex_elibrary/helpers/services/api_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

class MockApiService extends Mock implements ApiService {}

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late BookCubit bookCubit;
  late MockApiService mockApiService;
  late MockBox<Book> mockBox;

  setUpAll(() async {
    await setUpTestHive();
  });

  setUp(() async {
    mockApiService = MockApiService();
    mockBox = MockBox<Book>();

    when(() => mockBox.values).thenReturn([]);
    when(() => Hive.openBox<Book>('booksCache'))
        .thenAnswer((_) async => mockBox);

    bookCubit = BookCubit(mockApiService);
  });

  tearDown(() async {
    await tearDownTestHive();
    bookCubit.close();
  });

  group('BookCubit', () {
    final books = [
      Book(
          id: 0,
          title: 'Test Book 1',
          authors: ['Author 1'],
          coverUrl: 'url1',
          bookUrl: 'htmlUrl1',
          mediatype: "Text",
          languages: ["en"],
          subjects: ["Subject 1"]),
      Book(
          id: 1,
          title: 'Test Book 2',
          authors: ['Author 2'],
          coverUrl: 'url2',
          bookUrl: 'htmlUrl2',
          mediatype: "Text",
          languages: ["en"],
          subjects: ["Subject 2"]),
    ];
    final nextUrl = 'https://next-url.com';

    blocTest<BookCubit, BookState>(
      'emits [BookInitial, BookLoaded] when _loadCachedBooks finds cached books',
      build: () {
        when(() => mockBox.values).thenReturn(books);
        return bookCubit;
      },
      act: (cubit) {},
      expect: () => [
        BookInitial(),
        BookLoaded(books, ''),
      ],
      verify: (_) {
        verify(() => Hive.openBox<Book>('booksCache')).called(1);
      },
    );

    blocTest<BookCubit, BookState>(
      'emits [BookLoading, BookLoaded] when fetchBooks is successful',
      build: () {
        when(() => mockApiService.fetchBooks())
            .thenAnswer((_) async => ApiResponse(books, nextUrl));
        return bookCubit;
      },
      act: (cubit) => cubit.fetchBooks(),
      expect: () => [
        BookLoading([], isFirstFetch: true),
        BookLoaded(books, nextUrl),
      ],
      verify: (_) {
        verify(() => mockApiService.fetchBooks()).called(1);
      },
    );

    blocTest<BookCubit, BookState>(
      'emits [BookLoading, BookError] when fetchBooks fails',
      build: () {
        when(() => mockApiService.fetchBooks())
            .thenThrow(Exception('Failed to fetch books'));
        return bookCubit;
      },
      act: (cubit) => cubit.fetchBooks(),
      expect: () => [
        BookLoading([], isFirstFetch: true),
        BookError('Exception: Failed to fetch books'),
      ],
      verify: (_) {
        verify(() => mockApiService.fetchBooks()).called(1);
      },
    );

    blocTest<BookCubit, BookState>(
      'emits [BookLoaded] with additional books when fetchMoreBooks is successful',
      build: () {
        when(() => mockApiService.fetchBooksFromUrl(nextUrl))
            .thenAnswer((_) async => ApiResponse(books, nextUrl));
        bookCubit.emit(BookLoaded(books, nextUrl));
        return bookCubit;
      },
      act: (cubit) => cubit.fetchMoreBooks(nextUrl),
      expect: () => [
        BookLoaded(books + books, nextUrl),
      ],
      verify: (_) {
        verify(() => mockApiService.fetchBooksFromUrl(nextUrl)).called(1);
      },
    );

    blocTest<BookCubit, BookState>(
      'emits [BookError] when fetchMoreBooks fails',
      build: () {
        when(() => mockApiService.fetchBooksFromUrl(nextUrl))
            .thenThrow(Exception('Failed to fetch more books'));
        bookCubit.emit(BookLoaded(books, nextUrl));
        return bookCubit;
      },
      act: (cubit) => cubit.fetchMoreBooks(nextUrl),
      expect: () => [
        BookError('Exception: Failed to fetch more books'),
      ],
      verify: (_) {
        verify(() => mockApiService.fetchBooksFromUrl(nextUrl)).called(1);
      },
    );
  });
}
