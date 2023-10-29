import 'package:chat_super_app/services/database_servise.dart';
import 'package:chat_super_app/services/often_abused_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/style.dart';
import 'group_info.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.userName
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = '';

  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }
  getChatAndAdmin() {
    DataBaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DataBaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
            widget.groupName,
        style: appBarTitle
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: () {
            nextScreen(context, GroupInfo(
              groupId: widget.groupId,
              groupName: widget.groupName,
              adminName: admin
            ));
          },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Center(
        child: Text(widget.groupName),
      ),
    );
  }
}
