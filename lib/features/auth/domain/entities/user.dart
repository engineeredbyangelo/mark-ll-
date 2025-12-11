/// User Entity - Pure Business Logic (Domain Layer)
/// No Flutter dependencies
class User {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final List<String> selectedTags;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.selectedTags,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    List<String>? selectedTags,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      selectedTags: selectedTags ?? this.selectedTags,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
