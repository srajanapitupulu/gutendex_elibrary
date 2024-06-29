import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:gutendex_elibrary/helpers/constants/colors.dart';
import 'package:gutendex_elibrary/helpers/constants/constants.dart';
import 'package:gutendex_elibrary/helpers/database/database_helper.dart';
import 'package:gutendex_elibrary/helpers/ui/subject_container.dart';
import 'package:gutendex_elibrary/models/book.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;
  final List<Book> recommendedBooks;

  const BookDetailPage({
    super.key,
    required this.book,
    required this.recommendedBooks,
  });

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    isLiked = await DatabaseHelper().isBookLiked(widget.book.id);
    setState(() {});
  }

  void _toggleLike() async {
    if (isLiked) {
      await DatabaseHelper().deleteBook(widget.book.id);
    } else {
      await DatabaseHelper().insertBook(widget.book);
    }
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book.title,
          style: const TextStyle(
            color: blackColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        foregroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: widget.book.coverUrl,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: ScreenUtil.screenSize(context).width * 0.5,
                height: ScreenUtil.screenSize(context).width * 0.8,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.book.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : null,
                        ),
                        onPressed: _toggleLike,
                        iconSize: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.book.authors.join(', '),
                    style: const TextStyle(
                      fontSize: 16,
                      color: grayColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Language: ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: blackColor,
                      fontFamily: 'JosefinSans',
                    ),
                  ),
                  const SizedBox(height: 16),
                  SubjectsList(subjects: widget.book.subjects),
                  const SizedBox(height: 16),
                  const Text(
                    'More by this Author',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.recommendedBooks.length,
                      itemBuilder: (context, index) {
                        return RecommendedBookCard(
                          book: widget.recommendedBooks[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecommendedBookCard extends StatelessWidget {
  final Book book;

  const RecommendedBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookDetailPage(
              book: book,
              recommendedBooks: [], // You can pass another list of recommended books here
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: book.coverUrl,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              book.authors.join(', '),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
