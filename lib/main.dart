import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://sqyrbajzqoykkqkywvsy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNxeXJiYWp6cW95a2txa3l3dnN5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg3MTkzOTksImV4cCI6MjA5NDI5NTM5OX0.Hl0KruyVA-iwToJLBkIWfgt9kU81KHtkMcbZCel6QRQ',
  );
  runApp(
    const ProviderScope(
      child: KitLockerApp(),
    ),
  );
}
