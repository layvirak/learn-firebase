import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnfirebase_app/Controller/userController.dart';

class AddUser extends StatefulWidget {
  DocumentReference reference;
  String status;
  AddUser({this.reference, this.status});

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final formKey = GlobalKey<FormState>();
  final _userController = Get.put(UserController());
  String getImages;
  @override
  void initState() {
    super.initState();
    if (_userController.imageNetwork.value != null) {
      getImages = _userController.imageNetwork.value;
    }
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _userController.image = File(pickedFile.path);
      _userController.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            _userController.clearData();
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              TextFormField(
                initialValue:
                    widget.status != "add" ? _userController.name.value : null,
                onSaved: (String value) {
                  _userController.name.value = value;
                  _userController.update();
                },
                decoration:
                    InputDecoration(hintText: "Enter Name", labelText: "Name"),
              ),
              TextFormField(
                initialValue:
                    widget.status != "add" ? _userController.age.value : null,
                onSaved: (String value) {
                  _userController.age.value = value;
                  _userController.update();
                },
                decoration:
                    InputDecoration(hintText: "Enter Age", labelText: "Age"),
              ),
              TextFormField(
                initialValue: widget.status != "add"
                    ? _userController.gender.value
                    : null,
                onSaved: (String value) {
                  _userController.gender.value = value;
                  _userController.update();
                },
                decoration: InputDecoration(
                    hintText: "Enter Gender", labelText: "Gender"),
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _userController.image = null;
                    _userController.imageNetwork.value = null;
                    _userController.update();
                  }),
              GetBuilder<UserController>(
                init: UserController(),
                builder: (controller) => GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: widget.status == "add"
                        ? _userController.image == null
                            ? Center(
                                child: Icon(Icons.camera),
                              )
                            : Image.file(_userController.image)
                        : _userController.image != null
                            ? Image.file(_userController.image)
                            : _userController.imageNetwork.value == null
                                ? Center(
                                    child: Icon(Icons.camera),
                                  )
                                : Image.network(
                                    _userController.imageNetwork.value),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: RaisedButton(
                onPressed: () {
                  _userController.clearData();
                  Navigator.pop(context);
                },
                child: Text("Back"),
              ),
            )),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(right: 20),
              child: RaisedButton(
                onPressed: () {
                  formKey.currentState.save();
                  if (widget.status == "add")
                    _userController.postData();
                  else
                    _userController.updateData(widget.reference, getImages);
                },
                child: Text("Submit"),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
