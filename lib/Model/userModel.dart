import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String name;
  String age;
  String gender;
  DocumentReference reference;
  UserModel({this.reference,this.name,this.age,this.gender});
  UserModel.fromMap(Map<dynamic,dynamic> map,{this.reference}){
    name=map["name"];
    age=map['age'];
    gender=map['gender'];
  }
  UserModel.fromSnapshot(DocumentSnapshot snapshot):this.fromMap(snapshot.data(),reference:snapshot.reference);
  Map<String,dynamic>get toMap=>
      {

        'name': name,
        'age': age,
        'gender': gender
      };
}