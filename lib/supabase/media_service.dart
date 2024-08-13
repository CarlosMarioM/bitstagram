import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();
  final SupabaseClient supabase = Supabase.instance.client;

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
  }

  Future<File?> pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<String> uploadMediaPost(String storagePath, XFile file) async {
    try {
      final imageBytes = await file.readAsBytes();

      await supabase.storage.from('posts').uploadBinary(
            storagePath,
            imageBytes,
            retryAttempts: 1,
            fileOptions: FileOptions(
              contentType: file.mimeType,
            ),
          );

      final publicUrl =
          supabase.storage.from('posts').getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> uploadMediaAccountPicture(
      String storagePath, XFile file) async {
    try {
      final imageBytes = await file.readAsBytes();

      await supabase.storage.from('account').uploadBinary(
            storagePath,
            imageBytes,
            retryAttempts: 1,
            fileOptions: FileOptions(
              contentType: file.mimeType,
            ),
          );

      final publicUrl =
          supabase.storage.from('account').getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      return e.toString();
    }
  }
}
