class PigeonUserDetails {
  String? name;
  String? email;

  PigeonUserDetails({this.name, this.email});

  factory PigeonUserDetails.fromJson(Map<String, dynamic> json) {
    return PigeonUserDetails(
      name: json['name'],
      email: json['email'],
    );
  }
}
