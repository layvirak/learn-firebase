import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String name;
  String age;
  String gender;
  String image;
  DocumentReference reference;
  UserModel({this.reference,this.name,this.age,this.gender,this.image});
  UserModel.fromMap(Map<dynamic,dynamic> map,{this.reference}){
    name=map["name"];
    age=map['age'];
    gender=map['gender'];
    image=map['image'];
  }
  UserModel.fromSnapshot(DocumentSnapshot snapshot):this.fromMap(snapshot.data(),reference:snapshot.reference);
  Map<String,dynamic>get toMap=>
      {

        'name': name,
        'age': age,
        'gender': gender,
        'image':image
      };
}