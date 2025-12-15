class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;
  final int totalTasksCreated;
  final int totalTasksCompleted;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
    this.totalTasksCreated = 0,
    this.totalTasksCompleted = 0,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
    int? totalTasksCreated,
    int? totalTasksCompleted,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      totalTasksCreated: totalTasksCreated ?? this.totalTasksCreated,
      totalTasksCompleted: totalTasksCompleted ?? this.totalTasksCompleted,
    );
  }
}
