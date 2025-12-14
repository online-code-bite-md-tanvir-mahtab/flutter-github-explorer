import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/repository_list_provider.dart';
import '../../core/utils/sort_type.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reposAsync = ref.watch(repositoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter GitHub Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              final current = ref.read(sortTypeProvider);
              ref.read(sortTypeProvider.notifier).state =
                  current == SortType.stars
                      ? SortType.updated
                      : SortType.stars;
            },
          )
        ],
      ),
      body: reposAsync.when(
        data: (repos) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(repositoryListProvider);
          },
          child: ListView.builder(
            itemCount: repos.length,
            itemBuilder: (_, index) {
              final repo = repos[index];
              return ListTile(
                title: Text(repo.name),
                subtitle: Text(repo.ownerName),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('⭐ ${repo.stars}'),
                    Text(
                      DateFormat('MM-dd-yyyy HH:mm')
                          .format(repo.updatedAt),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(
          child: Text('Offline & no cached data available'),
        ),
      ),
    );
  }
}
