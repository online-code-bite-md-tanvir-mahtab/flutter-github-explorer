import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_github_explorer/presentation/details/details_screen.dart';
import '../providers/repository_list_provider.dart';
import '../../core/utils/sort_type.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reposAsync = ref.watch(repositoryListProvider);
    final sortType = ref.watch(sortTypeProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light grey background for contrast
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(repositoryListProvider);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(ref, sortType),
            reposAsync.when(
              data: (repos) {
                if (repos.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No repositories found')),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final repo = repos[index];
                        return _RepositoryCard(repo: repo);
                      },
                      childCount: repos.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Offline & no cached data available'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(WidgetRef ref, SortType currentSort) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: const Text(
          'Discover',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ActionChip(
            avatar: Icon(
              currentSort == SortType.stars ? Icons.star : Icons.update,
              size: 16,
              color: Colors.white,
            ),
            label: Text(
              currentSort == SortType.stars ? 'Most Stars' : 'Latest',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            backgroundColor: Colors.black87,
            side: BorderSide.none,
            shape: const StadiumBorder(),
            onPressed: () {
              final notifier = ref.read(sortTypeProvider.notifier);
              final next = notifier.state == SortType.stars
                  ? SortType.updated
                  : SortType.stars;
              notifier.state = next;
              ref.read(sortPreferenceProvider).saveSortType(next);
            },
          ),
        )
      ],
    );
  }
}

class _RepositoryCard extends StatelessWidget {
  final dynamic repo; // Replace 'dynamic' with your actual RepositoryModel type

  const _RepositoryCard({required this.repo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (_) => DetailsScreen(repo: repo)),
             );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildAvatar(repo.ownerName),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            repo.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            repo.ownerName,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoBadge(
                      Icons.star_rounded,
                      '${repo.stars}',
                      Colors.amber[700]!,
                      Colors.amber[50]!,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoBadge(
                      Icons.calendar_today_rounded,
                      DateFormat('MMM d, yyyy').format(repo.updatedAt),
                      Colors.blueGrey[600]!,
                      Colors.blueGrey[50]!,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String ownerName) {
    // If you have an image URL in your model, use NetworkImage here.
    // Otherwise, this generates a nice colored circle with initials.
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.deepPurple[50],
      child: Text(
        ownerName.isNotEmpty ? ownerName[0].toUpperCase() : '?',
        style: TextStyle(
          color: Colors.deepPurple[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}