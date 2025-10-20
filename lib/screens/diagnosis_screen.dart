import 'package:flutter/material.dart';
import '../expert_system.dart';
import 'result_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  final String name;
  final int age;
  final String gender;

  const DiagnosisScreen({
    super.key,
    required this.name,
    required this.age,
    required this.gender,
  });

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
        builder: (context) => ResultScreen(
          name: widget.name,
          age: widget.age,
          gender: widget.gender,
          diagnosisResult: result,
        ),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Pilih semua gejala yang dialami oleh anak Anda.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),
          Expanded(
            child: ListView(
              children: _expertSystem.symptoms.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: CheckboxListTile(
                      title: Text(entry.value),
                      value: _selectedSymptomCodes.contains(entry.key),
                      onChanged: (bool? selected) {
                        _onSymptomSelected(selected, entry.key);
                      },
                      activeColor: Colors.tealAccent[400],
                    ),
                  ),
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
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('Lihat Hasil Diagnosis'),
            ),
          )
        ],
      ),
    );
  }
}