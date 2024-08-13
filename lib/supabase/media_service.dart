import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bitstagram/supabase/my_supabase.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MediaService with MySupaBase {
  final ImagePicker _picker = ImagePicker();

  Future<(String, XFile)?> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1980,
        maxWidth: 1980,
      );
      if (pickedFile != null) {
        final storagePath =
            "${supaAuth.currentUser.id}/${DateTime.now().millisecondsSinceEpoch} ${pickedFile.name}";

        return (storagePath, pickedFile);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<File?> pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<String> uploadMediaPost(String storagePath, XFile file) async {
    try {
      final imageBytes = await file.readAsBytes();

      await client.storage.from('posts').uploadBinary(
            storagePath,
            imageBytes,
            retryAttempts: 1,
            fileOptions: FileOptions(
              contentType: file.mimeType,
            ),
          );

      final publicUrl = client.storage.from('posts').getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> uploadMediaAccountPicture(
      String storagePath, XFile file) async {
    try {
      final imageBytes = await file.readAsBytes();

      await client.storage.from('account').uploadBinary(
            storagePath,
            imageBytes,
            retryAttempts: 1,
            fileOptions: FileOptions(
              contentType: file.mimeType,
            ),
          );

      final publicUrl =
          client.storage.from('account').getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      return e.toString();
    }
  }
}
