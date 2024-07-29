import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/user_controller.dart';
import 'package:rell_trader/view/widget/custom_auth_text_field.dart';

class ProfileUpdateBottomSheet extends StatefulWidget {
  const ProfileUpdateBottomSheet({
    super.key,
  });

  @override
  State<ProfileUpdateBottomSheet> createState() =>
      _ProfileUpdateBottomSheetState();
}

class _ProfileUpdateBottomSheetState extends State<ProfileUpdateBottomSheet> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  UserController userController = Get.put(UserController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    firstNameController.text = userController.currentUser.firstName;
    lastNameController.text = userController.currentUser.lastName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(12).copyWith(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Update Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                CustomAuthTextField(
                  textController: firstNameController,
                  hintText: 'First Name',
                  label: 'First Name',
                  prefixIcon: const Icon(Icons.person),
                  validater: (value) {
                    if (value != null && value.length >= 2) {
                      return null;
                    }
                    return 'Input valid details';
                  },
                  textInputType: TextInputType.name,
                ),
                const SizedBox(height: 10),
                CustomAuthTextField(
                  textController: lastNameController,
                  hintText: 'Last Name',
                  label: 'Last Name',
                  prefixIcon: const Icon(Icons.person),
                  validater: (value) {
                    if (value != null && value.length >= 2) {
                      return null;
                    }
                    return 'Input valid details';
                  },
                  textInputType: TextInputType.name,
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      bool response = await Get.showOverlay(
                        asyncFunction: () async =>
                            await userController.updateUserDetails(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                        ),
                        loadingWidget: const Center(
                          child: SpinKitWave(
                            color: Colors.purple,
                            size: 42,
                          ),
                        ),
                      );
                      if (response) {
                        Get.back();
                      } else {
                        Get.snackbar(
                          'Error',
                          'Error Updating User details',
                          margin: const EdgeInsets.all(20),
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                          isDismissible: true,
                        );
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 60,
                  color: Colors.green,
                  textColor: Colors.white,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
