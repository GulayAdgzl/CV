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
      context.read<ContactProvider>().loadContactInfo();
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
        child: Center(
          child: Consumer<ContactProvider>(
            builder: (context, contactProvider, child) {
              if (contactProvider.isLoading) {
                return const CircularProgressIndicator();
              }

              if (contactProvider.error != null) {
                return ErrorsWidget(
                  error: contactProvider.error!,
                  onRetry: () => contactProvider.loadContactInfo(),
                );
              }

              if (contactProvider.aboutInfo == null) {
                return const Text(
                  'No contact information available',
                  style: TextStyle(color: Colors.white),
                );
              }

              return RefreshIndicator(
                onRefresh: () => contactProvider.refreshContactInfo(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ContactCard(contactProvider: contactProvider),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
