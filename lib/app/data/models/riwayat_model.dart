class RiwayatModel {
  final String tanggal;
  final String sarapan;
  final String makanSiang;
  final String makanMalam;
  final double kalori;
  final double protein;
  final double karbohidrat;
  final double lemak;
  final double gula;
  final double sodium;
  final String rekomendasi;
  final String statusKondisi;
  final String fotoPagi;
  final String fotoSiang;
  final String fotoMalam;
  final int skor;

  RiwayatModel({
    required this.tanggal,
    required this.sarapan,
    required this.makanSiang,
    required this.makanMalam,
    required this.kalori,
    required this.protein,
    required this.karbohidrat,
    required this.lemak,
    required this.gula,
    required this.sodium,
    required this.rekomendasi,
    required this.statusKondisi,
    required this.fotoPagi,
    required this.fotoSiang,
    required this.fotoMalam,
    required this.skor,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      tanggal: json['tanggal'] ?? '-',
      sarapan: json['pagi'] ?? '-',
      makanSiang: json['siang'] ?? '-',
      makanMalam: json['malam'] ?? '-',
      kalori: (json['total_kalori'] as num).toDouble(),
      protein: (json['total_protein'] as num).toDouble(),
      karbohidrat: (json['total_karbohidrat'] as num).toDouble(),
      lemak: (json['total_lemak'] as num).toDouble(),
      gula: (json['total_gula'] as num).toDouble(),
      sodium: (json['total_sodium'] as num).toDouble(),
      rekomendasi: json['saran'] ?? '',
      statusKondisi: json['status_kondisi'] ?? 'Normal',
      fotoPagi: json['foto_pagi'] ?? '',
      fotoSiang: json['foto_siang'] ?? '',
      fotoMalam: json['foto_malam'] ?? '',
      skor: json['skor'] ?? 80,
    );
  }
}