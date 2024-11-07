import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
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

  final sb.SupabaseClient supabase = sb.Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getElements({
    required String table,
    List<String>? columns,
    String? conditionOnColumn,
    dynamic conditionValue,
    ConditionType? conditionType,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    sb.PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
        supabase.from(table).select(columns?.join(", ") ?? '*');
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
}
