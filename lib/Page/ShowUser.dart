import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnfirebase_app/Controller/userController.dart';
import 'package:learnfirebase_app/Model/userModel.dart';
import 'package:learnfirebase_app/Page/addUser.dart';

class ShowScreen extends StatefulWidget {
  @override
  _ShowScreenState createState() => _ShowScreenState();
}

class _ShowScreenState extends State<ShowScreen> {
  final _userController = Get.put(UserController());
  final userModel = UserModel();
  List<UserModel> convertData(List<QueryDocumentSnapshot> docs) {
    List<UserModel> shopsList =
        docs.map((shop) => UserModel.fromSnapshot(shop)).toList();
    return shopsList;
  }

  final model =
      UserModel(gender: "New female", name: "New Virak", age: "New 21");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show"),
        actions: [
          IconButton(
            onPressed: () {
              // _userController.postData();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddUser(
                      status: "add",
                    ),
                  ));
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error);
          } else if (snapshot.hasData) {
            List<UserModel> userList = convertData(snapshot.data.docs);
            return userList.isNotEmpty
                ? ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        _userController.name.value = userList[index].name;
                        _userController.age.value = userList[index].age;
                        _userController.gender.value = userList[index].gender;
                        _userController.imageNetwork.value =
                            userList[index].image;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddUser(
                                status: "update",
                                reference: userList[index].reference,
                              ),
                            ));
                      },
                      child: ListTile(
                        leading: IconButton(
                          onPressed: () {
                            _userController
                                .delectData(userList[index].reference);
                          },
                          icon: Icon(Icons.delete),
                        ),
                        trailing: Container(
                          height: 50,
                          width: 50,
                          child: userList[index].image != null
                              ? Image.network(userList[index].image)
                              : Center(
                                  child: Icon(Icons.image),
                                ),
                        ),
                        // trailing: IconButton(
                        //   onPressed: (){
                        //     _userController.updateData(userList[index].reference, model);
                        //   },
                        //   icon: Icon(Icons.charging_station_outlined),
                        // ),
                        title: Text("${userList[index].name}"),
                        subtitle: Text("${userList[index].age}"),
                      ),
                    ),
                  )
                : Center(
                    child: Text("no"),
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
