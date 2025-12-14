class RepositoryEntity {
  final String name;
  final String description;
  final int stars;
  final DateTime updatedAt;
  final String ownerName;
  final String ownerAvatar;

  RepositoryEntity({
    required this.name,
    required this.description,
    required this.stars,
    required this.updatedAt,
    required this.ownerName,
    required this.ownerAvatar,
  });
}
