class PetrolPrice {
  final DateTime date;  // Store the date for the petrol price
  final double price;   // Store the price of the petrol

  // Constructor to initialize the date and price
  PetrolPrice(this.date, this.price);

  @override
  String toString() {
    // Custom string representation for debugging or logging
    return 'PetrolPrice(date: ${date.toIso8601String()}, price: $price)';
  }
}