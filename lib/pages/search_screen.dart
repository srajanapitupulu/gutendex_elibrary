import 'package:flutter/material.dart';
import 'package:gutendex_elibrary/pages/search_result_screen.dart';
import 'package:hive/hive.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gutendex_elibrary/helpers/constants/colors.dart';
import 'package:gutendex_elibrary/models/search_history.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchHistory> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  void _loadSearchHistory() async {
    await Hive.openBox<SearchHistory>('searchHistoryBox');
    final box = Hive.box<SearchHistory>('searchHistoryBox');
    setState(() {
      _searchHistory = box.values.toList();
      _searchHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  void _saveSearchHistory(String query, int selectedIdx) {
    final box = Hive.box<SearchHistory>('searchHistoryBox');
    final searchHistory = SearchHistory()
      ..query = query
      ..searchBy = "Keyword"
      ..timestamp = DateTime.now();

    if (selectedIdx == -999) {
      box.add(searchHistory);
    } else {
      box.putAt(selectedIdx, searchHistory);
    }

    _loadSearchHistory();
  }

  void _performSearch({int selectedIdx = -999}) async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      _saveSearchHistory(query, selectedIdx);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(
            keyword: query,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        shadowColor: blackColor,
        title: const Text(
          "Search Books",
          style: (TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            color: whiteBGColor,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: primaryColor),
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: primaryColor),
                        hintText: 'Search...',
                        border: InputBorder.none),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: primaryColor,
                  ),
                  onPressed: _performSearch,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _searchHistory.length,
              itemBuilder: (context, index) {
                final history = _searchHistory[index];
                return ListTile(
                  title: Text(
                    history.query,
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    timeago.format(history.timestamp),
                    style: const TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  leading: const Icon(
                    Icons.history,
                    color: primaryColor,
                  ),
                  trailing: const Icon(
                    Icons.call_made,
                    color: primaryColor,
                  ),
                  onTap: () {
                    _searchController.text = history.query;
                    _performSearch(selectedIdx: history.key);
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
