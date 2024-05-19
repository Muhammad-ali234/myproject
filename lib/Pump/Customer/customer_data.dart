
class Customer {
  String id;
  String name;
  String email;
  String contact;
  double? debit;
  double? credit;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    this.credit, // Marking credit as required
    this.debit,
  });

  // Define the toMap method to convert Customer object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contact': contact,
      'credit': credit,
      'debit': debit,
    };
  }

  // Define a factory constructor to create a Customer object from a Map
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] ?? '', // Assuming 'id' is stored in the map
      name: map['name'],
      email: map['email'],
      contact: map['contact'],
      credit: map['credit'],
      debit: map['debit'],
    );
  }
}
