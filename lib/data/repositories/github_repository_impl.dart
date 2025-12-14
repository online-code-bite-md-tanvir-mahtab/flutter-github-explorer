import '../../domain/entities/repository_entity.dart';
import '../../domain/repositories/github_repository.dart';
import '../datasources/remote/github_remote_datasource.dart';
import '../datasources/local/github_local_datasource.dart';
import '../models/repository_model.dart';

class GitHubRepositoryImpl implements GitHubRepository {
  final GitHubRemoteDataSource remoteDataSource;
  final GitHubLocalDataSource localDataSource;

  GitHubRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<RepositoryEntity>> getFlutterRepositories() async {
    try {
      final remoteResult = await remoteDataSource.fetchFlutterRepositories();
      final repos = remoteResult
          .map<RepositoryModel>((json) => RepositoryModel.fromJson(json))
          .toList();
      await localDataSource.cacheRepositories(repos);
      return repos;
    } catch (_) {
      // fallback to local cache
      final cached = localDataSource.getCachedRepositories();
      if (cached.isNotEmpty) return cached;
      rethrow; // if no cache, propagate error
    }
  }
}
