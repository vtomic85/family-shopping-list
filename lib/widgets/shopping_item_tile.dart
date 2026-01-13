import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/shopping_item.dart';
import '../providers/shopping_list_provider.dart';
import '../theme/app_theme.dart';
import 'edit_item_dialog.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;

  const ShoppingItemTile({
    super.key,
    required this.item,
  });

  Color get _statusColor {
    return switch (item.status) {
      ItemStatus.pending => AppTheme.pendingColor,
      ItemStatus.bought => AppTheme.boughtColor,
      ItemStatus.notAvailable => AppTheme.notAvailableColor,
    };
  }

  IconData get _statusIcon {
    return switch (item.status) {
      ItemStatus.pending => Icons.access_time_rounded,
      ItemStatus.bought => Icons.check_circle_rounded,
      ItemStatus.notAvailable => Icons.cancel_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _showEditDialog(context),
            backgroundColor: Colors.blue.shade400,
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
            label: 'Edit',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          SlidableAction(
            onPressed: (_) => _confirmDelete(context),
            backgroundColor: AppTheme.notAvailableColor,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _cycleStatus(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _statusColor.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _statusColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Status indicator
                  _buildStatusIndicator(context),
                  const SizedBox(width: 16),
                  
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.description,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: item.status == ItemStatus.bought
                                ? TextDecoration.lineThrough
                                : null,
                            color: item.status == ItemStatus.bought
                                ? Theme.of(context).textTheme.bodyMedium?.color
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // Amount badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.numbers_rounded,
                                    size: 12,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item.amount}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Status chip
                            _buildStatusChip(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Swipe hint icon
                  Icon(
                    Icons.chevron_left_rounded,
                    color: Theme.of(context).dividerColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _statusColor.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _statusIcon,
        color: _statusColor,
        size: 24,
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        item.status.displayName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _statusColor,
        ),
      ),
    );
  }

  void _cycleStatus(BuildContext context) {
    context.read<ShoppingListProvider>().cycleItemStatus(item.id);
  }

  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditItemDialog(item: item),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ShoppingListProvider>().deleteItem(item.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted "${item.description}"'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.notAvailableColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
