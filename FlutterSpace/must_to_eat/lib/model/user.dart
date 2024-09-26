class User {
  String id;
  String password;
  String name;
  String phone;
  String address;
  String email;
  String? image;

  User({
    required this.id,
    required this.password,
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    this.image,
  });
}
