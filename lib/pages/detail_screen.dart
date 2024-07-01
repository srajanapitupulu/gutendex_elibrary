import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gutendex_elibrary/helpers/constants/colors.dart';
import 'package:gutendex_elibrary/helpers/constants/constants.dart';
import 'package:gutendex_elibrary/helpers/database/database_helper.dart';
import 'package:gutendex_elibrary/helpers/services/api_service.dart';
import 'package:gutendex_elibrary/helpers/services/recommendation_cubit.dart';
import 'package:gutendex_elibrary/helpers/ui/recommendation_container.dart';
import 'package:gutendex_elibrary/helpers/ui/subject_container.dart';
import 'package:gutendex_elibrary/models/book.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late bool isLiked = false;

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
      backgroundColor: whiteBGColor,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        shadowColor: blackColor,
        title: Text(
          widget.book.title,
          style: (const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: whiteColor,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: widget.book.coverUrl,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.error);
                  },
                  width: ScreenUtil.screenSize(context).width * 0.5,
                  height: ScreenUtil.screenSize(context).width * 0.8,
                  fit: BoxFit.contain,
                ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Language: ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: blackColor,
                          fontFamily: 'JosefinSans',
                        ),
                      ),
                      Text(
                        widget.book.languages.map((e) => e).join(','),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: blackColor,
                          fontFamily: 'JosefinSans',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: grayColor,
                        ),
                      ),
                    ),
                    child: SubjectsList(subjects: widget.book.subjects),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'More by this Author',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  BlocProvider(
                    create: (context) => RecommendedBooksCubit(ApiService())
                      ..fetchBooksByAuthor(
                          widget.book.authors.first.split(' ').first),
                    child: Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: const RecommendationContainer()),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
