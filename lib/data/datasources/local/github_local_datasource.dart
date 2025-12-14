import 'package:flutter_github_explorer/data/models/repository_model.dart';
import 'package:hive/hive.dart';

class GitHubLocalDataSource {
  final Box _box = Hive.box('repositoriesBox');

  Future<void> cacheRepositories(List<RepositoryModel> repos) async {
    final List<Map<String, dynamic>> jsonList =
        repos.map((repo) => {
              'name': repo.name,
              'description': repo.description,
              'stars': repo.stars,
              'updatedAt': repo.updatedAt.toIso8601String(),
              'ownerName': repo.ownerName,
              'ownerAvatar': repo.ownerAvatar,
            }).toList();
    await _box.put('flutter_repos', jsonList);
  }

  List<RepositoryModel> getCachedRepositories() {
    final List<dynamic>? jsonList = _box.get('flutter_repos');
    if (jsonList == null) return [];
    return jsonList
        .map<RepositoryModel>((json) => RepositoryModel(
              name: json['name'],
              description: json['description'],
              stars: json['stars'],
              updatedAt: DateTime.parse(json['updatedAt']),
              ownerName: json['ownerName'],
              ownerAvatar: json['ownerAvatar'],
            ))
        .toList();
  }
}
