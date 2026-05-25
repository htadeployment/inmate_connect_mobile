import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/custom_text_field.dart';
import '../components/media_capture_tile.dart';
import '../components/primary_button.dart';
import '../models/prisoner.dart';
import '../utils/validators.dart';


//visit_request_screen
class VisitRequestScreen extends StatefulWidget {
  final Prisoner prisoner;
  final String relationship;
  const VisitRequestScreen({super.key, required this.prisoner, required this.relationship});

  @override
  State<VisitRequestScreen> createState() => _VisitRequestScreenState();
}

class _VisitRequestScreenState extends State<VisitRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  final List<String> _timeSlots = const [
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
  ];

  final List<String> _relationships = const [
    'Self',
    'Spouse',
    'Child',
    'Parent',
    'Sibling',
    'Friend',
    'Other',
  ];

  // Visitor forms: supports multiple visitors
  final List<_VisitorForm> _visitors = [];

  @override
  void initState() {
    super.initState();
    final initialRelationship = _relationships.contains(widget.relationship) ? widget.relationship : _relationships.first;
    _visitors.add(_VisitorForm(relationship: initialRelationship));
  }

  @override
  void dispose() {
    for (final v in _visitors) {
      v.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _pickMedia(void Function(Uint8List) onBytes) async {
    final xFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (xFile == null) return;
    final bytes = await xFile.readAsBytes();
    onBytes(bytes);
    setState(() {});
  }

  void _addVisitor() {
    setState(() => _visitors.add(_VisitorForm(relationship: _relationships.first)));
  }

  void _removeVisitor(int index) {
    if (_visitors.length <= 1) return;
    setState(() {
      _visitors[index].dispose();
      _visitors.removeAt(index);
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a visit date')));
      return;
    }
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a time slot')));
      return;
    }

    // Validate visitors
    for (int i = 0; i < _visitors.length; i++) {
      final v = _visitors[i];
      if (v.cnicController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Visitor ${i + 1}: CNIC is required')));
        return;
      }
      if (v.fatherNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Visitor ${i + 1}: Father name is required')));
        return;
      }
      if (v.addressController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Visitor ${i + 1}: Address is required')));
        return;
      }
    }

    // For demo, show summary
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Prisoner: ${widget.prisoner.name}'),
              Text('Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
              Text('Time: $_selectedTimeSlot'),
              const SizedBox(height: 12),
              const Text('Visitors:'),
              const SizedBox(height: 8),
              ..._visitors.asMap().entries.map((e) {
                final i = e.key;
                final v = e.value;
                return Text('${i + 1}. ${v.cnicController.text} — ${v.fatherNameController.text}');
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitorCapture(int idx) {
    final v = _visitors[idx];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Identity Photos', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isWide = width > 700;
            final children = [
              MediaCaptureTile(
                title: 'CNIC Front',
                subtitle: 'Capture CNIC front side',
                imageBytes: v.cnicFront,
                onTap: () => _pickMedia((b) => v.cnicFront = b),
              ),
              MediaCaptureTile(
                title: 'CNIC Back',
                subtitle: 'Capture CNIC back side',
                imageBytes: v.cnicBack,
                onTap: () => _pickMedia((b) => v.cnicBack = b),
              ),
              MediaCaptureTile(
                title: 'Front Face Photo',
                subtitle: 'Capture a clear front face photo',
                imageBytes: v.facePhoto,
                onTap: () => _pickMedia((b) => v.facePhoto = b),
              ),
            ];

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: children
                  .map((tile) => SizedBox(width: isWide ? (width / 2) - 18 : width, child: tile))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Visit')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Prisoner', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.prisoner.name, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 4),
                      //  Text('ID: ${widget.prisoner.id ?? ''}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return SizedBox(
                      width: width,
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Visit Date'),
                          child: Text(
                            _selectedDate == null ? 'Select a date' : _selectedDate!.toLocal().toString().split(' ')[0],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                Text('Available Time Slots', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _timeSlots
                      .map(
                        (slot) => ChoiceChip(
                          label: Text(slot),
                          selected: _selectedTimeSlot == slot,
                          onSelected: (_) => setState(() => _selectedTimeSlot = slot),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 24),
                // Visitors list
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Visitors', style: Theme.of(context).textTheme.titleMedium),
                    TextButton.icon(onPressed: _addVisitor, icon: const Icon(Icons.add), label: const Text('Add Visitor')),
                  ],
                ),
                const SizedBox(height: 12),
                ..._visitors.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final v = entry.value;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Visitor ${idx + 1}', style: Theme.of(context).textTheme.titleSmall),
                              Row(children: [
                                if (_visitors.length > 1)
                                  IconButton(onPressed: () => _removeVisitor(idx), icon: const Icon(Icons.delete_outline)),
                              ]),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(controller: v.cnicController, label: 'Visitor CNIC', keyboardType: TextInputType.number, validator: Validators.validateCNIC),
                          const SizedBox(height: 8),
                          CustomTextField(controller: v.fatherNameController, label: 'Father Name', validator: (s) => (s == null || s.trim().isEmpty) ? 'Required' : null),
                          const SizedBox(height: 8),
                          CustomTextField(controller: v.phoneController, label: 'Phone (optional)', keyboardType: TextInputType.phone),
                          const SizedBox(height: 8),
                          CustomTextField(controller: v.addressController, label: 'Address', validator: (s) => (s == null || s.trim().isEmpty) ? 'Required' : null),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _relationships.contains(v.relationship) ? v.relationship : _relationships.first,
                            items: _relationships.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                            onChanged: (val) => setState(() => v.relationship = val ?? _relationships.first),
                            decoration: const InputDecoration(labelText: 'Relationship'),
                          ),
                          const SizedBox(height: 12),
                          _buildVisitorCapture(idx),
                          const SizedBox(height: 12),
                          CheckboxListTile(
                            title: const Text('Bringing items with visitor?'),
                            value: v.bringingItems,
                            onChanged: (val) => setState(() => v.bringingItems = val ?? false),
                          ),
                          if (v.bringingItems) ...[
                            const SizedBox(height: 8),
                            CustomTextField(controller: v.itemsController, label: 'Item details (describe items)'),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 24),
                PrimaryButton(text: 'Submit Request', onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Simple helper that groups controllers and captured bytes for a visitor
class _VisitorForm {
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController itemsController = TextEditingController();

  Uint8List? cnicFront;
  Uint8List? cnicBack;
  Uint8List? facePhoto;

  bool bringingItems = false;
  String? relationship;

  _VisitorForm({this.relationship});

  void dispose() {
    cnicController.dispose();
    fatherNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    itemsController.dispose();
  }
}
