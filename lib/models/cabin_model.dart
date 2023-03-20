// To parse this JSON data, do
//
//     final cabinModel = cabinModelFromJson(jsonString);

import 'dart:convert';

CabinModel cabinModelFromJson(String str) =>
    CabinModel.fromJson(json.decode(str));

String cabinModelToJson(CabinModel data) => json.encode(data.toJson());

class CabinModel {
  CabinModel({
    required this.authUser,
    required this.cabinName,
    required this.isSelected,
  });

  String authUser;
  String cabinName;
  bool isSelected;

  factory CabinModel.fromJson(Map<String, dynamic> json) => CabinModel(
        authUser: json["authUser"],
        cabinName: json["cabinName"],
        isSelected: json["isSelected"],
      );

  Map<String, dynamic> toJson() => {
        "authUser": authUser,
        "cabinName": cabinName,
        "isSelected": isSelected,
      };
}
