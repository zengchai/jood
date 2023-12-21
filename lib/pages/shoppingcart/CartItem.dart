class CartItem {
  final String name;
  final String image;
  int quantity;
  final double price;
  final String foodID;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.foodID,
  });
}
