import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:gutendex_elibrary/helpers/services/book_cubit.dart';
import 'package:gutendex_elibrary/helpers/constants/colors.dart';
import 'package:gutendex_elibrary/helpers/ui/book_card.dart';
import 'package:gutendex_elibrary/models/book.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PagingController<int, Book> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      context.read<BookCubit>().fetchBooks();
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
  // final List<Book> books = List.generate(
  //   20,
  //   (index) => Book(
  //     title: 'Book Title $index',
  //     authors: 'Author $index',
  //     coverUrl: 'https://via.placeholder.com/150',
  //     id: index, // Replace with actual image URLs
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteBGColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        foregroundColor: primaryColor,
        backgroundColor: whiteBGColor,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                style: BorderStyle.solid,
                width: 0.5,
                color: whiteBGColor,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle sort action
            },
          ),
        ],
      ),
      body: BlocListener<BookCubit, BookState>(
        listener: (context, state) {
          if (state is BookLoaded) {
            final isLastPage = state.books.length < 20;
            if (isLastPage) {
              _pagingController.appendLastPage(state.books);
            } else {
              final nextPageKey = _pagingController.itemList?.length;
              _pagingController.appendPage(state.books, nextPageKey);
            }
          }
          if (state is BookError) {
            _pagingController.error = state.message;
          }
        },
        child: PagedGridView<int, Book>(
          pagingController: _pagingController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
            childAspectRatio: 0.6,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          builderDelegate: PagedChildBuilderDelegate<Book>(
            itemBuilder: (context, item, index) => BookCard(book: item),
          ),
        ),
      ),
    );
  }
}
