class Product {
  String id;
  String options;
  double price;
  int quantity;
  String title;
  String imageUri;
  String category;
  String subCategory;
  String brand;

  Product.fromJSON(Map<dynamic, dynamic> proJSON) {
    this.id = proJSON['proId'];
    this.options = proJSON['options'];
    this.price = proJSON['price'].toDouble();
    this.quantity = proJSON['quantity'];
    this.title = proJSON['title'];
    this.imageUri = proJSON['imageUri'];
    this.category = proJSON['category'];
    this.subCategory = proJSON['subCategory'];
    this.brand = proJSON['brand'];
  }
}