import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:fintrack/features/transactions/model/category_model.dart';
import 'package:fintrack/features/transactions/model/transaction_model.dart';
import 'package:fintrack/generated/database/app_database.dart';

Map<String, dynamic> buildJsonPayload(
  List<TransactionModel> transactions,
  List<CategoryModel> categories,
  String appVersion,
  DateTime exportedAt,
) {
  final catMap = {for (final c in categories) c.id: c.name};
  return {
    'exportedAt': exportedAt.toIso8601String(),
    'appVersion': appVersion,
    'transactions': [
      for (final t in transactions)
        {
          'id': t.id,
          'date': t.date.toIso8601String(),
          'category': catMap[t.categoryId] ?? '',
          'note': t.note,
          'amount': t.amount,
          'type': t.amount < 0 ? 'Expense' : 'Income',
          'receiptPath': t.receiptPath,
        },
    ],
  };
}

class JsonExportService {
  JsonExportService(this._db);

  final AppDatabase _db;

  Future<String> export(
    List<TransactionModel> transactions,
    List<CategoryModel> categories,
  ) async {
    final info = await PackageInfo.fromPlatform();
    final exportedAt = DateTime.now();
    final payload = buildJsonPayload(
      transactions,
      categories,
      info.version,
      exportedAt,
    );
    final dir = await getApplicationDocumentsDirectory();
    final name =
        'fintrack_export_${DateTime.now().millisecondsSinceEpoch}.json';
    final filePath = p.join(dir.path, name);
    await File(filePath).writeAsString(
      JsonEncoder.withIndent('  ').convert(payload),
    );
    await _db.into(_db.exportMetadata).insert(
          ExportMetadataCompanion.insert(
            exportType: 'json',
            exportedAt: DateTime.now(),
            recordCount: transactions.length,
          ),
        );
    return filePath;
  }
}
