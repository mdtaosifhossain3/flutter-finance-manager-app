import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_manager_app/services/uid_service.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitFeedback(String feedback) async {
    try {
      final uid = UidService.instance.uid;
      if (uid == null) {
        throw Exception('User must be logged in to submit feedback');
      }

      await _firestore.collection('feedback').add({
        'feedback': feedback,
        'uid': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }
}
