import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/shopping_item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/family_group_provider.dart';
import '../../providers/shopping_list_provider.dart';
import '../../widgets/shopping_item_tile.dart';
import '../../widgets/add_item_dialog.dart';
import '../../widgets/loading_skeleton.dart';
import '../settings/members_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFAB(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Consumer<FamilyGroupProvider>(
        builder: (context, provider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Shopping List'),
              if (provider.familyGroup != null)
                Text(
                  '${provider.familyGroup!.allMemberEmails.length} member${provider.familyGroup!.allMemberEmails.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                  ),
                ),
            ],
          );
        },
      ),
      actions: [
        // Members button
        Consumer<FamilyGroupProvider>(
          builder: (context, provider, _) {
            return IconButton(
              onPressed: () => _navigateToMembers(context),
              icon: Stack(
                children: [
                  const Icon(Icons.group_rounded),
                  if (provider.familyGroup != null && 
                      provider.familyGroup!.memberEmails.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${provider.familyGroup!.memberEmails.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              tooltip: 'Family Members',
            );
          },
        ),
        // User menu
        PopupMenuButton<String>(
          icon: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.photoUrl != null) {
                return CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(authProvider.photoUrl!),
                  onBackgroundImageError: (_, __) {},
                  child: authProvider.photoUrl == null
                      ? Icon(
                          Icons.person_rounded,
                          size: 20,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : null,
                );
              }
              return const Icon(Icons.account_circle_rounded);
            },
          ),
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: authProvider.photoUrl != null
                          ? NetworkImage(authProvider.photoUrl!)
                          : null,
                      child: authProvider.photoUrl == null
                          ? const Icon(Icons.person_rounded)
                          : null,
                    ),
                    title: Text(
                      authProvider.displayName ?? 'User',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      authProvider.userEmail ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'signout',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.logout_rounded),
                title: Text('Sign Out'),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer2<ShoppingListProvider, FamilyGroupProvider>(
      builder: (context, shoppingProvider, familyProvider, _) {
        if (familyProvider.isLoading || shoppingProvider.isLoading) {
          return const SingleChildScrollView(
            child: LoadingSkeleton(),
          );
        }

        if (shoppingProvider.error != null) {
          return _buildErrorState(context, shoppingProvider.error!);
        }

        if (shoppingProvider.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildItemList(context, shoppingProvider);
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your shopping list is empty',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first item',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList(BuildContext context, ShoppingListProvider provider) {
    final pendingItems = provider.pendingItems;
    final boughtItems = provider.boughtItems;
    final notAvailableItems = provider.notAvailableItems;

    return RefreshIndicator(
      onRefresh: () async {
        // The stream already handles real-time updates,
        // but we can show a brief feedback to the user
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('List refreshed'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(milliseconds: 1500),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: CustomScrollView(
        slivers: [
          // Statistics header
          SliverToBoxAdapter(
            child: _buildStatsHeader(context, provider),
          ),
          
          // Pending items
          if (pendingItems.isNotEmpty) ...[
            _buildSectionHeader(context, 'To Buy', pendingItems.length, ItemStatus.pending),
            _buildItemsSliver(context, pendingItems),
          ],
          
          // Bought items
          if (boughtItems.isNotEmpty) ...[
            _buildSectionHeader(context, 'Bought', boughtItems.length, ItemStatus.bought),
            _buildItemsSliver(context, boughtItems),
          ],
          
          // Not available items
          if (notAvailableItems.isNotEmpty) ...[
            _buildSectionHeader(context, 'Not Available', notAvailableItems.length, ItemStatus.notAvailable),
            _buildItemsSliver(context, notAvailableItems),
          ],
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(BuildContext context, ShoppingListProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            label: 'Total',
            count: provider.totalItems,
            color: Theme.of(context).colorScheme.primary,
          ),
          _buildStatDivider(context),
          _buildStatItem(
            context,
            label: 'Pending',
            count: provider.pendingCount,
            color: const Color(0xFFE8A54B),
          ),
          _buildStatDivider(context),
          _buildStatItem(
            context,
            label: 'Bought',
            count: provider.boughtCount,
            color: const Color(0xFF5BA37C),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, {
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildStatDivider(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Theme.of(context).dividerColor.withOpacity(0.2),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count, ItemStatus status) {
    final color = switch (status) {
      ItemStatus.pending => const Color(0xFFE8A54B),
      ItemStatus.bought => const Color(0xFF5BA37C),
      ItemStatus.notAvailable => const Color(0xFFD4645C),
    };

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSliver(BuildContext context, List<ShoppingItem> items) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ShoppingItemTile(item: items[index]),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddItemDialog(context),
      icon: const Icon(Icons.add_rounded),
      label: const Text('Add Item'),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddItemDialog(),
    );
  }

  void _navigateToMembers(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MembersScreen(),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'signout':
        _confirmSignOut(context);
        break;
    }
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthProvider>().signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
