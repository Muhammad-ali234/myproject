// class Customer {
//   String id;
//   String name;
//   String email;
//   String contact;
//   double? debit;
//   double? credit;

//   Customer({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.contact,
//     this.credit, // Marking credit as required
//     this.debit,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'contact': contact,
//       'credit': credit ?? 0.0, // Ensure credit is double or null
//       'debit': debit ?? 0.0, // Ensure debit is double or null
//     };
//   }

//   // Define a factory constructor to create a Customer object from a Map
//   factory Customer.fromMap(Map<String, dynamic> map) {
//     return Customer(
//       id: map['id'] ?? '', // Assuming 'id' is stored in the map
//       name: map['name'],
//       email: map['email'],
//       contact: map['contact'],
//       credit: map['credit']?.toDouble(), // Convert credit to double
//       debit: map['debit']?.toDouble(), // Convert debit to double
//     );
//   }
// }

class Customer {
  String id;
  String name;
  String email;
  String contact;
  String address;
  String cnic;
  double? debit;
  double? credit;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    required this.address,
    required this.cnic,
    this.credit,
    this.debit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contact': contact,
      'address': address,
      'cnic': cnic,
      'credit': credit ?? 0.0,
      'debit': debit ?? 0.0,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] != null ? map['id'].toString() : '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      contact: map['contact'] ?? '',
      address: map['address'] ?? '',
      cnic: map['cnic'] ?? '',
      credit: map['credit']?.toDouble(),
      debit: map['debit']?.toDouble(),
    );
  }
}
