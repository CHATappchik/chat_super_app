import 'package:chat_super_app/services/style.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;

  const GroupInfo({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.adminName
  });

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
            'Інформація про групу',
          style: appBarTitle,
        ),
        actions: [
          IconButton(onPressed: () {

          }, icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Center(
        child: Text(widget.adminName),
      ),
    );
  }
}
