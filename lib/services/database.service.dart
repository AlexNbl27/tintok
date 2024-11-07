import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum ConditionType {
  equal,
  greater,
  less,
  greaterOrEqual,
  lessOrEqual,
  like,
  notEqual,
}

class DatabaseService {
  // Singleton instance
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  static DatabaseService get instance => _instance;

  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getElements({
    required String table,
    List<String>? columns,
    List<String>? joinTables,
    String? conditionOnColumn,
    dynamic conditionValue,
    ConditionType? conditionType,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    String selectColumns = columns?.join(", ") ?? '*';
    if (joinTables != null && joinTables.isNotEmpty) {
      String joinSelect =
          joinTables.map((table) => '$table!inner(*)').join(", ");
      selectColumns = "$selectColumns, $joinSelect";
    }

    PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
        supabase.from(table).select(selectColumns);

    if (conditionOnColumn != null &&
        conditionValue != null &&
        conditionType != null) {
      switch (conditionType) {
        case ConditionType.equal:
          query = query.eq(conditionOnColumn, conditionValue);
          break;
        case ConditionType.greater:
          query = query.gt(conditionOnColumn, conditionValue);
          break;
        case ConditionType.less:
          query = query.lt(conditionOnColumn, conditionValue);
          break;
        case ConditionType.greaterOrEqual:
          query = query.gte(conditionOnColumn, conditionValue);
          break;
        case ConditionType.lessOrEqual:
          query = query.lte(conditionOnColumn, conditionValue);
          break;
        case ConditionType.like:
          query = query.ilike(conditionOnColumn, conditionValue);
          break;
        case ConditionType.notEqual:
          query = query.neq(conditionOnColumn, conditionValue);
          break;
      }
    }

    PostgrestTransformBuilder? transformedQuery;
    if (orderBy != null) {
      transformedQuery = query.order(orderBy, ascending: ascending);
    }
    if (limit != null) {
      transformedQuery =
          transformedQuery?.range(offset ?? 0, (offset ?? 0) + limit) ??
              query.range(offset ?? 0, (offset ?? 0) + limit);
    }

    try {
      final data = await query;
      return data;
    } catch (error) {
      debugPrint('Error during query: $error');
      throw Exception('Error during query');
    }
  }

  Future<void> insertElement({
    required String table,
    required Map<String, dynamic> values,
  }) async {
    try {
      await supabase.from(table).insert(values);
    } catch (error) {
      debugPrint('Error during insertion: $error');
      throw Exception('Error during insertion');
    }
  }
}
