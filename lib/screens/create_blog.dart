import 'dart:io';

import 'package:blogapp/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  CrudMethods crudMethods = new CrudMethods();

  String authorName, title, desc;

  File selectImage;

  Future getImage() async {
    var pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (selectImage == null) {
        selectImage = File(pickedImage.path);
      }
    });
  }

  uploadBlog() async {
    if (selectImage != null) {
      Reference storageref = FirebaseStorage.instance
          .ref()
          .child('blogImages')
          .child("{$randomAlphaNumeric(9)}.jpg");

      final UploadTask task = storageref.putFile(selectImage);

      var downloadurl = await (await task).ref.getDownloadURL();

      print("This is the url = $downloadurl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Flutter",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Blog",
              style: TextStyle(fontSize: 20, color: Colors.blue),
            )
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 17),
              child: Icon(Icons.file_upload),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            selectImage == null
                ? Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.black45.withOpacity(.3),
                      ),
                    ))
                : Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      child: Image.file(
                        selectImage,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Author Name',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Title',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
