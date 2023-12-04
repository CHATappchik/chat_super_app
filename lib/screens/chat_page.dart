import 'package:chat_super_app/component/message_tile.dart';
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

  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = '';
  String media = '';
  ScrollController _scrollController = ScrollController();
  bool showButton = false;

  @override
  void initState() {
    getChatAndAdmin();
    scrollListener();
    super.initState();
  }

  scrollListener() {
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          showButton = false;
        });
      }else{
        setState(() {
          showButton = true;
        });
      }
    });
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
        title: Text(widget.groupName, style: appBarTitle),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                        adminName: admin));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Відправити повідомлення ',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      sendMedia(context);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      sendMessages();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 0,
            child: Visibility(
              visible: showButton,
              child: SizedBox(
                width: 38,
                child: IconButton(
                  onPressed: () {
                    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                  },
                    icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Theme.of(context).primaryColor
                    ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey[200])
                  ),
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 85),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      time: snapshot.data.docs[index]['time'],
                      sendByMe: widget.userName ==
                          snapshot.data.docs[index]['sender'],
                    );
                  })
              : Container();
        });
  }

  sendMessages() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        'message': messageController.text,
        'sender': widget.userName,
        'time': Timestamp.now(),
      };
      DataBaseService().sendMessages(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  sendMedia(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Додайте медіа',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              IconButton(
                onPressed: () async {
                  try {
                    var val = await DataBaseService().getImageFromGallery();
                    var v = await DataBaseService().uploadFileInStorage(val);
                    setState(() {
                      media = v;
                    });
                    if (media.isNotEmpty) {
                      Map<String, dynamic> chatMessageMap = {
                        'message': media,
                        'sender': widget.userName,
                        'time': Timestamp.now(),
                      };
                      await DataBaseService()
                          .sendMessages(widget.groupId, chatMessageMap);
                      setState(() {
                        media = '';
                      });
                    }
                    Navigator.of(context).pop();

                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  } catch (e) {
                    print('ERRORO : $e');
                  }
                },
                icon: const Icon(Icons.image, color: Colors.white),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
              ),
              const SizedBox(width: 15),
              IconButton(
                onPressed: () async {
                  try {
                    var val = await DataBaseService().getImageFromCamera();
                    var v = await DataBaseService().uploadFileInStorage(val);
                    setState(() {
                      media = v;
                      print('MEDIA : $media');
                    });
                    if (media.isNotEmpty) {
                      Map<String, dynamic> chatMessageMap = {
                        'message': media,
                        'sender': widget.userName,
                        'time': Timestamp.now(),
                      };
                      await DataBaseService()
                          .sendMessages(widget.groupId, chatMessageMap);
                      setState(() {
                        media = '';
                      });
                    }
                    Navigator.of(context).pop();

                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  } catch (e) {
                    print('ERRORO : $e');
                  }
                },
                icon: const Icon(Icons.camera, color: Colors.white),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        });
  }
}
