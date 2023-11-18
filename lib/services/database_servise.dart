import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;

  DataBaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

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

// creating a group

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': '${id}_${userName}',
      'members' : [],
      'groupId' : '',
      'recentMessage' : '',
      'recentMessageSender' : '',
    });
    // update the members
    await groupDocumentReference.update({
      'members' : FieldValue.arrayUnion(['${uid}_${userName}']),
      'groupId' : groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      'groups' :
      FieldValue.arrayUnion(['${groupDocumentReference.id}_$groupName'])
    });
  }

  //geting the chats

  getChats(String groupId) async{
    return groupCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }
  Future getGroupAdmin(String groupId) async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }
  //get group members
  getGroupMembers(groupId) async{
    return groupCollection.doc(groupId).snapshots();
  }

  //search
 searchByName(String groupName) {
    return groupCollection.where('groupName',isEqualTo: groupName).get();
 }

 //function -> bool

 Future<bool> isUserJoined(String groupName, String groupId, String userName) async{
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups =  await documentSnapshot['groups'];
    if(groups.contains('${groupId}_$groupName')) {
      return true;
    }
    else {
     return false;
    }
 }

}
