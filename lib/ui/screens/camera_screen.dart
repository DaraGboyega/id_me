import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:id_me/main.dart';
import 'package:id_me/ui/view_models/camera_view_model.dart';
import 'package:id_me/ui/view_models/details_view_model.dart';

class CameraScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CameraController useCameraController(CameraDescription description,
        ResolutionPreset resolutionPreset, ImageFormatGroup imageFormatGroup) {
      final controller = useMemoized(() => CameraController(
          description, resolutionPreset,
          imageFormatGroup: imageFormatGroup));

      useEffect(() {
        return controller.dispose;
      }, [controller]);

      return controller;
    }

    CameraController? _controller;

    final viewModel = ref.watch(cameraViewModel);
    Future<void>? _initializeControllerFuture;

    Future<void> _initializeCamera() async {
      final CameraController cameraController = useCameraController(
          cameras[0], ResolutionPreset.medium, ImageFormatGroup.jpeg);
      _controller = cameraController;

      _initializeControllerFuture = cameraController.initialize();
    }

    useEffect(() {
      _initializeCamera();
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: <Widget>[
                    Center(child: CameraPreview(_controller!)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.camera),
                        label: Text("Scan"),
                        onPressed: () async {
                          print("scan callback");
                          var path = await viewModel.takePicture(_controller!);
                          Navigator.of(context)
                              .pushNamed("details_screen", arguments: path!);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.list),
                        label: Text("Attendance List"),
                        onPressed: () {
                          Navigator.of(context).pushNamed("attendance_screen");
                        },
                      ),
                    )
                  ],
                );
              } else {
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
      ),
    );
  }
}
