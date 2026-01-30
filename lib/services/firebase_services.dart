import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:news_app/model/artical_model.dart';

class FirebaseServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<UserCredential> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> login(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  String _safeId(String value) {
    return value.replaceAll('/', '_');
  }

  Future<void> addFavoriteNews(ArticalModel article) async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    if (article.url == null || article.url!.isEmpty) {
      throw Exception('Article URL is null or empty');
    }

    final docId = _safeId(article.url!);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(docId)
        .set({
          'title': article.title,
          'image': article.image,
          'subtitle': article.subtitle,
          'url': article.url,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  Future<void> removeFavoriteNews(String articleUrl) async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final docId = _safeId(articleUrl);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(docId)
        .delete();
  }

  Future<bool> isFavorite(String articleUrl) async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) return false;

    final docId = _safeId(articleUrl);

    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(docId)
        .get();

    return doc.exists;
  }

  Future<List<ArticalModel>> getFavoriteNews() async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return ArticalModel(
        title: doc['title'] ?? '',
        image: doc['image'] ?? '',
        subtitle: doc['subtitle'] ?? '',
        url: doc['url'] ?? '',
      );
    }).toList();
  }

  Stream<List<ArticalModel>> getFavoriteNewsStream() {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ArticalModel(
              title: doc['title'] ?? '',
              image: doc['image'] ?? '',
              subtitle: doc['subtitle'] ?? '',
              url: doc['url'] ?? '',
            );
          }).toList();
        });
  }

  Future<String> uploadProfileImage(File imageFile) async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');
    final ref = _firebaseStorage
        .ref()
        .child('profiles')
        .child(userId)
        .child('profile.jpg');

    await ref.putFile(imageFile);

    final downloadUrl = await ref.getDownloadURL();

    await _firestore.collection('users').doc(userId).set({
      'profileImageUrl': downloadUrl,
    }, SetOptions(merge: true));

    return downloadUrl;
  }

  Future<String?> getProfileImageUrl() async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) return null;

    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['profileImageUrl'] as String?;
  }

  Future<void> deleteProfileImage() async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final ref = _firebaseStorage
        .ref()
        .child('profiles')
        .child(userId)
        .child('profile.jpg');

    await ref.delete();

    await _firestore.collection('users').doc(userId).set({
      'profileImageUrl': FieldValue.delete(),
    }, SetOptions(merge: true));
  }
}
