import 'package:chat_super_app/helper/helper_file.dart';
import 'package:chat_super_app/screens/chat_page.dart';
import 'package:chat_super_app/services/database_servise.dart';
import 'package:chat_super_app/services/often_abused_function.dart';
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
  bool isJoined = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getCurentUserIdAndName();
  }

  getCurentUserIdAndName() async {
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
      user = FirebaseAuth.instance.currentUser;
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf('_'));
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
          centerTitle: true,
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
                      //searchUser();
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
                :
              //memberEmailList(),
            groupList(),
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

  searchUser() async{
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DataBaseService()
          .searchByEmail(searchController.text)
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
    return hasUserSearched
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index) {
          return groupTile(
            userName,
            searchSnapshot!.docs[index]['groupId'],
            searchSnapshot!.docs[index]['groupName'],
            searchSnapshot!.docs[index]['admin'],
          );
        })
        : Container();
  }

  memberEmailList() {
    return hasUserSearched
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index) {
          return memberTile(
            userName,
            searchSnapshot!.docs[index]['fullName'],
            searchSnapshot!.docs[index]['email'],
          );
        })
        : Container();
  }

  joinedOrNot(String userName, String groupId, String groupName,
      String admin) async {
    await DataBaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget memberTile(String admin, String userName, String email) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(userName),
      subtitle: Text(email),
      trailing: ElevatedButton(
        onPressed: () async {
          print('ADMIN : $admin');
          print('user : $userName');
            await DataBaseService().createPersonalGroup(admin, userName, true);
            // Змініть другий параметр, щоб зробити колекцію доступною всім (false) або тільки двом користувачам (true)
          },
        child: const Text('Написати'),),
    );
  }

  Widget groupTile(String userName, String groupId, String groupName,
      String admin) {
    //function to check whether user already exists i n group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('Адмін: ${getName(admin)}'),
      trailing: InkWell(
        onTap: () async {
          await DataBaseService(uid: user!.uid).toggleGroupJoin(
              groupId, userName, groupName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackBar(context, Colors.green, 'Приєднання до групи УСПІШНЕ');
            Future.delayed(const Duration(seconds: 2),
                    () {
                  nextScreen(context, ChatPage(groupId: groupId,
                      groupName: groupName,
                      userName: userName));
                }
            );
          } else {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackBar(context, Colors.redAccent, 'Вихід з групи $groupName');
          }
        },
        child: isJoined
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 1),
          ),
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text(
            'Приєднано',
            style: TextStyle(color: Colors.white),
          ),
        )
            : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme
                .of(context)
                .primaryColor,
          ),
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text(
            'Приєднатися',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
