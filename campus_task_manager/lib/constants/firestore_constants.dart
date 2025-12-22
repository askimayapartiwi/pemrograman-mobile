class FirestoreConstants {
  // Collection Names
  static const String usersCollection = 'users';
  static const String tasksCollection = 'tasks';
  
  // User Fields
  static const String userId = 'uid';
  static const String userEmail = 'email';
  static const String userName = 'name';
  static const String userCreatedAt = 'createdAt';
  static const String userUpdatedAt = 'updatedAt';
  
  // Task Fields
  static const String taskId = 'id';
  static const String taskTitle = 'title';
  static const String taskDescription = 'description';
  static const String taskDeadline = 'deadline';
  static const String taskIsCompleted = 'isCompleted';
  static const String taskCreatedAt = 'createdAt';
  static const String taskUserId = 'userId';
  
  // Query Limits
  static const int tasksPerPage = 20;
}