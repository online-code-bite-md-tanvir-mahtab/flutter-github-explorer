import 'package:flutter_github_explorer/presentation/providers/github_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/repository_entity.dart';
import '../../domain/repositories/github_repository.dart';
import '../../core/utils/sort_type.dart';
import '../../core/utils/sort_preference.dart';

final sortPreferenceProvider = Provider((ref) => SortPreference());

final sortTypeProvider =
    StateProvider<SortType>((ref) => SortType.stars);

final repositoryListProvider =
    FutureProvider<List<RepositoryEntity>>((ref) async {
  final repo = ref.read(githubRepositoryProvider);
  final sortType = ref.watch(sortTypeProvider);

  final list = await repo.getFlutterRepositories();

  final sorted = [...list];
  if (sortType == SortType.stars) {
    sorted.sort((a, b) => b.stars.compareTo(a.stars));
  } else {
    sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  return sorted;
});
