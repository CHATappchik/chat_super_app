import 'package:flutter/material.dart';

class UserData extends StatelessWidget {
  final String userName;
  final String userImage;

  const UserData({
    super.key,
    required this.userName,
    required this.userImage
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            userImage.isEmpty
                ? Icon(
                  Icons.account_circle,
                  size: 145,
                  color: Colors.grey[700],
            )
                : CircleAvatar(
                  radius: 78,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      userImage,
                    ),
                    radius: 75,
                  ),
                ),
            const SizedBox(height: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name", style: TextStyle(fontSize: 17)),
                Text(userName, style: const TextStyle(fontSize: 17)),
              ],
            ),
            const Divider(height: 20),
          ],
        ),
      ),
    );
  }
}
