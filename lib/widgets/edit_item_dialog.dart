import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shopping_item.dart';
import '../providers/shopping_list_provider.dart';
import '../theme/app_theme.dart';

class EditItemDialog extends StatefulWidget {
  final ShoppingItem item;

  const EditItemDialog({
    super.key,
    required this.item,
  });

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _notesController;
  late ItemStatus _selectedStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController = TextEditingController(text: widget.item.quantity);
    _notesController = TextEditingController(text: widget.item.notes);
    _selectedStatus = widget.item.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      margin: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    'Edit Item',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  
                  // Name field
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an item name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Quantity field
                  TextFormField(
                    controller: _quantityController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      prefixIcon: Icon(Icons.numbers_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a quantity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Notes field
                  TextFormField(
                    controller: _notesController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      prefixIcon: Icon(Icons.note_outlined),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Status selector
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  _buildStatusSelector(),
                  const SizedBox(height: 24),
                  
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Row(
      children: ItemStatus.values.map((status) {
        final isSelected = status == _selectedStatus;
        final color = switch (status) {
          ItemStatus.pending => AppTheme.pendingColor,
          ItemStatus.bought => AppTheme.boughtColor,
          ItemStatus.notAvailable => AppTheme.notAvailableColor,
        };
        final icon = switch (status) {
          ItemStatus.pending => Icons.access_time_rounded,
          ItemStatus.bought => Icons.check_circle_rounded,
          ItemStatus.notAvailable => Icons.cancel_rounded,
        };

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: status != ItemStatus.notAvailable ? 8 : 0,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _selectedStatus = status),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? color : Theme.of(context).dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? color : Theme.of(context).dividerColor,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        status.displayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? color : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final shoppingProvider = context.read<ShoppingListProvider>();

    final success = await shoppingProvider.updateItem(
      itemId: widget.item.id,
      name: _nameController.text.trim(),
      quantity: _quantityController.text.trim(),
      notes: _notesController.text.trim(),
      status: _selectedStatus,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Item updated successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(shoppingProvider.error ?? 'Failed to update item'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
