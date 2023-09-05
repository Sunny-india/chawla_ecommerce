import 'package:flutter/material.dart';

import '../main_screens/product.dart';

class WishList extends ChangeNotifier {
  //
  final List<Product> _wishList = [];
  //
  List<Product> get getWishList {
    return _wishList;
  }

//
  int? get count {
    return _wishList.length;
  }

  Future<void> addToWishList(
    String name,
    double price,
    double qty,
    double qntty,
    List imagesUrl,
    String documentId,
    String supplierId,
  ) async {
    final product = Product(
        name: name,
        price: price,
        qty: qty,
        qntty: qntty,
        imagesUrl: imagesUrl,
        documentId: documentId,
        supplierId: supplierId);
    _wishList.add(product);
    notifyListeners();
  }

  //
  void removeFromWishList(String id) {
    _wishList.removeWhere((product) => product.documentId == id);
    notifyListeners();
  }

  void removeWishList() {
    _wishList.clear();
    notifyListeners();
  }
}
