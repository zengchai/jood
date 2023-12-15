class Orderclass {
  final String Order_ID;
  final String Date;
  final String Time;
  final String FoodImage;
  final String FoodName;
  final double FoodPrice;
  int FoodQuantity;
  final String Name;
  final String PaymentMethod;
  final String Status;
  final double TotalPrice;

  Orderclass({
    required this.Order_ID,
    required this.Date,
    required this.Time,
    required this.FoodImage,
    required this.FoodName,
    required this.FoodPrice,
    required this.FoodQuantity,
    required this.Name,
    required this.PaymentMethod,
    required this.Status,
    required this.TotalPrice,
  });
}
