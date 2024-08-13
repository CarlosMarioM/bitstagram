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
  late final TextEditingController _nicknameController;
  String? _photoUrl, _storagePath;
  XFile? _selectedMedia;
  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
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
              const Spacer(),
              SizedBox(
                width: 400,
                height: 60,
                child: OutlinedButton(
                  onPressed: () async {
                    if (_selectedMedia != null &&
                        _storagePath != null &&
                        _nicknameController.text.isNotEmpty) {
                      if (user != null) {
                        final response = await userProvider.updateUserInfo(
                          storagePath: _storagePath!,
                          nickname: _nicknameController.text,
                          file: _selectedMedia!,
                        );
                        if (response == null) {
                          setState(() {
                            _nicknameController.text = "";
                            _photoUrl = null;
                            _selectedMedia = null;
                          });
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => Navigator.of(context)
                                .pushReplacementNamed(BottomBarPage.route),
                          );
                        } else {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(response),
                              ),
                            ),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Need to put all the data")));
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
