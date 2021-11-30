import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:id_me/data/models/student.dart';
import 'package:id_me/ui/view_models/attendance_view_model.dart';

class AttendanceScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(attendanceViewModel);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Attendance List"),
      ),
      body: FutureBuilder<List<Student>>(
          future: viewModel.getAttendance(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  Student attendanceItem = snapshot.data![index];
                  if (snapshot.data != null) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(attendanceItem.name!, style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text(attendanceItem.matricNumber!.toUpperCase()),
                      ),
                    );
                  }
                  return Center(
                    child: Text("No Attendance"),
                  );
                });
          }),
    );
  }
}
