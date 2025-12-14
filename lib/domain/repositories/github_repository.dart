import '../entities/repository_entity.dart';

abstract class GitHubRepository {
  Future<List<RepositoryEntity>> getFlutterRepositories();
  Future<List<RepositoryEntity>> searchRepositories(String query);
}
