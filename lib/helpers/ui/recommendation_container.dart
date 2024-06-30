import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gutendex_elibrary/helpers/constants/constants.dart';
import 'package:gutendex_elibrary/helpers/services/recommendation_cubit.dart';
import 'package:gutendex_elibrary/helpers/ui/book_card.dart';

class RecommendationContainer extends StatefulWidget {
  const RecommendationContainer({super.key});

  @override
  State<RecommendationContainer> createState() =>
      _RecommendationContainerState();
}

class _RecommendationContainerState extends State<RecommendationContainer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendedBooksCubit, RecommendedBooksState>(
        builder: (context, state) {
      if (state is RecommendedBooksLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is RecommendedBooksError) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is RecommendedBooksLoaded) {
        return ListView.builder(
            itemCount: state.books.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final book = state.books[index];
              final cardWidth = ScreenUtil.screenSize(context).width * 0.4;
              return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  width: cardWidth,
                  child: BookCard(book: book));
            });

        // return GridView.builder(
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
        //     childAspectRatio: 0.7,
        //   ),
        //   itemCount: state.books.length,
        //   itemBuilder: (context, index) {
        // final book = state.books[index];
        // return BookCard(book: book);
        //   },
        // );
      } else {
        return const SizedBox.shrink();
      }
    });
    // return ListView.builder(
    //                 scrollDirection: Axis.horizontal,
    //                 itemCount: recommendedBooks.length,
    //                 itemBuilder: (context, index) {
    //                   final book = recommendedBooks[index];
    //                   return BookCard(book: widget.book);
    //                 },
    //               ),;
  }
}
