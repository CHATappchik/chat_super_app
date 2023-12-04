import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class DataBaseService {
  final String? uid;

  DataBaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  final Reference reference = FirebaseStorage.instance.ref();

  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'groups': [],
      'profilePic': '',
      'uid': uid,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //create personal group

  Future createPersonalGroup(
      String userName, String secondUserId, bool isPrivate) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      'groupName': '$userName - $secondUserId',
      'groupIcon': '',
      'admin': '$userName',
      'recentMessage': '',
      'recentMessageSender': '',
      'public': isPrivate,
      'users': [userName, secondUserId]
    });
  }

// creating a group

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': '${id}_$userName',
      'members': [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': '',
    });
    // update the members
    await groupDocumentReference.update({
      'members': FieldValue.arrayUnion(['${uid}_$userName']),
      'groupId': groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      'groups':
          FieldValue.arrayUnion(['${groupDocumentReference.id}_$groupName'])
    });
  }

  Future deleteGroup(String groupId, String groupName) async {
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await groupDocumentReference.get();
    List<dynamic> users = await documentSnapshot['members'];

    for (var i in users) {
      userCollection.doc(i.substring(0, i.indexOf('_'))).update({
        'groups': FieldValue.arrayRemove(['${groupId}_$groupName'])
      });
      await groupDocumentReference.delete();
    }
  }

  //get image from db

  Future <String> getUserImageFromDb() async{
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    return documentSnapshot['profilePic'];
  }

  // update path image

  Future updatePathImage(String path) async{
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      'profilePic': path
    });
  }

  //geting the chats

  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  //get group members

  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  //search
  searchByName(String groupName) {
    return groupCollection.where('groupName', isEqualTo: groupName).get();
  }

  searchByEmail(String email) {
    return userCollection.where('email', isEqualTo: email).get();
  }

  //function -> bool

  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains('${groupId}_$groupName')) {
      return true;
    } else {
      return false;
    }
  }

  //toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    //doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains('${groupId}_$groupName')) {
      await userDocumentReference.update({
        'groups': FieldValue.arrayRemove(['${groupId}_$groupName'])
      });
      await groupDocumentReference.update({
        'members': FieldValue.arrayRemove(['${uid}_$userName'])
      });
    } else {
      await userDocumentReference.update({
        'groups': FieldValue.arrayUnion(['${groupId}_$groupName'])
      });
      await groupDocumentReference.update({
        'members': FieldValue.arrayUnion(['${uid}_$userName'])
      });
    }
  }

  //send message

  sendMessages(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection('messages').add(chatMessageData);
    groupCollection.doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'],
    });
  }

  Future getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    return File(image.path);

  }

  Future getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    return File(image.path);

  }

  Future <String> uploadFileInStorage(pikedFile) async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceDirection = reference.child('files');
    Reference referenceImages = referenceDirection.child(fileName);

    final file = File(pikedFile.path);

    await referenceImages.putFile(file);

    final imageUrl = await referenceImages.getDownloadURL();

    return imageUrl ;
  }

}
