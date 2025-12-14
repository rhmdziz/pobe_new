class UserProfile {
  const UserProfile({
    this.id,
    required this.username,
    this.email,
    this.fullName,
    this.avatarUrl,
    this.phone,
  });

  final int? id;
  final String username;
  final String? email;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;

  String get displayName {
    if (fullName != null && fullName!.isNotEmpty) return fullName!;
    if (username.isNotEmpty) return username;
    return email?.isNotEmpty == true ? email! : 'User';
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final firstName = json['first_name'] as String? ?? '';
    final lastName = json['last_name'] as String? ?? '';
    final fullNameCandidate =
        '$firstName $lastName'.trim().isNotEmpty ? '$firstName $lastName'.trim() : (json['name'] as String? ?? '');

    return UserProfile(
      id: json['id'] as int?,
      username: (json['username'] as String?) ?? '',
      email: json['email'] as String?,
      fullName: fullNameCandidate,
      avatarUrl: json['avatar'] as String? ?? json['image'] as String?,
      phone: json['phone'] as String?,
    );
  }
}
