import 'package:firebase_database/firebase_database.dart';

class FirebaseController {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  DatabaseReference get portfolio => _db.child("Portfolio");
  DatabaseReference get skills => _db.child("Portfolio/Skills");
  DatabaseReference get experience => _db.child("Portfolio/Experience");
  // Diğer alanları da burada ekleyebilirsin
}
