import 'package:fintrack/generated/database/app_database.dart' as db;

typedef RecurringRuleEntry = db.RecurringRule;

enum FrequencyType { daily, weekly, monthly }

class RecurringRuleModel {
  const RecurringRuleModel({
    required this.id,
    required this.frequency,
    required this.nextDueDate,
    required this.lastGeneratedDate,
    required this.isActive,
    required this.createdAt,
  });

  final int id;
  final String frequency;
  final DateTime nextDueDate;
  final DateTime? lastGeneratedDate;
  final bool isActive;
  final DateTime createdAt;

  factory RecurringRuleModel.fromDrift(RecurringRuleEntry entry) {
    return RecurringRuleModel(
      id: entry.id,
      frequency: entry.frequency,
      nextDueDate: entry.nextDueDate,
      lastGeneratedDate: entry.lastGeneratedDate,
      isActive: entry.isActive,
      createdAt: entry.createdAt,
    );
  }

  FrequencyType get frequencyType {
    switch (frequency) {
      case 'daily':
        return FrequencyType.daily;
      case 'weekly':
        return FrequencyType.weekly;
      case 'monthly':
        return FrequencyType.monthly;
      default:
        return FrequencyType.monthly;
    }
  }
}
