import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/user_controller.dart';
import 'package:rell_trader/view/widget/custom_auth_text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserController userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12).copyWith(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 80,
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        userController.currentUser.firstName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 46,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Get.bottomSheet(
                          const ProfileUpdateBottomSheet(),
                        );
                      },
                      color: Colors.white,
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ProfileSegmentWidget(
                segmentLabel: 'Basic Details',
                children: [
                  ProfileRowWidget(
                    label: 'First Name',
                    details: userController.currentUser.firstName,
                  ),
                  const SizedBox(height: 10),
                  ProfileRowWidget(
                    label: 'Last Name',
                    details: userController.currentUser.lastName,
                  ),
                  const SizedBox(height: 10),
                  ProfileRowWidget(
                    label: 'Email',
                    details: userController.currentUser.email,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ProfileSegmentWidget(
                segmentLabel: 'Meta Details',
                children: [
                  ProfileRowWidget(
                    label: 'Account',
                    details:
                        userController.currentUser.accountNumber.toString(),
                  ),
                  const SizedBox(height: 10),
                  ProfileRowWidget(
                    label: 'Server',
                    details: userController.currentUser.metaServer ?? '',
                  ),
                  const SizedBox(height: 10),
                  ProfileRowWidget(
                    label: 'Trade Automation',
                    details: userController.currentUser.automationActive == true
                        ? 'Active'
                        : 'Inactive',
                  ),
                  const SizedBox(height: 10),
                  ProfileRowWidget(
                    label: 'Status',
                    details: userController.currentUser.verified == true
                        ? 'Verified'
                        : 'Unverified',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

class ProfileSegmentWidget extends StatelessWidget {
  const ProfileSegmentWidget({
    super.key,
    required this.segmentLabel,
    required this.children,
  });

  final String segmentLabel;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            segmentLabel,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...children
        ],
      ),
    );
  }
}

class ProfileRowWidget extends StatelessWidget {
  const ProfileRowWidget({
    super.key,
    required this.label,
    required this.details,
  });

  final String label;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              details,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
