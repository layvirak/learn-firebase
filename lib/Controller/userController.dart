import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:learnfirebase_app/Model/userModel.dart';
import 'package:path/path.dart' as Path;

class UserController extends GetxController {
  var name = "".obs;
  var age = "".obs;
  var gender = "".obs;
  var imageNetwork = "".obs;
  var isLoading = false.obs;
  File image;
  void clearData() {
    name.value = "";
    age.value = "";
    gender.value = "";
    imageNetwork.value = "";
    image = null;
  }

  Future<void> postData() async {
    String getUrlImage;
    try {
      isLoading.value = true;
      Reference ref;
      ref = FirebaseStorage.instance
          .ref()
          .child("image/${Path.basename(image.path)}");
      await ref.putFile(image).whenComplete(() async {
        await ref.getDownloadURL().then((value) async {
          getUrlImage = value;
        });
      });
      final user = UserModel(
          age: age.value,
          name: name.value,
          gender: gender.value,
          image: getUrlImage);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        CollectionReference reference =
            FirebaseFirestore.instance.collection("user");
        await reference.add(user.toMap);
      }).then((value) {
        print(value);
      });
      Navigator.pop(Get.context);
    } catch (e) {
      print(e);
    } finally {
      clearData();
      isLoading.value = false;
      update();
    }
  }

  Future<void> updateData(DocumentReference re, String images) async {
    String getUrlImage;
    try {
      if (imageNetwork.value == null && images != null) {
        getUrlImage = null;
        String filePath = images
            .replaceAll(
                new RegExp(
                    r'https://firebasestorage.googleapis.com/v0/b/learn-21ad2.appspot.com/o/image%2F'),
                '')
            .split('?')[0];
        print(filePath);
        await FirebaseStorage.instance.ref().child("image/$filePath").delete();
      } else if (image != null && imageNetwork.value != null) {
        getUrlImage = null;
        String filePath = images
            .replaceAll(
                new RegExp(
                    r'https://firebasestorage.googleapis.com/v0/b/learn-21ad2.appspot.com/o/image%2F'),
                '')
            .split('?')[0];
        print(filePath);
        await FirebaseStorage.instance.ref().child("image/$filePath").delete();
      }

      if (image != null) {
        print("Here2");
        Reference ref;
        ref = FirebaseStorage.instance
            .ref()
            .child("image/${Path.basename(image.path)}");
        await ref.putFile(image).whenComplete(() async {
          await ref.getDownloadURL().then((value) async {
            getUrlImage = value;
          });
        });
      }
      final user = UserModel(
          age: age.value,
          name: name.value,
          gender: gender.value,
          image: getUrlImage);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        // CollectionReference reference=FirebaseFirestore.instance.collection("user");
        await transaction.update(re, user.toMap);
      }).then((value) {
        print(value);
      });
    } catch (e) {
      print(e);
    } finally {
      // clearData();
      isLoading.value = false;
      update();
    }
  }

  Future<void> delectData(DocumentReference re) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      // CollectionReference reference=FirebaseFirestore.instance.collection("user");
      await transaction.delete(re);
    }).then((value) {
      print(value);
    });
  }
}
