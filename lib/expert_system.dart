class ExpertSystem {
  // --- Basis Pengetahuan: Gejala ---
  // Sumber data dari Jurnal "Sistem Pakar Diagnosa Penyakit Anak"
  final Map<String, String> symptoms = {
    'G01': 'Batuk Kering',
    'G02': 'Gelisah',
    'G03': 'Sulit Berbicara',
    'G04': 'Tingkat Kesadaran Menurun',
    'G05': 'Sesak Napas',
    'G06': 'Batuk Produktif dan Kuat',
    'G07': 'Dada Sesak',
    'G08': 'Pernafasan Berbunyi',
    'G09': 'Demam 2-4 Hari',
    'G10': 'Demam 5-7 Hari',
    'G11': 'Menggigil',
    'G12': 'Nyeri Otot',
    'G15': 'Sakit Kepala',
    'G16': 'Muntah',
    'G17': 'Diare',
    'G18': 'Kurang Nafsu Makan',
    'G19': 'Berat Badan Turun',
    'G20': 'Lidah Kotor di bagian Tengah',
    'G21': 'Ujung Lidah Berwarna Merah',
    'G22': 'Nyeri Tenggorokan',
    'G23': 'Lesu',
    'G24': 'Tangisan Merintih',
    'G25': 'Batuk > 3 Minggu (Bisa mengeluarkan darah)',
    'G26': 'Gusi Berdarah',
    'G27': 'Kejang',
    'G28': 'Keringat Malam Hari (Tanpa Aktivitas)',
    'G29': 'Flu > 3 Minggu',
    'G30': 'Memar Tanpa Sebab',
    'G31': 'Pembesaran Getah Bening',
    'G32': 'Nyeri Tulang',
    'G33': 'Demam Turun Secara Tiba-tiba',
    'G34': 'Nyeri Menelan',
    'G35': 'Muncul Kemerahan Pada Kulit',
    'G36': 'Malas Minum',
    'G37': 'Pucat',
    'G38': 'Mulut Berbau',
  };

  // --- Basis Pengetahuan: Aturan (Rules) ---
  final List<Map<String, dynamic>> rules = [
    {
      'disease': 'Asma',
      'conditions': ['G01', 'G05', 'G08', 'G07'],
    },
    {
      'disease': 'Bronchopneumonia',
      'conditions': ['G06', 'G05', 'G09'],
    },
    {
      'disease': 'Tifoid',
      'conditions': ['G10', 'G20', 'G21', 'G18', 'G16'],
    },
    {
      'disease': 'DHF (Demam Berdarah)',
      'conditions': ['G33', 'G35', 'G26', 'G12'],
    },
    {
      'disease': 'TBC (Tuberkulosis)',
      'conditions': ['G25', 'G19', 'G28', 'G29'],
    },
    {
      'disease': 'Tonsilitis',
      'conditions': ['G22', 'G34', 'G36', 'G38'],
    },
    {
      'disease': 'Leukemia',
      'conditions': ['G37', 'G23', 'G30', 'G31', 'G32'],
    },
    {
      'disease': 'Malaria',
      'conditions': ['G10', 'G11', 'G15'],
    },
    {
      'disease': 'Meningitis',
      'conditions': ['G04', 'G27', 'G15', 'G24'],
    },
  ];

  // --- Mesin Inferensi (Forward Chaining) ---
  String diagnose(Set<String> selectedSymptomCodes) {
    for (var rule in rules) {
      List<String> conditions = rule['conditions'];
      // Cek apakah semua gejala dalam rule ada di gejala yang dipilih user
      if (selectedSymptomCodes.containsAll(conditions)) {
        return rule['disease']; // Jika cocok, kembalikan nama penyakit
      }
    }
    return 'Penyakit tidak dapat didiagnosis berdasarkan gejala yang dipilih. Silakan konsultasi ke dokter.';
  }
}