import 'package:chat_super_app/services/often_abused_function.dart';
import 'package:flutter/material.dart';
import '../screens/chat_page.dart';
import '../services/database_servise.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile(
      {super.key,
      required this.userName,
      required this.groupId,
      required this.groupName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {

  String adminGroup = '';

  @override
  void initState() {
    getAdmin();
    super.initState();
  }


  getAdmin() {
    DataBaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        adminGroup = value.substring(value.indexOf('_') + 1);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(context, ChatPage(
          groupId: widget.groupId,
          groupName: widget.groupName,
          userName: widget.userName,
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,fontWeight: FontWeight.w500
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Приєднатись до розмови як ${widget.userName}',
            style: const TextStyle(fontSize: 13),
          ),
          trailing: widget.userName == adminGroup ?
          IconButton(
              onPressed: () {
                DataBaseService().deleteGroup(widget.groupId, widget.groupName);
                },
              icon: Icon(
                  Icons.delete_sweep,
                size: 30,
                color: Theme.of(context).primaryColor,
              ))
              : const SizedBox(),
        ),
      ),
    );
  }
}
