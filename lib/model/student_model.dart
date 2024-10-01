import 'package:hive/hive.dart';
part 'student_model.g.dart';

@HiveType(typeId: 0)
class StudentModel extends HiveObject {
  @HiveField(0)
  String? photo;
  @HiveField(1)
  late String? studentName;
  @HiveField(2)
  late String? age;
  @HiveField(3)
  late String? registerNumber;
  @HiveField(4)
  late String? phoneNumber;
  StudentModel(
      {this.photo,
      this.studentName,
      this.age,
      this.registerNumber,
      this.phoneNumber});
}
