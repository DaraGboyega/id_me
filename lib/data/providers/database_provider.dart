import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:id_me/data/models/student.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider =
    StreamProvider((ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final databaseProvider =
    Provider<DatabaseProvider>((ref) => DatabaseProvider(ref));

class DatabaseProvider {
  DatabaseProvider(this._ref) : super();

  final ProviderRef _ref;

  Future<QuerySnapshot> readItems() {
    FirebaseFirestore _firestore = _ref.watch(firestoreProvider);
    final CollectionReference _mainCollection =
        _firestore.collection("student");
    return _mainCollection.get();
  }

  writeAttendance(dynamic studentMap) async {
    FirebaseFirestore _firestore = _ref.watch(firestoreProvider);
    final CollectionReference _attendanceCollection =
        _firestore.collection("attendance");
    final attendance = await _attendanceCollection.get();
    final attendanceList = <Student>[];
    var studentObject = Student().fromMap(studentMap);
    bool duplicate = false;

    for (QueryDocumentSnapshot value in attendance.docs) {
      final docObject = Student().fromMap(value.data());
      studentObject.toLowerCase();
      docObject.toLowerCase();
      attendanceList.add(docObject);
    }

    print("student object " + studentMap.toString());

    for (Student element in attendanceList) {
      print("attendance list item " + element.toMap().toString());
      if (element.name?.toLowerCase() == studentObject.name?.toLowerCase() &&
          element.matricNumber?.toLowerCase() ==
              studentObject.matricNumber?.toLowerCase()) {
        print("duplicate found");
        duplicate = true;
      }
    }

    if (!duplicate) {
      _attendanceCollection.add(studentMap);
    }
    
  }

  Future<QuerySnapshot> readAttendance() {
    FirebaseFirestore _firestore = _ref.watch(firestoreProvider);
    final CollectionReference _mainCollection =
        _firestore.collection("attendance");
    return _mainCollection.get();
  }
}
