import '../models/prisoner.dart';

class MockService {
  static final List<Prisoner> _prisoners = [
    Prisoner.fromMap({
      'id': '1',
      'name': 'Ahmed Khan',
      'fatherName': 'Ghulam',
      'cnic': '4230112345678',
      'prisonNo': 'P-1001'
    }),
    Prisoner.fromMap({
      'id': '2',
      'name': 'Sara Bibi',
      'fatherName': 'Muhammad',
      'cnic': '4210112345678',
      'prisonNo': 'P-1002'
    }),
    Prisoner.fromMap({
      'id': '3',
      'name': 'Uzair Ali',
      'fatherName': 'Salman',
      'cnic': '6110112345678',
      'prisonNo': 'P-1010'
    }),
  ];

  static Future<List<Prisoner>> search({String? name, String? cnic, String? fatherName, String? prisonNo}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _prisoners.where((p) {
      final matchName = name == null || name.isEmpty || p.name.toLowerCase().contains(name.toLowerCase());
      final matchCnic = cnic == null || cnic.isEmpty || p.cnic.contains(cnic.replaceAll('-', ''));
      final matchFather = fatherName == null || fatherName.isEmpty || p.fatherName.toLowerCase().contains(fatherName.toLowerCase());
      final matchPrison = prisonNo == null || prisonNo.isEmpty || p.prisonNo.toLowerCase().contains(prisonNo.toLowerCase());
      return matchName && matchCnic && matchFather && matchPrison;
    }).toList();
  }
}
