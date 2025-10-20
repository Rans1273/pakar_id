import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pakar_id/history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  final String name;
  final int age;
  final String gender;
  final String diagnosisResult;

  const ResultScreen({
    super.key,
    required this.name,
    required this.age,
    required this.gender,
    required this.diagnosisResult,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.diagnosisResult != 'Penyakit tidak dapat didiagnosis berdasarkan gejala yang dipilih. Silakan konsultasi ke dokter.') {
      _saveHistory();
    }
  }

  Future<void> _saveHistory() async {
    final newHistory = DiagnosisHistory(
      name: widget.name,
      age: widget.age,
      gender: widget.gender,
      diagnosis: widget.diagnosisResult,
      date: DateTime.now(),
    );

    final prefs = await SharedPreferences.getInstance();
    final List<String> historyJson = prefs.getStringList('diagnosis_history') ?? [];
    historyJson.add(json.encode(newHistory.toJson()));
    await prefs.setStringList('diagnosis_history', historyJson);
  }

  @override
  Widget build(BuildContext context) {
    bool isSuccess = widget.diagnosisResult != 'Penyakit tidak dapat didiagnosis berdasarkan gejala yang dipilih. Silakan konsultasi ke dokter.';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Diagnosis'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: isSuccess ? Colors.tealAccent[400] : Colors.amber[600],
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                isSuccess ? 'Kemungkinan Diagnosis:' : 'Diagnosis Tidak Ditemukan',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              Text(
                widget.diagnosisResult,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? Colors.tealAccent[400] : Colors.amber[600]),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[900]?.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'PENTING: Hasil ini bukan pengganti konsultasi medis profesional. Segera kunjungi dokter untuk diagnosis yang akurat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Selesai'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}