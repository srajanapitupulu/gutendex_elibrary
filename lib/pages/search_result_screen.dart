import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gutendex_elibrary/helpers/services/api_service.dart';
import 'package:gutendex_elibrary/helpers/constants/colors.dart';
import 'package:gutendex_elibrary/helpers/services/recommendation_cubit.dart';
import 'package:gutendex_elibrary/helpers/ui/book_card.dart';

class SearchResultScreen extends StatefulWidget {
  final String keyword;
  const SearchResultScreen({super.key, required this.keyword});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        shadowColor: blackColor,
        title: Text(
          widget.keyword,
          style: (const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )),
        ),
      ),
      body: BlocProvider(
        create: (context) => RecommendedBooksCubit(ApiService())
          ..fetchBooksByKeyword(widget.keyword),
        child: BlocBuilder<RecommendedBooksCubit, RecommendedBooksState>(
          builder: (context, state) {
            if (state is RecommendedBooksLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecommendedBooksError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is RecommendedBooksLoaded) {
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    context
                        .read<RecommendedBooksCubit>()
                        .fetchMoreBooks(state.nextUrl!);
                  }
                  return false;
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 4 : 2,
                    childAspectRatio: 0.5,
                  ),
                  itemCount: state.books.length,
                  itemBuilder: (context, index) {
                    final book = state.books[index];
                    return BookCard(book: book);
                  },
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
