class Prisoner {
  final String id;
  final String name;
  final String fatherName;
  final String cnic;
  final String prisonNo;

  Prisoner({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.cnic,
    required this.prisonNo,
  });

  factory Prisoner.fromMap(Map<String, String> m) => Prisoner(
        id: m['id'] ?? '',
        name: m['name'] ?? '',
        fatherName: m['fatherName'] ?? '',
        cnic: m['cnic'] ?? '',
        prisonNo: m['prisonNo'] ?? '',
      );
}
