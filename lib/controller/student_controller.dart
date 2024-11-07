import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:studentdatabase_getx/model/student_model.dart';
import 'package:studentdatabase_getx/screens/home_screen.dart';

class StudentController extends GetxController {
  RxList<StudentModel> studentRxList = <StudentModel>[].obs;
  final RxList<StudentModel> filteredStudentList = <StudentModel>[].obs;
  late Box<StudentModel> studentBox;
  @override
  void onInit() {
    super.onInit();
    openBox();
  }

  Future<void> openBox() async {
    studentBox = await Hive.openBox<StudentModel>('student_db');
    loadStudents();
  }

  List<StudentModel> get studentList => studentRxList.toList();
  Future<void> loadStudents() async {
    final List<StudentModel> studentsFromBox =
        studentBox.values.toList().cast<StudentModel>();
    studentRxList.assignAll(studentsFromBox);
    studentBox.watch().listen((event) {
      final updatedStudents = studentBox.values.toList().cast<StudentModel>();
      studentRxList.assignAll(updatedStudents);
    });
  }

  Future<void> addStudentDetails(StudentModel student) async {
    print("add");
    try {
      final existingStudent = studentRxList.firstWhereOrNull(
        (s) => s.registerNumber == student.registerNumber,
      );

      if (existingStudent != null) {
        Get.snackbar(
          "Error",
          "Student with this register number already exists",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.black,
        );
        return;
      }

      await studentBox.add(student);
      //studentRxList.add(student);

      Get.snackbar(
        "Success",
        "Student data successfully added",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.black,
      );
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add Student Data: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.black,
      );
    }
  }

  Future<void> updateStudent(StudentModel student, String name, String age,
      String regno, String phoneNo, String photo) async {
    final index =
        studentRxList.indexWhere((element) => element.key == student.key);

    studentRxList[index].studentName = name;
    studentRxList[index].age = age;
    studentRxList[index].registerNumber = regno;
    studentRxList[index].phoneNumber = phoneNo;
    studentRxList[index].photo = photo;

    await studentBox.put(studentRxList[index].key, studentRxList[index]);

    studentRxList.refresh();
  }

  Future<void> deleteStudent(StudentModel student) async {
    await studentBox.delete(student.key);
    studentRxList.remove(student);
  }

  void searchStudent(String query) {
    if (query.isEmpty) {
      filteredStudentList.clear();
    } else {
      List<StudentModel> result = studentRxList.where((student) {
        return student.studentName!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            student.registerNumber!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filteredStudentList.assignAll(result);
    }
  }
}
