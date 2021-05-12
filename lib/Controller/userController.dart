import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:learnfirebase_app/Model/userModel.dart';

class UserController extends GetxController{
  var name="".obs;
  var age="".obs;
  var gender="".obs;
  final user=UserModel(age: "12",name: "sok",gender: "male");

  Future<void> postData(){
    FirebaseFirestore.instance.runTransaction((transaction) async{
      CollectionReference reference=FirebaseFirestore.instance.collection("user");
      await reference.add(user.toMap);
    }).then((value) {
      print(value);
    });

  }
  Future<void> updateData(DocumentReference re,UserModel user){
    FirebaseFirestore.instance.runTransaction((transaction) async{
      // CollectionReference reference=FirebaseFirestore.instance.collection("user");
      await transaction.update(re,user.toMap);
    }).then((value) {
      print(value);
    });

  }
  Future<void> delectData(DocumentReference re){
    FirebaseFirestore.instance.runTransaction((transaction) async{
      // CollectionReference reference=FirebaseFirestore.instance.collection("user");
      await transaction.delete(re);
    }).then((value) {
      print(value);
    });

  }

}