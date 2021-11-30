import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:id_me/data/enums/app_enums.dart';
import 'package:id_me/ui/view_models/details_view_model.dart';

class DetailScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(detailsViewModel);
    final args = ModalRoute.of(context)!.settings.arguments as String;

    useEffect(() {
      model.imagePath = args;
      model.detectDetails();
    }, []);

    return Scaffold(
        backgroundColor: Colors.black,
        body: model.imageSize != null && model.isLoading == false
            ? Stack(
                children: [
                  Center(
                    child: Container(
                      width: double.maxFinite,
                      color: Colors.black,
                      child: AspectRatio(
                        aspectRatio: model.imageSize!.aspectRatio,
                        child: Image.file(File(model.imagePath!)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                      elevation: 8,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: model.verification ==
                                        Verification.unverified
                                    ? Row(
                                        children: [
                                          Text(
                                            "Unrecognized Credentials",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.close_outlined,
                                            color: Colors.red,
                                          )
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Text(
                                            "Credentials Verified",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        ],
                                      )),
                            model.verification == Verification.unverified
                                ? SizedBox()
                                : Container(
                                    height: 60,
                                    child: Column(
                                      children: [
                                        Text("Name: ${model.match?.name}"),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            "Matric Number: ${model.match?.matricNumber}")
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Container(
                color: Colors.black,
                child: Center(child: CircularProgressIndicator()),
              ));
  }
}
