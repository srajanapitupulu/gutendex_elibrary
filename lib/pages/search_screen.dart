import 'package:flutter/material.dart';
import 'package:gutendex_elibrary/helpers/constants/colors.dart';
import 'package:gutendex_elibrary/models/search_history.dart';
import 'package:hive/hive.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchType = 'Author';
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
    });
  }

  void _saveSearchHistory(String query) {
    final box = Hive.box<SearchHistory>('searchHistoryBox');
    final searchHistory = SearchHistory()
      ..query = query
      ..timestamp = DateTime.now();
    box.add(searchHistory);
    _loadSearchHistory();
  }

  void _performSearch() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      _saveSearchHistory(query);
      // Implement your search logic here, for example using ApiService
      // final books = await ApiService().searchBooks(query, _searchType);
      // Display search results
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: whiteBGColor,
        foregroundColor: primaryColor,
        shadowColor: blackColor,
        title: const Text(
          "Search Books",
          style: (TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _searchType,
                  items: <String>['Author', 'Keyword'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _searchType = newValue!;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Search History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchHistory.length,
                itemBuilder: (context, index) {
                  final history = _searchHistory[index];
                  return ListTile(
                    title: Text(history.query),
                    subtitle: Text(history.timestamp.toString()),
                    onTap: () {
                      _searchController.text = history.query;
                      _performSearch();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
