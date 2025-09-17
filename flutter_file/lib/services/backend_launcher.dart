import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class BackendLauncher {
  static Process? _proc;
  static String baseUrl = 'http://127.0.0.1:8000';

  static Future<void> start() async {
    if (!Platform.isWindows) return; // contoh khusus Windows

    // Extract exe dari assets ke folder support app
    final support = await getApplicationSupportDirectory();
    final exePath = p.join(support.path, 'presensi_backend.exe');
    final exeFile = File(exePath);
    if (!await exeFile.exists()) {
      final bytes = await rootBundle.load(
        'assets/backend/presensi_backend.exe',
      );
      await exeFile.create(recursive: true);
      await exeFile.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    }

    // Jalankan backend (port 8000). Kalau takut bentrok: ganti ke port lain & sesuaikan baseUrl.
    _proc ??= await Process.start(
      exePath,
      const ['--port', '8000'],
      mode: ProcessStartMode.normal,
    ); // gunakan .detached bila tak mau ada console

    // Tunggu sampai /ping/ready
    final dio = Dio(
      BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 2)),
    );
    final deadline = DateTime.now().add(const Duration(seconds: 10));
    while (DateTime.now().isBefore(deadline)) {
      try {
        final r = await dio.get('/ping'); // buat endpoint ping di Flask
        if (r.statusCode == 200) return;
      } catch (_) {
        /*retry*/
      }
      await Future.delayed(const Duration(milliseconds: 250));
    }
    throw Exception('Backend tidak siap.');
  }

  static Future<void> stop() async {
    _proc?.kill();
    _proc = null;
  }
}
