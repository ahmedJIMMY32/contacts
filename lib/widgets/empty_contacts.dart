import 'package:flutter/material.dart';
import '../core/app_text_styles.dart';

class EmptyContacts extends StatelessWidget {
  const EmptyContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/empty_list.png', width: 300),
          const SizedBox(height: 8),
          const Text(
            'There is No Contacts Added Here',
            style: AppTextStyles.emptyText,
          ),
        ],
      ),
    );
  }
}