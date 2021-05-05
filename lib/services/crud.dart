import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addData(blogData) async {
    FirebaseFirestore.instance.collection("blog").add(blogData).catchError((e) {
      print(e);
    });
  }
}
