import 'package:flutter/material.dart';
import '../expert_system.dart';
import 'result_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final ExpertSystem _expertSystem = ExpertSystem();
  final Set<String> _selectedSymptomCodes = {};

  void _onSymptomSelected(bool? selected, String symptomCode) {
    setState(() {
      if (selected == true) {
        _selectedSymptomCodes.add(symptomCode);
      } else {
        _selectedSymptomCodes.remove(symptomCode);
      }
    });
  }

  void _startDiagnosis() {
    final result = _expertSystem.diagnose(_selectedSymptomCodes);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(diagnosisResult: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Gejala'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _expertSystem.symptoms.entries.map((entry) {
                return CheckboxListTile(
                  title: Text(entry.value),
                  value: _selectedSymptomCodes.contains(entry.key),
                  onChanged: (bool? selected) {
                    _onSymptomSelected(selected, entry.key);
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedSymptomCodes.isEmpty ? null : _startDiagnosis,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Lihat Hasil Diagnosis'),
            ),
          )
        ],
      ),
    );
  }
}