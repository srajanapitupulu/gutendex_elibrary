import 'package:flutter/material.dart';
import 'package:gutendex_elibrary/helpers/constants/colors.dart';
import 'package:gutendex_elibrary/helpers/database/database_helper.dart';
import 'package:gutendex_elibrary/helpers/ui/book_card.dart';
import 'package:gutendex_elibrary/models/book.dart';

class LikedScreen extends StatefulWidget {
  const LikedScreen({super.key});

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  late Future<List<Book>> _likedBooks;

  @override
  void initState() {
    super.initState();
    _fetchLikedBooks();
  }

  void _fetchLikedBooks() {
    _likedBooks = DatabaseHelper().getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 3.0,
        backgroundColor: whiteBGColor,
        foregroundColor: primaryColor,
        shadowColor: blackColor,
        title: const Text(
          "Liked Books",
          style: (TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )),
        ),
      ),
      body: FutureBuilder<List<Book>>(
        future: _likedBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No liked books.'));
          }

          final likedBooks = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              childAspectRatio: 0.5,
            ),
            itemCount: likedBooks.length,
            itemBuilder: (context, index) {
              return BookCard(book: likedBooks[index]);
            },
          );
        },
      ),
    );
  }
}
