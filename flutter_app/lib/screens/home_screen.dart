// WalkTogether — Home Screen (nearby walkers + bottom nav)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nearbyWalkersProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalkTogether'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push('/settings')),
        ],
      ),
      body: _tab == 0
          ? _nearbyTab()
          : _tab == 1
              ? _groupsTab()
              : _tab == 2
                  ? _clubsTab()
                  : _menuTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people), label: 'Nearby'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Groups'),
          NavigationDestination(icon: Icon(Icons.flag), label: 'Clubs'),
          NavigationDestination(icon: Icon(Icons.menu), label: 'More'),
        ],
      ),
    );
  }

  Widget _nearbyTab() {
    final state = ref.watch(nearbyWalkersProvider);
    return RefreshIndicator(
      onRefresh: () => ref.read(nearbyWalkersProvider.notifier).load(),
      child: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: WalkTogetherTheme.danger),
                    const SizedBox(height: 8),
                    Text(state.error!,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(nearbyWalkersProvider.notifier).load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ))
              : state.walkers.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 80),
                        Icon(Icons.people_outline,
                            size: 64, color: WalkTogetherTheme.textMuted),
                        const SizedBox(height: 16),
                        const Text('No walkers nearby yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: WalkTogetherTheme.textSecondary)),
                        const SizedBox(height: 8),
                        const Text(
                            'Be the first walker in your area!\nInvite friends or try a wider radius.',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: WalkTogetherTheme.textMuted)),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.walkers.length,
                      itemBuilder: (ctx, i) {
                        final w = state.walkers[i] as Map<String, dynamic>;
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                                child: Text((w['name'] as String? ?? '?')[0]
                                    .toUpperCase())),
                            title: Row(
                              children: [
                                Text(w['name'] ?? 'Unknown',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                if (w['verificationStatus'] == 'verified') ...[
                                  const SizedBox(width: 4),
                                  const VerifiedBadge(size: 14),
                                ],
                              ],
                            ),
                            subtitle: Text(
                                '${w['distance'] ?? '?'}m away • Trust: ${w['trustScore'] ?? 50}',
                                style: const TextStyle(fontSize: 11)),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/walker/${w['id']}'),
                          ),
                        );
                      },
                    ),
    );
  }

  Widget _groupsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.groups,
              size: 64, color: WalkTogetherTheme.textMuted),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.push('/groups'),
            icon: const Icon(Icons.groups),
            label: const Text('Browse group walks'),
          ),
        ],
      ),
    );
  }

  Widget _clubsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flag, size: 64, color: WalkTogetherTheme.textMuted),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.push('/clubs'),
            icon: const Icon(Icons.flag),
            label: const Text('Browse walking clubs'),
          ),
        ],
      ),
    );
  }

  Widget _menuTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
            child: ListTile(
          leading: const Icon(Icons.request_page),
          title: const Text('Walk requests', style: TextStyle(fontSize: 14)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/requests'),
        )),
        Card(
            child: ListTile(
          leading: const Icon(Icons.feedback),
          title: const Text('Give feedback', style: TextStyle(fontSize: 14)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/feedback'),
        )),
        Card(
            child: ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy requests', style: TextStyle(fontSize: 14)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/privacy-requests'),
        )),
        Card(
            child: ListTile(
          leading: const Icon(Icons.gavel),
          title: const Text('My appeals', style: TextStyle(fontSize: 14)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/appeals'),
        )),
        Card(
            child: ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings', style: TextStyle(fontSize: 14)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/settings'),
        )),
      ],
    );
  }
}
