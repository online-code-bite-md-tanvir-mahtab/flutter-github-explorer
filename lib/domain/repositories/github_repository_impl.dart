import 'package:flutter_github_explorer/data/datasources/local/github_local_datasource.dart';
import 'package:flutter_github_explorer/data/datasources/remote/github_remote_datasource.dart';
import 'package:flutter_github_explorer/data/models/repository_model.dart';
import 'package:flutter_github_explorer/domain/entities/repository_entity.dart';
import 'package:flutter_github_explorer/domain/repositories/github_repository.dart';

class GitHubRepositoryImpl implements GitHubRepository {
  final GitHubRemoteDataSource remoteDataSource;

  GitHubRepositoryImpl(this.remoteDataSource, [GitHubLocalDataSource read]);

  @override
  Future<List<RepositoryEntity>> getFlutterRepositories() async {
    final result = await remoteDataSource.fetchFlutterRepositories();
    return result
        .map<RepositoryEntity>((json) => RepositoryModel.fromJson(json))
        .toList();
  }
}
