import 'dart:io';
import 'package:chat_super_app/helper/helper_file.dart';
import 'package:chat_super_app/services/database_servise.dart';
import 'package:chat_super_app/services/often_abused_function.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

import 'chats_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  String userName = "";
  String email = "";
  String pick = "";

  ProfileScreen(
      {Key? key,
      required this.userName,
      required this.email,
      required this.pick})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService authService = AuthService();
  File? _imageFile;

  Future getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;
    setState(() {
      _imageFile = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.pick.isEmpty
                  ? Column(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 145,
                          color: Colors.grey[700],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                DataBaseService()
                                    .getImageFromCamera()
                                    .then((value) {
                                  setState(() {
                                    _imageFile = value;
                                  });
                                  if (_imageFile != null) {
                                    DataBaseService()
                                        .uploadFileInStorage(_imageFile)
                                        .then((value) {
                                      setState(() {
                                        widget.pick = value;
                                        DataBaseService(
                                                uid: authService.firebaseAuth
                                                    .currentUser!.uid)
                                            .updatePathImage(widget.pick);
                                        HelperFunction.saveUserPickSF(
                                            widget.pick);
                                        nextScreenReplace(
                                            context, const ChatsListScreen());
                                      });
                                    });
                                  } else {
                                    showSnackBar(context, Colors.green,
                                        'Фото не вибрано');
                                  }
                                });
                              },
                              icon: const Icon(Icons.camera),
                              iconSize: 32,
                              padding: const EdgeInsets.only(top: 0),
                            ),
                            const SizedBox(width: 7),
                            IconButton(
                              onPressed: () {
                                getImageFromGallery().whenComplete(() {
                                  if (_imageFile != null) {
                                    DataBaseService()
                                        .uploadFileInStorage(_imageFile)
                                        .then((value) {
                                      setState(() {
                                        widget.pick = value;
                                        DataBaseService(
                                                uid: authService.firebaseAuth
                                                    .currentUser!.uid)
                                            .updatePathImage(widget.pick);
                                        HelperFunction.saveUserPickSF(
                                            widget.pick);
                                        nextScreenReplace(
                                            context, const ChatsListScreen());
                                      });
                                    });
                                  } else {
                                    showSnackBar(context, Colors.green,
                                        'Фото не вибрано');
                                  }
                                });
                              },
                              icon: const Icon(Icons.edit),
                              iconSize: 32,
                              padding: const EdgeInsets.only(top: 0),
                            ),
                          ],
                        )
                      ],
                    )
                  : Column(
                      children: [
                        CircleAvatar(
                          radius: 78,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget.pick,
                            ),
                            radius: 75,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                DataBaseService()
                                    .getImageFromCamera()
                                    .then((value) {
                                  setState(() {
                                    _imageFile = value;
                                  });
                                  if (_imageFile != null) {
                                    DataBaseService()
                                        .uploadFileInStorage(_imageFile)
                                        .then((value) {
                                      setState(() {
                                        widget.pick = value;
                                        DataBaseService(
                                                uid: authService.firebaseAuth
                                                    .currentUser!.uid)
                                            .updatePathImage(widget.pick);
                                        HelperFunction.saveUserPickSF(
                                            widget.pick);
                                        nextScreenReplace(
                                            context, const ChatsListScreen());
                                      });
                                    });
                                  } else {
                                    showSnackBar(context, Colors.green,
                                        'Фото не вибрано');
                                  }
                                });
                              },
                              icon: const Icon(Icons.camera),
                              iconSize: 32,
                              padding: const EdgeInsets.only(top: 0),
                            ),
                            const SizedBox(width: 7),
                            IconButton(
                              onPressed: () {
                                getImageFromGallery().whenComplete(() {
                                  if (_imageFile != null) {
                                    DataBaseService()
                                        .uploadFileInStorage(_imageFile)
                                        .then((value) {
                                      setState(() {
                                        widget.pick = value;
                                        DataBaseService(
                                                uid: authService.firebaseAuth
                                                    .currentUser!.uid)
                                            .updatePathImage(widget.pick);
                                        HelperFunction.saveUserPickSF(
                                            widget.pick);
                                        nextScreenReplace(
                                            context, const ChatsListScreen());
                                      });
                                    });
                                  } else {
                                    showSnackBar(context, Colors.green,
                                        'Фото не вибрано');
                                  }
                                });
                              },
                              icon: const Icon(Icons.edit),
                              iconSize: 32,
                              padding: const EdgeInsets.only(top: 0),
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              onPressed: () {
                                DataBaseService(
                                        uid: authService
                                            .firebaseAuth.currentUser!.uid)
                                    .updatePathImage('');
                                HelperFunction.saveUserPickSF(widget.pick);
                                nextScreenReplace(
                                    context, const ChatsListScreen());
                              },
                              icon: const Icon(Icons.delete),
                              iconSize: 32,
                              padding: const EdgeInsets.only(top: 0),
                            ),
                          ],
                        )
                      ],
                    ),
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Full Name", style: TextStyle(fontSize: 17)),
                  Text(widget.userName, style: const TextStyle(fontSize: 17)),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Email", style: TextStyle(fontSize: 17)),
                  Text(widget.email, style: const TextStyle(fontSize: 17)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
