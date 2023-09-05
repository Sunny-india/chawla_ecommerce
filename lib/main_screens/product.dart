class Product {
  String name;
  double price;
  double qty = 1;
  double qntty;
  List imagesUrl;
  String documentId;
  String supplierId;
  Product(
      {required this.name,
      required this.price,
      required this.qty,
      required this.qntty,
      required this.imagesUrl,
      required this.documentId,
      required this.supplierId});

  /// function created and called from the provider class
  void increament() {
    qty++;
  }

  /// function created and called from the provider class
  void decreament() {
    qty--;
  }
}
