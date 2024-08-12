import 'package:bitstagram/supabase/media_service.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../provider/post_provider.dart';

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final TextEditingController contentController = TextEditingController();
  XFile? _selectedMedia;
  String? _mediaType;
  Image? _memoryImage;
  String _storagePath = "";
  final MediaService _mediaService = MediaService();

  Future<void> _pickImage() async {
    final (String, XFile)? response = await _mediaService.pickImage();
    if (response != null) {
      setState(() {
        _memoryImage = kIsWeb
            ? Image.network(response.$2.path)
            : Image.asset(response.$2.path);
        _selectedMedia = response.$2;
        _mediaType = 'image';
        _storagePath = response.$1;
      });
    }
  }

  Future<void> _pickVideo() async {
    final file = await _mediaService.pickVideo();
    if (file != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Flexible(
          child: _selectedMedia != null
              ? _mediaType == 'image'
                  ? SizedBox(
                      height: 200,
                      width: 300,
                      child: _memoryImage ?? const Text("Not loaded"))
                  : const Text("Not suported")
              : const Text('No media selected'),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: contentController,
          decoration: const InputDecoration(labelText: 'What\'s on your mind?'),
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: _pickVideo,
              child: const Text('Pick Video'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (_selectedMedia != null) {
              await postProvider
                  .createPost(
                _storagePath,
                _selectedMedia!,
                contentController.text,
              )
                  .then((_) {
                setState(() {
                  _memoryImage = null;
                  _selectedMedia = null;
                  _mediaType = null;
                  _storagePath = "";
                  contentController.text = "";
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Center(child: Text('Photo uploaded!'))),
                );
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please select an image or video')),
              );
            }
          },
          child: const Text('Post'),
        ),
      ],
    );
  }
}
