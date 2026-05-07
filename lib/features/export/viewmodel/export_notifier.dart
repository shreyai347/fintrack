import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:fintrack/core/services/export/csv_export_service.dart';
import 'package:fintrack/core/services/export/json_export_service.dart';
import 'package:fintrack/features/transactions/model/category_model.dart';
import 'package:fintrack/features/transactions/model/transaction_model.dart';
import 'package:fintrack/features/transactions/repository/category_repository_impl.dart';
import 'package:fintrack/features/transactions/repository/transaction_repository_impl.dart';
import 'package:fintrack/generated/database/app_database.dart';

sealed class ExportState {
  const ExportState();
}

class ExportIdle extends ExportState {
  const ExportIdle();
}

class ExportLoading extends ExportState {
  const ExportLoading(this.kind);
  final String kind;
}

class ExportSuccess extends ExportState {
  const ExportSuccess(this.filePath, this.exportType);
  final String filePath;
  final String exportType;
}

class ExportError extends ExportState {
  const ExportError(this.message);
  final String message;
}

class ExportNotifier extends Notifier<ExportState> {
  @override
  ExportState build() => const ExportIdle();

  Future<void> shareFile(String path) async {
    await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
  }

  Future<void> exportCsv() async {
    state = const ExportLoading('csv');
    try {
      final txs = await ref.read(transactionRepositoryProvider).getAll();
      final cats = await ref.read(categoryRepositoryProvider).getAll();
      final path =
          await ref.read(csvExportServiceProvider).export(txs, cats);
      state = ExportSuccess(path, 'csv');
      await shareFile(path);
      state = const ExportIdle();
    } catch (e) {
      state = ExportError('$e');
    }
  }

  Future<void> exportJson() async {
    state = const ExportLoading('json');
    try {
      final txs = await ref.read(transactionRepositoryProvider).getAll();
      final cats = await ref.read(categoryRepositoryProvider).getAll();
      final path =
          await ref.read(jsonExportServiceProvider).export(txs, cats);
      state = ExportSuccess(path, 'json');
      await shareFile(path);
      state = const ExportIdle();
    } catch (e) {
      state = ExportError('$e');
    }
  }

  String generateQrData(
    List<TransactionModel> transactions,
    List<CategoryModel> categories,
  ) {
    final catMap = {for (final c in categories) c.id: c.name};
    var spent = 0.0;
    var count = 0;
    final byCat = <int, double>{};
    for (final t in transactions) {
      count++;
      if (t.amount < 0) {
        final a = t.amount.abs();
        spent += a;
        byCat[t.categoryId] = (byCat[t.categoryId] ?? 0) + a;
      }
    }
    var topId = 0;
    var topAmt = 0.0;
    byCat.forEach((k, v) {
      if (v > topAmt) {
        topAmt = v;
        topId = k;
      }
    });
    final topName = topId == 0 ? '' : (catMap[topId] ?? '');
    final payload = {
      'spent': spent.toStringAsFixed(0),
      'txCount': count,
      'topCategory': topName,
    };
    var s = jsonEncode(payload);
    const maxLen = 1200;
    if (s.length > maxLen) {
      s = s.substring(0, maxLen);
    }
    return s;
  }

  void reset() => state = const ExportIdle();
}

final csvExportServiceProvider = Provider<CsvExportService>((ref) {
  return CsvExportService(ref.watch(appDatabaseProvider));
});

final jsonExportServiceProvider = Provider<JsonExportService>((ref) {
  return JsonExportService(ref.watch(appDatabaseProvider));
});

final exportNotifierProvider =
    NotifierProvider<ExportNotifier, ExportState>(ExportNotifier.new);
