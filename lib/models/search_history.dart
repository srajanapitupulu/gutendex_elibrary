import 'package:hive/hive.dart';

part 'search_history.g.dart';

@HiveType(typeId: 0)
class SearchHistory extends HiveObject {
  @HiveField(0)
  late String query;

  @HiveField(1)
  late DateTime timestamp;
}
