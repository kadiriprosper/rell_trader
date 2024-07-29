import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/user_controller.dart';
import 'package:rell_trader/view/widget/profile_row_widget.dart';
import 'package:rell_trader/view/widget/profile_segment_widget.dart';
import 'package:rell_trader/view/widget/profile_update_bottom_sheet.dart';

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
              const SizedBox(height: 30),
              MaterialButton(
                onPressed: () async {
                  await userController.userLogout();
                },
                minWidth: MediaQuery.of(context).size.width,
                height: 60,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.red,
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



