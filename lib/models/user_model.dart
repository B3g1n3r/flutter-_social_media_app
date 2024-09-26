class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String street;
  final String? suite; // Marked as nullable
  final String city;
  final String zipcode;
  final String phone;
  final String? website; // Marked as nullable
  final String companyName;
  final String companyCatchPhrase;
  final String companyBs;
  final double lat; // Changed to double
  final double lng; // Changed to double

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.street,
    this.suite,
    required this.city,
    required this.zipcode,
    required this.phone,
    this.website,
    required this.companyName,
    required this.companyCatchPhrase,
    required this.companyBs,
    required this.lat,
    required this.lng,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      street: json['address']['street'],
      suite: json['address']['suite'],
      city: json['address']['city'],
      zipcode: json['address']['zipcode'],
      phone: json['phone'],
      website: json['website'],
      companyName: json['company']['name'],
      companyCatchPhrase: json['company']['catchPhrase'],
      companyBs: json['company']['bs'],
      lat: double.parse(json['address']['geo']['lat']),
      lng: double.parse(json['address']['geo']['lng']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'address': {
        'street': street,
        'suite': suite,
        'city': city,
        'zipcode': zipcode,
        'geo': {
          'lat': lat.toString(),
          'lng': lng.toString(),
        },
      },
      'phone': phone,
      'website': website,
      'company': {
        'name': companyName,
        'catchPhrase': companyCatchPhrase,
        'bs': companyBs,
      },
    };
  }
}
