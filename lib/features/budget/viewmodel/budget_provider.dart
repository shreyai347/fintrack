import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'budget_notifier.dart';
import 'budget_state.dart';

final budgetNotifierProvider =
    NotifierProvider<BudgetNotifier, BudgetState>(BudgetNotifier.new);
