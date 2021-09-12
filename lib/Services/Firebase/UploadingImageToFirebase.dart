
import 'package:flutter/material.dart';

abstract class UploadingImageToFirebase {

  Future<String> uploadingImage(BuildContext context , {required String imagePath });

}