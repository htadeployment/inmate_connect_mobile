import 'package:flutter/material.dart';
import '../models/prisoner.dart';

class PrisonerCard extends StatelessWidget {
  final Prisoner prisoner;
  final VoidCallback? onTap;
  final List<String>? fieldsToShow; // e.g. ['name','cnic','fatherName','prisonNo']

  const PrisonerCard({super.key, required this.prisoner, this.onTap, this.fieldsToShow});

  Widget _buildField(String key) {
    switch (key) {
      case 'name':
        return Text(prisoner.name, style: const TextStyle(fontWeight: FontWeight.w600));
      case 'fatherName':
        return Text('Father: ${prisoner.fatherName}');
      case 'cnic':
        return Text('CNIC: ${prisoner.cnic}');
      case 'prisonNo':
        return Text('Prison No: ${prisoner.prisonNo}');
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = fieldsToShow != null && fieldsToShow!.isNotEmpty
        ? fieldsToShow!
        : ['name', 'fatherName', 'cnic', 'prisonNo'];

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: fields.map((f) => _buildField(f)).toList(),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
