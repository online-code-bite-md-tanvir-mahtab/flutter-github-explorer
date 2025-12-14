import 'package:flutter_github_explorer/core/utils/repository_sorter.dart';
import 'package:flutter_github_explorer/presentation/providers/repository_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/repository_entity.dart';
import 'github_providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultProvider = FutureProvider<List<RepositoryEntity>>((
  ref,
) async {
  final query = ref.watch(searchQueryProvider);
  final sortType = ref.watch(sortTypeProvider); // 👈 IMPORTANT

  final repository = ref.read(githubRepositoryProvider);

  final repos = query.isEmpty
      ? await repository.getFlutterRepositories()
      : await repository.searchRepositories(query);

  return sortRepositories(repos, sortType);
});
