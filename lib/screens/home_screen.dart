import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../core/app_colors.dart';
import '../models/contact_model.dart';
import '../widgets/add_contact_sheet.dart';
import '../widgets/app_logo.dart';
import '../widgets/contact_card.dart';
import '../widgets/empty_contacts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ContactModel> contacts = [];
  final ScrollController scrollController = ScrollController();
  bool showAddButton = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final direction = scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.reverse && showAddButton) {
        setState(() {
          showAddButton = false;
        });
      } else if (direction == ScrollDirection.forward && !showAddButton) {
        setState(() {
          showAddButton = true;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> openAddSheet() async {
    final ContactModel? newContact = await showModalBottomSheet<ContactModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.navy,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => const AddContactSheet(),
    );

    if (newContact != null) {
      setState(() {
        contacts.add(newContact);
      });
    }
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  void deleteAll() {
    setState(() {
      contacts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showAdd = showAddButton || contacts.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: AppLogo(),
            ),
            Expanded(
              child: contacts.isEmpty
                  ? const EmptyContacts()
                  : GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 150),
                itemCount: contacts.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (context, index) {
                  return ContactCard(
                    contact: contacts[index],
                    onDelete: () {
                      deleteContact(index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (contacts.isNotEmpty)
            FloatingActionButton(
              heroTag: null,
              onPressed: deleteAll,
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
          if (contacts.isNotEmpty && showAdd) const SizedBox(height: 12),
          if (showAdd)
            FloatingActionButton(
              heroTag: null,
              onPressed: openAddSheet,
              backgroundColor: AppColors.cream,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.add, color: AppColors.navy, size: 32),
            ),
        ],
      ),
    );
  }
}