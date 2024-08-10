import 'package:supabase_flutter/supabase_flutter.dart';

const url = "https://vvluomzaqtdnhbawmlxs.supabase.co",
    anonKey =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ2bHVvbXphcXRkbmhiYXdtbHhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjMxNjg4NjMsImV4cCI6MjAzODc0NDg2M30.ivakXvx2Qk4ctqIpoD9lSHkWq0RMHEBl3LOenskIFA4";

mixin class MySupaBase {
  MySupaBase();

  Supabase get instance => _instance;

  final Supabase _instance = Supabase.instance;

  SupabaseClient get client => _client;

  late final SupabaseClient _client = _instance.client;
}
