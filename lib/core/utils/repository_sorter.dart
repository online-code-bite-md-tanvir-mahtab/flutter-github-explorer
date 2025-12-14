import '../../domain/entities/repository_entity.dart';
import 'sort_type.dart';

List<RepositoryEntity> sortRepositories(
  List<RepositoryEntity> repos,
  SortType sortType,
) {
  final sorted = List<RepositoryEntity>.from(repos);

  switch (sortType) {
    case SortType.stars:
      sorted.sort((a, b) => b.stars.compareTo(a.stars));
      break;
    case SortType.updated:
      sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      break;
  }

  return sorted;
}
