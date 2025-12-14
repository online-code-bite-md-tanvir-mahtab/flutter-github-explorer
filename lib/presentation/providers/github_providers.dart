import 'package:flutter_github_explorer/domain/repositories/github_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../../data/datasources/remote/github_remote_datasource.dart';
import '../../domain/repositories/github_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});

final remoteDataSourceProvider =
    Provider<GitHubRemoteDataSource>((ref) {
  return GitHubRemoteDataSource(ref.read(dioProvider));
});

final githubRepositoryProvider = Provider<GitHubRepository>((ref) {
  return GitHubRepositoryImpl(ref.read(remoteDataSourceProvider));
});
