import '../../domain/entities/repository_entity.dart';

class RepositoryModel extends RepositoryEntity {
  RepositoryModel({
    required super.name,
    required super.description,
    required super.stars,
    required super.updatedAt,
    required super.ownerName,
    required super.ownerAvatar,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    return RepositoryModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      stars: json['stargazers_count'] ?? 0,
      updatedAt: DateTime.parse(json['updated_at']),
      ownerName: json['owner']['login'] ?? '',
      ownerAvatar: json['owner']['avatar_url'] ?? '',
    );
  }
}
