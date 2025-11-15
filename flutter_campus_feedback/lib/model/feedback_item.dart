class FeedbackItem {
  final String name;
  final String nim;
  final String faculty;
  final List<String> facilities;
  final double satisfaction;
  final String feedbackType;
  final bool isAgreed;
  final String additionalMessage;

  FeedbackItem({
    required this.name,
    required this.nim,
    required this.faculty,
    required this.facilities,
    required this.satisfaction,
    required this.feedbackType,
    required this.isAgreed,
    required this.additionalMessage,
  });
}

// 🔹 List global untuk menyimpan semua feedback
List<FeedbackItem> globalFeedbackList = [];
