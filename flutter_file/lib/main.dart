import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file/download_card.dart';
import 'package:flutter_file/services/presensi_api.dart';
import 'package:open_filex/open_filex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final api = PresensiApi();
  File? logFile, preFile;
  bool busy = false;
  double prog = 0;

  Future<void> pilihLog() async {
    logFile = await api.pickExcelOrCsv();
    setState(() {});
  }

  Future<void> pilihPre() async {
    preFile = await api.pickExcelOrCsv();
    setState(() {});
  }

  Future<void> proses() async {
    if (logFile == null || preFile == null) return;
    setState(() {
      busy = true;
      prog = 0;
    });
    try {
      final result = await api.kirimDanAmbil(
        log: logFile!,
        pretest: preFile!,
        onSendProgress: (s, t) => setState(() => prog = t == 0 ? 0 : s / t),
      );
      await OpenFilex.open(result.path); // buka hasil
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Disimpan: ${result.path}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 228, 105, 132), // pink tua
                Color.fromARGB(255, 240, 170, 185), // pink muda
              ],
            ),
          ),

          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Judul
                Text(
                  'Sistem Presensi Praktikum',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gabungkan data log dan pretest untuk menghasilkan presensi dalam format Excel',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 32),

                // **ROW untuk dua card**
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16,
                  ),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final logName = logFile?.path
                          .split(Platform.pathSeparator)
                          .last;
                      final preName = preFile?.path
                          .split(Platform.pathSeparator)
                          .last;

                      final isWide = c.maxWidth > 500;
                      final children = [
                        Expanded(
                          child: UploadCard(
                            title: 'Data Log',
                            onPick: pilihLog,
                            pickedName: logName,
                          ),
                        ),
                        SizedBox(
                          width: isWide ? 24 : 0,
                          height: isWide ? 0 : 24,
                        ),
                        Expanded(
                          child: UploadCard(
                            title: 'Data Pretest',
                            onPick: pilihPre,
                            pickedName: preName,
                          ),
                        ),
                      ];

                      return isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: children,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: children,
                            );
                    },
                  ),
                ),

                const SizedBox(height: 28),
                DownloadCard(
                  enabled: logFile != null && preFile != null,
                  busy: busy,
                  progress: prog,
                  onPressed: proses,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UploadCard extends StatelessWidget {
  final String title;
  final VoidCallback onPick; // <— tambah
  final String? pickedName;
  const UploadCard({
    super.key,
    required this.title,
    required this.onPick,
    this.pickedName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF253046),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4D7DE), width: 2),
              ),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: onPick, // <— gunakan handler
                    icon: const Icon(Icons.insert_drive_file),
                    label: const Text('Pilih File'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      backgroundColor: const Color(0xFF6F66FF),
                      foregroundColor: Colors.white,
                      elevation: 6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pickedName ?? 'Format: CSV atau Excel',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
