import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gutendex_elibrary/helpers/constants/colors.dart';
import 'package:gutendex_elibrary/helpers/ui/book_card.dart';
import 'package:gutendex_elibrary/models/book.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Book> books = List.generate(
    20,
    (index) => Book(
      title: 'Book Title $index',
      author: 'Author $index',
      coverImage:
          'https://via.placeholder.com/150', // Replace with actual image URLs
    ),
  );

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
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle sort action
                  },
                  icon: Icon(Icons.sort),
                  label: Text('Sort'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle filter action
                  },
                  icon: Icon(Icons.filter_list),
                  label: Text('Filter'),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int columns = constraints.maxWidth < 600 ? 2 : 4;
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return BookCard(book: books[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
