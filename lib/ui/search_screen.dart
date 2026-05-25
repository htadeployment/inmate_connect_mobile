import 'package:flutter/material.dart';
import '../components/custom_text_field.dart';
import '../components/prisoner_card.dart';
import '../api/mock_service.dart';
import '../models/prisoner.dart';
import 'visit_request_screen.dart';

//search_screen

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _name = TextEditingController();
  final _cnic = TextEditingController();
  final _father = TextEditingController();
  final _prisonNo = TextEditingController();
  List<Prisoner> _results = [];
  bool _loading = false;

  void _doSearch() async {
    setState(() => _loading = true);
    final res = await MockService.search(name: _name.text, cnic: _cnic.text, fatherName: _father.text, prisonNo: _prisonNo.text);
    setState(() {
      _results = res;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _cnic.dispose();
    _father.dispose();
    _prisonNo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect Prisoner')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CustomTextField(controller: _cnic, label: 'CNIC', keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            CustomTextField(controller: _name, label: 'Name'),
            const SizedBox(height: 8),
            CustomTextField(controller: _father, label: "Father's Name"),
            const SizedBox(height: 8),
            CustomTextField(controller: _prisonNo, label: 'Prison No'),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _doSearch, icon: const Icon(Icons.search), label: const Text('Search'))),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? const Center(child: Text('No results'))
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (ctx, i) {
                            final p = _results[i];
                              // Determine which fields to show based on non-empty search inputs
                              final fieldsToShow = <String>[];
                              if (_cnic.text.trim().isNotEmpty) fieldsToShow.add('cnic');
                              if (_name.text.trim().isNotEmpty) fieldsToShow.add('name');
                              if (_father.text.trim().isNotEmpty) fieldsToShow.add('fatherName');
                              if (_prisonNo.text.trim().isNotEmpty) fieldsToShow.add('prisonNo');

                              return PrisonerCard(
                                prisoner: p,
                                fieldsToShow: fieldsToShow,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VisitRequestScreen(prisoner: p, relationship: ''))),
                              );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
