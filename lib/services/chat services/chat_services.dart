// ignore_for_file: unused_field

import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ChatServices extends ChangeNotifier {
// instance of firestore
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// get user stream
//It returns a Stream of a List containing Map<String, dynamic> objects.
//Each Map represents a user document in the Users collection.
  Stream<List<Map<String, dynamic>>> getUserStrem() {
    // firestoreRef.collection("Users"): Accesses the Users collection in Firestore
    return firestoreRef.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((docs) {
        // go through each individual users
        //docs.data(): Retrieves the data stored in each document as a Map<String, dynamic>.
        //This is where the actual user information is accessed.
        final user = docs.data();

        // return users
        return user;
      }).toList();
    });
  }

  // get all user except the block users

  Stream<List<Map<String, dynamic>>> getAllUsersExcludingBlockUsers() {
    final currentUser = _auth.currentUser;

    return firestoreRef
        .collection('Users')
        .doc(currentUser!.uid)
        .collection("BlockUsers")
        .snapshots()
        .asyncMap((snapshot) async {
      // get block users ids
      final blockUsersId = snapshot.docs.map((docs) => docs.id).toList();

      // get all users

      final usersSnapshot = await firestoreRef.collection('Users').get();

      // return as stream list

      return usersSnapshot.docs
          .where((docs) =>
              docs.data()["email"] != currentUser.email &&
              !blockUsersId.contains(docs.id))
          .map((docs) => docs.data())
          .toList();
    });
  }

// sent message

  Future<void> sentMessage(String reciverId, message) async {
    // current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message

    MessageModels messageModels = MessageModels(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        reciverId: reciverId,
        message: message,
        timestamp: timestamp);

    // constract chat room id for two users (sorted to ensure uniquness)
    List<String> ids = [currentUserId, reciverId];

    ids.sort();
    String chatRoomID = ids.join('_');

    // add new message to database

    await firestoreRef
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection('messages')
        .add(messageModels.toMap());
  }

  // get message

  Stream<QuerySnapshot> getMessage(String userId, otherUserId) {
    // constract a chatroom for 2 users
    List<String> ids = [userId, otherUserId];
    ids.sort();

    String chatRoomId = ids.join('_');

    return firestoreRef
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// Report user
  Future<void> reportUser(String messageId, userId) async {
    final currentUser = _auth.currentUser!.uid;
    final report = {
      'reportedBy': currentUser,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp()
    };

    await firestoreRef.collection('Reports').add(report);
  }

  // Block user

  Future<void> blockUsers(String userId) async {
    final currentUser = _auth.currentUser;
    await firestoreRef
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockUsers')
        .doc(userId)
        .set({});
    notifyListeners();
  }

  // unblock user

  Future<void> unblockUser(String blockUserId) async {
    final currentUser = _auth.currentUser;

    await firestoreRef
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockUsers')
        .doc(blockUserId)
        .delete();
  }

  // get block user stream

  Stream<List<Map<String, dynamic>>> getBloctUserStream(String userId) {
    return firestoreRef
        .collection('Users')
        .doc(userId)
        .collection('BlockUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      // get list of block user Id
      final blockUserIds = snapshot.docs.map((docs) => docs.id).toList();

      final userDocs = await Future.wait(blockUserIds
          .map((id) => firestoreRef.collection("Users").doc(id).get()));

      // return as list
      return userDocs
          .map((docs) => docs.data() as Map<String, dynamic>)
          .toList();
    });
  }
}
