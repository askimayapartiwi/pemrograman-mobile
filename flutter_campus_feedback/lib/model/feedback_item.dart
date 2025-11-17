class FeedbackItem {
  final String id;
  final String nama;
  final String nim;
  final String fakultas;
  final String jenisFeedback;
  final double nilaiKepuasan;
  final List<String> fasilitas;
  final String pesanTambahan;
  final bool setujuSyarat;
  final DateTime tanggal;

  FeedbackItem({
    required this.id,
    required this.nama,
    required this.nim,
    required this.fakultas,
    required this.jenisFeedback,
    required this.nilaiKepuasan,
    required this.fasilitas,
    required this.pesanTambahan,
    required this.setujuSyarat,
    required this.tanggal,
  });

  factory FeedbackItem.fromMap(Map<String, dynamic> map) {
    // Handle tanggal 
    DateTime tanggal;
    if (map['tanggal'] is DateTime) {
      tanggal = map['tanggal'];
    } else if (map['tanggal'] is int) {
      tanggal = DateTime.fromMillisecondsSinceEpoch(map['tanggal']);
    } else {
      tanggal = DateTime.now(); // fallback
    }

    return FeedbackItem(
      id: map['id']?.toString() ?? 'no-id',
      nama: map['nama']?.toString() ?? 'No Name',
      nim: map['nim']?.toString() ?? 'No NIM',
      fakultas: map['fakultas']?.toString() ?? 'No Fakultas',
      jenisFeedback: map['jenisFeedback']?.toString() ?? 'Saran',
      nilaiKepuasan: (map['nilaiKepuasan'] is num) 
          ? (map['nilaiKepuasan'] as num).toDouble() 
          : 3.0,
      fasilitas: map['fasilitas'] is List 
          ? List<String>.from(map['fasilitas']) 
          : <String>[],
      pesanTambahan: map['pesanTambahan']?.toString() ?? '',
      setujuSyarat: map['setujuSyarat'] == true || map['setujuSyarat']?.toString() == 'true',
      tanggal: tanggal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
      'fakultas': fakultas,
      'jenisFeedback': jenisFeedback,
      'nilaiKepuasan': nilaiKepuasan,
      'fasilitas': fasilitas,
      'pesanTambahan': pesanTambahan,
      'setujuSyarat': setujuSyarat,
      'tanggal': tanggal.millisecondsSinceEpoch, // ✅ Simpan sebagai int
    };
  }

  // ✅ Method untuk debug
  @override
  String toString() {
    return 'FeedbackItem{id: $id, nama: $nama, nim: $nim, fakultas: $fakultas, jenisFeedback: $jenisFeedback, nilaiKepuasan: $nilaiKepuasan, fasilitas: $fasilitas, tanggal: $tanggal}';
  }
}