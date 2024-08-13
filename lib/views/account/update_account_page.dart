import 'package:bitstagram/provider/user_provider.dart';
import 'package:bitstagram/supabase/media_service.dart';
import 'package:bitstagram/views/bottom_bar/bottom_bar_page.dart';
import 'package:bitstagram/widgets/appbart.dart';
import 'package:bitstagram/widgets/bit_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateAccountPage extends StatefulWidget {
  const UpdateAccountPage({super.key});

  @override
  State<UpdateAccountPage> createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  late final TextEditingController _nicknameController, _phoneController;
  String? _photoUrl, _storagePath;
  XFile? _selectedMedia;
  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: normalAppbar,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              BitCircleAvatar(
                image: _photoUrl,
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 26),
              ElevatedButton(
                onPressed: () async {
                  final (String, XFile)? response =
                      await userProvider.pickAccountImage();
                  if (response != null) {
                    setState(() {
                      _photoUrl = response.$2.path;
                      _storagePath = response.$1;
                      _selectedMedia = response.$2;
                    });
                  }

                  // final photoUrl =
                  //     await MediaService.pickImage(); // Handle photo selection
                },
                child: const Text('Change Photo'),
              ),
              const Spacer(),
              SizedBox(
                width: 450,
                child: TextField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(labelText: 'Nickname'),
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: 450,
                child: TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 400,
                child: OutlinedButton(
                  onPressed: () async {
                    if (user != null) {
                      await userProvider
                          .updateUserInfo(
                            storagePath: _storagePath!,
                            nickname: _nicknameController.text,
                            phone: _phoneController.text,
                            file: _selectedMedia!,
                          )
                          .then((value) => Navigator.of(context)
                              .pushReplacementNamed(BottomBarPage.route));
                    }
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
