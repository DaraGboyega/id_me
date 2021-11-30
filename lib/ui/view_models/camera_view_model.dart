import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:id_me/ui/view_models/base_view_model.dart';

final cameraViewModel = ChangeNotifierProvider((ref) => CameraViewModel());

class CameraViewModel extends BaseViewModel {
  Future<String?> takePicture(CameraController controller) async {
    if (!controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    String? imagePath;

    if (controller.value.isTakingPicture) {
      print("Processing is in progress...");
      return null;
    }

    try {
      controller.setFlashMode(FlashMode.always);

      final XFile file = await controller.takePicture();

      imagePath = file.path;
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }
}
