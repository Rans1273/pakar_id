import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pakar_id/history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DiagnosisHistory> _historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyJson = prefs.getStringList('diagnosis_history') ?? [];
    setState(() {
      _historyList = historyJson
          .map((item) => DiagnosisHistory.fromJson(json.decode(item)))
          .toList()
          ..sort((a, b) => b.date.compareTo(a.date)); // Urutkan dari terbaru
    });
  }

  Future<void> _deleteHistory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyJson = prefs.getStringList('diagnosis_history') ?? [];
    
    // Cari dan hapus item yang sesuai berdasarkan timestamp unik
    final itemToDelete = _historyList[index];
    historyJson.removeWhere((item) {
        final decodedItem = DiagnosisHistory.fromJson(json.decode(item));
        return decodedItem.date.isAtSameMomentAs(itemToDelete.date) && decodedItem.name == itemToDelete.name;
    });

    await prefs.setStringList('diagnosis_history', historyJson);
    _loadHistory();
  }

  Future<void> _clearAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('diagnosis_history');
    _loadHistory();
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Riwayat'),
          content: const Text('Apakah Anda yakin ingin menghapus riwayat ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deleteHistory(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
    void _showClearAllConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Semua Riwayat'),
          content: const Text('Apakah Anda yakin ingin menghapus semua riwayat diagnosis?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus Semua', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _clearAllHistory();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Diagnosis'),
        actions: [
          if (_historyList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _showClearAllConfirmation,
              tooltip: 'Hapus Semua Riwayat',
            ),
        ],
      ),
      body: _historyList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Belum ada riwayat diagnosis.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _historyList.length,
              itemBuilder: (context, index) {
                final history = _historyList[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(history.name[0].toUpperCase(), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(history.diagnosis, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${history.name} | Usia: ${history.age} | ${history.gender}\n${history.date.toLocal().toString().split('.')[0]}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _showDeleteConfirmation(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}