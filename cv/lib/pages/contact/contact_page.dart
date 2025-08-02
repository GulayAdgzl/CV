import 'package:cv/core/theme/gradient_theme_extension.dart';
import 'package:cv/pages/contact/contactCard/contact_card.dart';
import 'package:cv/pages/contact/contact_provider.dart';
import 'package:cv/pages/contact/widgets/error_widgets.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
    // Load contact data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ContactProvider>().loadContactInfo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gradient =
        Theme.of(context).extension<GradientTheme>()?.backgroundGradient;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Consumer<ContactProvider>(
          builder: (context, contactProvider, child) {
            return _buildBody(context, contactProvider);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ContactProvider contactProvider) {
    // Loading state
    if (contactProvider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Loading contact information...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Error state
    if (contactProvider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ErrorsWidget(
            error: contactProvider.error!,
            onRetry: () => contactProvider.loadContactInfo(),
          ),
        ),
      );
    }

    // No data state
    if (contactProvider.contactInfo == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_off_outlined,
              size: 64,
              color: Colors.white54,
            ),
            const SizedBox(height: 16),
            const Text(
              'No contact information available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection and try again',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => contactProvider.loadContactInfo(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Success state - Show contact information
    return RefreshIndicator(
      onRefresh: () => contactProvider.refreshContactInfo(),
      color: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.8),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // Contact Card
            ContactCard(
              contactInfo: contactProvider.contactInfo!,
              onUpdate: (updatedContact) async {
                final success =
                    await contactProvider.updateContactInfo(updatedContact);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact information updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (!success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Failed to update: ${contactProvider.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),

            // Extra padding for bottom navigation
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, ContactProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Contact'),
        content: const Text(
            'Contact editing functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement edit functionality
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}
