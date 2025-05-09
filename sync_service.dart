import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> uploadPlanToFirebase(Map<String, dynamic> weeklyPlan) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userId = user.uid;

  try {
    await FirebaseFirestore.instance
        .collection('weeklyPlans')
        .doc(userId)
        .set(weeklyPlan); // بيحط الخطة كلها دفعة واحدة
    print("Plan uploaded successfully");
  } catch (e) {
    print("Error uploading plan: $e");
  }
}
