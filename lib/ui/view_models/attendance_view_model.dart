import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:id_me/data/models/student.dart';
import 'package:id_me/data/providers/database_provider.dart';
import 'package:id_me/ui/view_models/base_view_model.dart';

final attendanceViewModel =
    ChangeNotifierProvider((ref) => AttendanceViewModel(ref));

class AttendanceViewModel extends BaseViewModel {
  final ProviderRefBase _ref;

  AttendanceViewModel(this._ref);

  Future<List<Student>> getAttendance() async {
    final attendanceList = <Student>[];
    final attendanceDatabase =
        await _ref.read(databaseProvider).readAttendance();
    attendanceDatabase.docs.forEach((element) {
      attendanceList.add(Student().fromMap(element.data()));
    });
    return attendanceList;
  }
}
