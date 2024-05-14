class PetrolPrice {
  final DateTime date; // Store the date for the petrol price
  final double purchasingPrice;
  final double sellingPrice; // Store the price of the petrol

  // Constructor to initialize the date and price
  PetrolPrice(this.date, this.purchasingPrice, this.sellingPrice);

  @override
  String toString() {
    // Custom string representation for debugging or logging
    return 'PetrolPrice(date: ${date.toIso8601String()}, purchasingPrice: $purchasingPrice,sellingPrice:$sellingPrice)';
  }
}
