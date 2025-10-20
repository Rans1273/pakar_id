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
    _saveHistory();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Diagnosis'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Berdasarkan gejala yang dipilih, kemungkinan diagnosis adalah:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                widget.diagnosisResult,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 40),
              const Text(
                'PENTING: Hasil ini bukan pengganti konsultasi medis profesional. Segera kunjungi dokter untuk diagnosis yang akurat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Kembali ke Halaman Utama'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}