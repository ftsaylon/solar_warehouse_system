import 'package:flutter/material.dart';
import 'package:solar_warehouse_system/models/quote_item.dart';

class QuoteItems extends ChangeNotifier {
  Map<String, QuoteItem> _quoteItems = {};

  Map<String, QuoteItem> get quoteItems => {..._quoteItems};

  void addQuoteItem(QuoteItem quoteItem) {
    if (_quoteItems.containsKey(quoteItem.id)) {
      _quoteItems.update(
        quoteItem.id,
        (value) => value.copyWith(
          quantity: value.quantity + quoteItem.quantity,
        ),
      );
    } else {
      _quoteItems.putIfAbsent(quoteItem.id, () => quoteItem);
    }
    notifyListeners();
  }

  void fetchAndSetQuoteItems(Map<String, QuoteItem> quoteItems) {
    _quoteItems = quoteItems;
    notifyListeners();
  }

  void clear() {
    _quoteItems = {};
    notifyListeners();
  }

  int get itemCount {
    return _quoteItems.length;
  }

  double get total {
    var total = 0.0;
    _quoteItems.forEach((key, quoteItem) {
      total += quoteItem.subTotal;
    });
    return total;
  }
}
