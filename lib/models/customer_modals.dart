import 'dart:convert';
List<Customermodel>customermodelFromJson(String str) => List<Customermodel>.from(
    json.decode(str).map((x) => Customermodel.fromJson(x)));

String customermodelToJson(List<Customermodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customermodel {
  int customer_id;
  String email, password, name, dob, nationality, phone, address;
  Customermodel({
    required this.customer_id,
    required this.email,required this.password,required this.name,
    required this.dob,required this.nationality,required this.phone,required this.address,
  });

  factory Customermodel.fromJson(Map<String, dynamic>json)=>Customermodel(
      customer_id: json["customer_id"],
      email:json["email"],
      password:json["password"],
      name: json["name"],
      dob:json["dob"],
      nationality: json["nationality"],
      phone:json["phone"],
      address: json["address"]
  );
  Map<String, dynamic> toJson() => {
    "customer_id": customer_id,
    "email": email,
    "password": password,
    "name": name,
    "dob": dob,
    "nationality": nationality,
    "phone": phone,
    "address": address,
  };

}
