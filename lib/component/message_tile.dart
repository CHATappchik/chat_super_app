import 'package:chat_super_app/screens/big_image.dart';
import 'package:chat_super_app/services/often_abused_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final Timestamp time;
  final bool sendByMe;

  const MessageTile({
    super.key,
    required this.message,
    required this.sender,
    required this.time,
    required this.sendByMe,
  });

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  Icon iconLike = const Icon(Icons.favorite_border_outlined);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sendByMe ? 0 : 24,
        right: widget.sendByMe ? 24 : 0,
      ),
      alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: widget.sendByMe ? TextDirection.rtl : TextDirection.ltr,
        children: [
          widget.sendByMe
              ? const SizedBox()
              : CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    widget.sender.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
          const SizedBox(width: 15),
          Flexible(
            child: Container(
              margin: widget.sendByMe
                  ? const EdgeInsets.only(left: 40)
                  : const EdgeInsets.only(right: 40),
              padding: const EdgeInsets.only(
                  top: 5, bottom: 5, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: widget.sendByMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                color: widget.sendByMe
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.sendByMe
                      ? const SizedBox()
                      : Text(
                          widget.sender.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                  const SizedBox(height: 8),
                  widget.message.startsWith(
                          'https://firebasestorage.googleapis.com/v0/b/chatsuperapp.appspot.com')
                      ? GestureDetector(
                    onTap: () {
                      nextScreen(context, BigImage(image: widget.message));
                    },
                        child: Image.network(
                        widget.message,
                    height: 200,
                  ),
                      )
                      : Text(
                          widget.message,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                  Text(
                    '${widget.time.toDate().hour}:${widget.time.toDate().minute}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
