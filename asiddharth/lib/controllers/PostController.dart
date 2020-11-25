import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:image_downloader/image_downloader.dart';

class PostController {
  FirebaseStorage _storage = FirebaseStorage.instance;
  final _db = FirebaseFirestore.instance;


  final picker = ImagePicker();
  File _image;
  String path;
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
      path = pickedFile.path;
      _image = File(path);
    return _image;
  }

  Future<Map<String, dynamic>> pushpost(id, description,status) async {
    var _uploadedFileURL;
    Map<String, dynamic> answer = new Map();
    if(_image!=null) {
      Reference storageReference = _storage.ref().child('posts/${Path.basename(_image.path)}');
      UploadTask uploadTask = storageReference.putFile(_image);
      var dowurl = await (await uploadTask).ref.getDownloadURL();
      _uploadedFileURL = dowurl.toString();

      await _db.collection('posts').add({
        "userid": id,
        'imagepath': _uploadedFileURL,
        'description': description,
        'status':status
      }).then((value) {
        answer['status'] = true;
        answer['message'] = 'post published';
      }).catchError((error) {
        answer['status'] = false;
        answer['message'] = error.message.toString();
      });
    }
    else{
      answer['status'] = false;
      answer['message'] ="image should not be empty";
    }
    return answer;
  }

 getallposts(){
   final data= _db.collection('posts').snapshots();
    return data;
  }

  Future<DocumentSnapshot> getpost(id)async{
    final post= await _db.collection('posts').doc(id).get();
    return post;
  }
    downloadpostimage(iamgepath) async{
      Map<String, dynamic> answer = new Map();
      try {
        // Saved with this method.
        var imageId = await ImageDownloader.downloadImage(iamgepath);
        if (imageId == null) {
          return;
        }
        var path = await ImageDownloader.findPath(imageId);
        answer['status'] = true;
        answer['message'] = path.toString();
      } on PlatformException catch (error) {
        answer['status'] = false;
        answer['message'] = error.message.toString();
      }
      return answer;
  }
    deletpost(id,pathimage)async{
      Map<String, dynamic> answer = new Map();

    await _db.collection('posts').doc(id).delete().then((value) async{
      final image=_storage.refFromURL(pathimage);
          await image.delete();
      answer['status'] = true;
      answer['message'] = 'post deleted successfully';
    }).catchError((error){
      answer['status'] = false;
      answer['message'] = error.message.toString();
    });
    return answer;
  }
}
