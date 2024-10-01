import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:studentdatabase_getx/controller/student_controller.dart';
import 'package:studentdatabase_getx/model/student_model.dart';
import 'package:studentdatabase_getx/widgets/styles.dart';
import 'package:studentdatabase_getx/widgets/textfields.dart';

class EditStudentDetails extends StatelessWidget {
  final StudentModel student;
  final formKey = GlobalKey<FormState>();
  final StudentController studentController = Get.put(StudentController());
  final PickedImageEditController pickimgController =
      Get.put(PickedImageEditController());

  EditStudentDetails({super.key, required this.student}) {
    // Initialize the controllers with existing student data
    nameController.text = student.studentName ?? '';
    ageController.text = student.age ?? '';
    registerNoController.text = student.registerNumber ?? '';
    contactController.text = student.phoneNumber ?? '';
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController registerNoController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundtheme,
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: const Text(
          "Edit Student Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Obx(() => Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              pickimgController.selectedimage.value != null
                                  ? FileImage(
                                      pickimgController.selectedimage.value!)
                                  : (student.photo != null &&
                                          student.photo!.isNotEmpty
                                      ? FileImage(File(student.photo!))
                                      : null) as ImageProvider?,
                          radius: 60,
                          backgroundColor:
                              pickimgController.selectedimage.value == null &&
                                      (student.photo == null ||
                                          student.photo!.isEmpty)
                                  ? Colors.grey[300]
                                  : Colors.transparent,
                        ),
                        Positioned(
                          bottom: -5,
                          right: -4,
                          child: IconButton(
                            onPressed: () {
                              pickImage(pickimgController);
                            },
                            icon: const Icon(
                              Icons.add_a_photo_outlined,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 15),
                TextFormFields(
                  controller: nameController,
                  hintText: "Enter Your name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Name can only contain letters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormFields(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2)
                  ],
                  keyboardType: TextInputType.number,
                  controller: ageController,
                  hintText: "Enter Your age",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Age is required';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 1 || age > 99) {
                      return 'Age must be between 1 and 99';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormFields(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6)
                  ],
                  keyboardType: TextInputType.number,
                  controller: registerNoController,
                  hintText: "Enter Your Register Number",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Register Number is required';
                    } else if (value.length != 6) {
                      return 'Register Number must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormFields(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                  keyboardType: TextInputType.phone,
                  controller: contactController,
                  hintText: "Enter Your Contact Number",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Contact number is required';
                    } else if (value.length != 10) {
                      return 'Contact number must be 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: appbarColor),
                      onPressed: () => saveStudent(
                          student,
                          nameController.text.trim(),
                          ageController.text.trim(),
                          registerNoController.text.trim(),
                          contactController.text.trim(),
                          pickimgController.selectedimage.value?.path ??
                              student.photo!),
                      child: const Text(
                        "SUBMIT",
                        style: TextStyle(color: textcolor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  saveStudent(StudentModel key, String name, String age, String regno,
      String phone, String photo) async {
    await studentController.updateStudent(key, name, age, regno, phone, photo);
    Get.back();
    Get.snackbar('Updated', 'student details have been updated successfully',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
  }

  void pickImage(PickedImageEditController controller) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        controller.selectedimage.value = File(pickedImage.path);
      }
    } catch (e) {
      log(5 as String);
    }
  }
}

class PickedImageEditController extends GetxController {
  Rx<File?> selectedimage = Rx<File?>(null);
}
