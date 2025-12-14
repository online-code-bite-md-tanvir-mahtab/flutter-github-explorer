import 'package:flutter_github_explorer/data/datasources/local/github_local_datasource.dart';
import 'package:flutter_github_explorer/data/datasources/remote/github_remote_datasource.dart';
import 'package:flutter_github_explorer/data/models/repository_model.dart';
import 'package:flutter_github_explorer/domain/entities/repository_entity.dart';
import 'package:flutter_github_explorer/domain/repositories/github_repository.dart';

class GitHubRepositoryImpl implements GitHubRepository {
  final GitHubRemoteDataSource remoteDataSource;
  final GitHubLocalDataSource localDataSource;

  GitHubRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource, [
    GitHubLocalDataSource? read,
  ]);

  @override
  Future<List<RepositoryEntity>> getFlutterRepositories() async {
    final result = await remoteDataSource.fetchFlutterRepositories();
    return result
        .map<RepositoryEntity>((json) => RepositoryModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<RepositoryEntity>> searchRepositories(String query) async {
    // 1️⃣ Always try local first
    final localResult = localDataSource.searchLocal(query);

    try {
      // 2️⃣ Try remote search
      final remoteResult = await remoteDataSource.searchRepositories(query);

      final repos = remoteResult
          .map<RepositoryModel>((json) => RepositoryModel.fromJson(json))
          .toList();

      // 3️⃣ Cache fresh results
      await localDataSource.cacheRepositories(repos);

      return repos;
    } catch (_) {
      // 4️⃣ Offline fallback
      if (localResult.isNotEmpty) return localResult;
      rethrow;
    }
  }
}
