import 'package:flutter/material.dart';

import '../main_screens/product.dart';

class Cart extends ChangeNotifier {
  // create a list of products to be added in cart. by default keep it empty
  // will populate with add method down here.
  final List<Product> _productList = [];

  // the list above is created private. so create
  // a getter method to access it outside class.
  ///   ALMOST EVERY OPERATION WOULD BE RUN ONTO THIS LIST. SO WOULD
  ///   MAKE IT FULLY FUNCTIONAL HERE BY ADDING, REMOVING ITEMS AND OTHER THINGS
  ///   ON THIS LIST. AND WOULD USE IT OUTSIDE. SPECIALLY AT CARTSCREEN.
  List<Product> get getProductList {
    return _productList;
  }

  // create another getter method to get the
  // length of the list of products in cart.
  // Made its return type nullable, becuase anytime in the app, its length
  // go down to zero.
  int? get count {
    return _productList.length;
  }

  // create another getter method to get the total amount. A for loop would be run
  // through the _productList, in order to achieve that. Just because this is a getter
  // we don't need to add any notifyListners() here.
  double get totalPrice {
    double total = 0;
    for (var item in _productList) {
      total += item.price * item.qty;
    }
    return total;
  }

  // create another function to add products/items
  // in this list in cart. Just because it is a list of Products,
  // so would add all the same parameters of that type in this method and
  // pass them to the Product constructor.
  // watch carefully.
  // this can be done through another way too.
  void addItem(
    String name,
    double price,
    double qty,
    double qntty,
    List imagesUrl,
    String documentId,
    String supplierId,
  ) {
    // create an instance of Product class,
    // only to add to that list
    final product = Product(
      name: name,
      price: price,
      qty: qty,
      qntty: qntty,
      imagesUrl: imagesUrl,
      documentId: documentId,
      supplierId: supplierId,
    );
    // after fetching all the data, passing them to Product class,and
    // creating its object, it's time to add that object to the list of Product.
    // see that.
    _productList.add(product);
    // We're not finished yet, once all it is done, it is time to tell the
    // whole app about this changes. That's where below function is used for.
    notifyListeners();
  }

  // the above method can be done through passing the object of Product directly as
// the parameter of this function. like
// addItem(Product product){
// _productList(product);
//notifyListeners();
// }

  /// in order to make that increment function of the Product class listenable,
  /// we first passed its object to this method. And did with both the methods.
  void increaseQuantity(Product product) {
    product.increament();
    notifyListeners();
  }

  ///
  void reduceQuantity(Product product) {
    product.decreament();
    notifyListeners();
  }

  /// To remove particular item from the list in cart
  void removeItem(Product product) {
    _productList.remove(product);
    notifyListeners();
  }

  /// to clear or delete the whole items from the cart list
  void removeAllItems() {
    _productList.clear();
    notifyListeners();
  }
}
