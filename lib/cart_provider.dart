import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/db_helper.dart';

import 'cart_model.dart';

class CartProvider with ChangeNotifier {
  DBHelper db = DBHelper();
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart ;
  Future<List<Cart>>get cart => _cart;
  Future<List<Cart>> getData()async{
    _cart = db.getCartList();
    return _cart ;
  }
  void _setProfItems()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }
  void _getProfItems()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('totalPrice') ?? 0.0;
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice ;
    _setProfItems();
    notifyListeners();
  }
  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice ;
    _setProfItems();
    notifyListeners();
  }
  double getTotalPrice() {
    _getProfItems();
    return _totalPrice;

  }






  void addCounter() {
    _counter++;
    _setProfItems();
    notifyListeners();
  }
  void removeCounter() {
    _counter--;
    _setProfItems();
    notifyListeners();
  }
  int getCounter() {
    _getProfItems();
    return _counter;

  }
}