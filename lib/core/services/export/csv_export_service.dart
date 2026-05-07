import 'dart:io';

import 'package:csv/csv.dart' as csv_pkg;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:fintrack/features/transactions/model/category_model.dart';
import 'package:fintrack/features/transactions/model/transaction_model.dart';
import 'package:fintrack/generated/database/app_database.dart';

List<List<dynamic>> buildCsvRows(
  List<TransactionModel> transactions,
  List<CategoryModel> categories,
) {
  final catMap = {for (final c in categories) c.id: c.name};
  return [
    ['Date', 'Category', 'Note', 'Amount', 'Type', 'Receipt'],
    ...transactions.map((t) {
      return [
        DateFormat('yyyy-MM-dd').format(t.date),
        catMap[t.categoryId] ?? '',
        t.note ?? '',
        t.amount.toString(),
        t.amount < 0 ? 'Expense' : 'Income',
        t.receiptPath ?? '',
      ];
    }),
  ];
}

class CsvExportService {
  CsvExportService(this._db);

  final AppDatabase _db;

  Future<String> export(
    List<TransactionModel> transactions,
    List<CategoryModel> categories,
  ) async {
    final rows = buildCsvRows(transactions, categories);
    final csv = csv_pkg.csv.encode(rows);
    final dir = await getApplicationDocumentsDirectory();
    final name =
        'fintrack_export_${DateTime.now().millisecondsSinceEpoch}.csv';
    final filePath = p.join(dir.path, name);
    await File(filePath).writeAsString(csv);
    await _db.into(_db.exportMetadata).insert(
          ExportMetadataCompanion.insert(
            exportType: 'csv',
            exportedAt: DateTime.now(),
            recordCount: transactions.length,
          ),
        );
    return filePath;
  }
}
