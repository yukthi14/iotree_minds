import 'package:flutter/material.dart';
import 'package:iotree_minds/api_services.dart';

import 'model.dart';

class DataProvider with ChangeNotifier {
  final ApiServices apiServices = ApiServices();
  List<Item> _items = [];
  bool _isLoading = false;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await apiServices.fetchItems();
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createItem(Item item) async {
    try {
      final newItem = await apiServices.createItem(item);
      _items.add(newItem);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateItem(String id, Item item) async {
    try {
      final updatedItem = await apiServices.updateItem(id, item);
      final index = _items.indexWhere((i) => i.id == id);
      if (index != -1) {
        _items[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await apiServices.deleteItem(id);
      items.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
