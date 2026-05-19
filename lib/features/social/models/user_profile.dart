class UserProfile {
  const UserProfile({required this.userId, required this.username});

  final String userId;
  final String username;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json['id'] as String,
        username: json['username'] as String,
      );

  @override
  bool operator ==(Object other) =>
      other is UserProfile && other.userId == userId;

  @override
  int get hashCode => userId.hashCode;
}
