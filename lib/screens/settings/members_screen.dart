import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/family_group_provider.dart';
import '../../theme/app_theme.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isAddingMember = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Members'),
      ),
      body: Consumer<FamilyGroupProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final group = provider.familyGroup;
          if (group == null) {
            return const Center(
              child: Text('No family group found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header info
                _buildHeaderCard(context, provider),
                const SizedBox(height: 24),
                
                // Add member section (only for owner)
                if (provider.isOwner) ...[
                  _buildAddMemberSection(context, provider),
                  const SizedBox(height: 24),
                ],
                
                // Members list
                _buildMembersList(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, FamilyGroupProvider provider) {
    final group = provider.familyGroup!;
    final memberCount = group.allMemberEmails.length;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.family_restroom_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Family Group',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$memberCount member${memberCount == 1 ? '' : 's'}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          if (!provider.isOwner) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Member',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddMemberSection(BuildContext context, FamilyGroupProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_add_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Invite Family Member',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Add a family member by their email address. They\'ll be able to access your shopping list after logging in with their Google account.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            
            // Error message
            if (provider.error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppTheme.notAvailableColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppTheme.notAvailableColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.error!,
                        style: const TextStyle(
                          color: AppTheme.notAvailableColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: provider.clearError,
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: AppTheme.notAvailableColor,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter email address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!_isValidEmail(value.trim())) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isAddingMember ? null : () => _addMember(provider),
                    child: _isAddingMember
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Add'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList(BuildContext context, FamilyGroupProvider provider) {
    final group = provider.familyGroup!;
    final authProvider = context.read<AuthProvider>();
    final currentUserEmail = authProvider.userEmail?.toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Members',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Owner
        _buildMemberTile(
          context,
          email: group.ownerEmail,
          isOwner: true,
          isCurrentUser: group.ownerEmail.toLowerCase() == currentUserEmail,
          canRemove: false,
          provider: provider,
        ),
        
        // Members
        ...group.memberEmails.map((email) => _buildMemberTile(
          context,
          email: email,
          isOwner: false,
          isCurrentUser: email.toLowerCase() == currentUserEmail,
          canRemove: provider.isOwner,
          provider: provider,
        )),
        
        // Empty state
        if (group.memberEmails.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.group_add_outlined,
                  size: 48,
                  color: Theme.of(context).dividerColor,
                ),
                const SizedBox(height: 12),
                Text(
                  'No additional members yet',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                if (provider.isOwner) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Add family members above to share your shopping list',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMemberTile(
    BuildContext context, {
    required String email,
    required bool isOwner,
    required bool isCurrentUser,
    required bool canRemove,
    required FamilyGroupProvider provider,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
              : Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: isOwner
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          child: Icon(
            isOwner ? Icons.admin_panel_settings_rounded : Icons.person_rounded,
            color: isOwner
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                email,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isCurrentUser ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isCurrentUser) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'You',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          isOwner ? 'Owner' : 'Member',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: canRemove && !isOwner
            ? IconButton(
                onPressed: () => _confirmRemoveMember(context, email, provider),
                icon: const Icon(
                  Icons.remove_circle_outline_rounded,
                  color: AppTheme.notAvailableColor,
                ),
                tooltip: 'Remove member',
              )
            : null,
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _addMember(FamilyGroupProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isAddingMember = true);

    final success = await provider.addMember(_emailController.text.trim());

    if (!mounted) return;

    setState(() => _isAddingMember = false);

    if (success) {
      _emailController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Member added successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _confirmRemoveMember(
    BuildContext context,
    String email,
    FamilyGroupProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove $email from your family group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await provider.removeMember(email);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed $email'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.notAvailableColor,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
