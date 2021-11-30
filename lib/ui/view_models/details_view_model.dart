import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:id_me/data/enums/app_enums.dart';
import 'package:id_me/data/models/student.dart';
import 'package:id_me/data/providers/database_provider.dart';
import 'package:id_me/ui/view_models/base_view_model.dart';

final detailsViewModel = ChangeNotifierProvider((ref) => DetailsViewModel(ref));

class DetailsViewModel extends BaseViewModel {
  String? imagePath;
  TextDetector _textDetector = GoogleMlKit.vision.textDetector();
  Size? imageSize;
  List<TextElement> _elements = [];
  Verification? verification;
  Student? match;
  final ProviderRefBase _ref;

  DetailsViewModel(this._ref);

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();
    final Image image = Image.file(imageFile);

    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((image, synchronousCall) {
      completer.complete(
          Size(image.image.width.toDouble(), image.image.height.toDouble()));
    }));

    final Size _imageSize = await completer.future;

    imageSize = _imageSize;
    notifyListeners();
  }

  void detectDetails() async {
    toLoading();

    try {
      _getImageSize(File(imagePath!));

      final inputImage = InputImage.fromFilePath(imagePath!);
      final text = await _textDetector.processImage(inputImage);

      List<Student> studentList = [];

      final database = _ref.watch(databaseProvider);
      final databaseRead = await database.readItems();

      databaseRead.docs.forEach((student) {
        studentList.add(Student().fromMap(student.data()));
      });

      if (text.text == "") {
        print("empty image");
        verification = Verification.unverified;
        notifyListeners();
        toIdle();
        return;
      }

      for (TextBlock block in text.blocks) {
        for (TextLine line in block.lines) {
          for (Student student in studentList) {
            if (line.text.toLowerCase() == student.name?.toLowerCase()) {
              match = student;
              print("match found");
              verification = Verification.verified;
              notifyListeners();
            } else {
              print("no match");
              verification = Verification.unverified;
              notifyListeners();
            }
          }
        }
      }

      if (match != null) {
        for (TextBlock block in text.blocks) {
          for (TextLine line in block.lines) {
            print(line.text);
            print(match?.matricNumber);
            print(match?.name);
            if (line.text.toLowerCase() == match?.matricNumber?.toLowerCase()) {
              print("name & matric number match found");
              database.writeAttendance(match?.toMap());
              verification = Verification.verified;
              notifyListeners();
            } else {
              verification = Verification.unverified;
              notifyListeners();
              toIdle();
            }
          }
        }
      }
    } catch (e) {
      print(e);
      verification = Verification.unverified;
      notifyListeners();
      toIdle();
    }

    toIdle();
  }

  void face_recognition() async {
    
  }
}
