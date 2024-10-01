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

class AddStudentsData extends StatelessWidget {
  AddStudentsData({super.key});

  final formKey = GlobalKey<FormState>();
  final StudentController studentControllerss = Get.put(StudentController());
  final PickedImageController pickimgController =
      Get.put(PickedImageController());
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final registerNoController = TextEditingController();
  final contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: const Text(
          "Add Student Details",
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
                              pickimgController.selectedImage.value != null
                                  ? FileImage(pickimgController
                                      .selectedImage.value!) as ImageProvider
                                  : null,
                          radius: 60,
                          child: pickimgController.selectedImage.value == null
                              ? IconButton(
                                  onPressed: () {
                                    pickImage(pickimgController);
                                  },
                                  icon: const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Color.fromARGB(255, 82, 81, 81),
                                  ),
                                )
                              : null,
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
                              color: Colors.white,
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
                      onPressed: saveDetails,
                      child: const Text(
                        "SAVE",
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

  void saveDetails() async {
    if (formKey.currentState!.validate()) {
      StudentModel student = StudentModel(
        studentName: nameController.text.trim(),
        age: ageController.text.trim(),
        registerNumber: registerNoController.text.trim(),
        phoneNumber: contactController.text.trim(),
        photo: pickimgController.selectedImage.value?.path ?? '',
      );

      await studentControllerss.addStudentDetails(student);
    }
  }

  void pickImage(PickedImageController controller) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        controller.selectedImage.value = File(pickedImage.path);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class PickedImageController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);
}
