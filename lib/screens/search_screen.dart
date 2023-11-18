import 'package:chat_super_app/helper/helper_file.dart';
import 'package:chat_super_app/services/database_servise.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/style.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = '';
  User? user;

  @override
  void initState() {
    super.initState();
    getCurentUserIdAndName();
  }

  getCurentUserIdAndName() async{
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
      user = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          title: const Text(
            'Пошук',
            style: appBarTitle,
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Theme
                  .of(context)
                  .primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Пошук груп....',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSerchMethod();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(
                child: CircularProgressIndicator(
                    color: Theme
                        .of(context)
                        .primaryColor))
                : groupList(),
          ],
        ));
  }

  initiateSerchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DataBaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched ?
    ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index) {
          return groupTile(
            userName,
            searchSnapshot!.docs[index]['groupId'],
            searchSnapshot!.docs[index]['groupName'],
            searchSnapshot!.docs[index]['admin'],
          );
        }
    )
        : Container();
  }

  Widget groupTile(String userName, String groupId, String groupName, String admin) {
    return Text('Ага');
  }
}
