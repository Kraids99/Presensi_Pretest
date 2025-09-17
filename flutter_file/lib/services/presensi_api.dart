import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_file/services/backend_launcher.dart' as bl;

class PresensiApi {
  final _dio = Dio(BaseOptions(baseUrl: bl.BackendLauncher.baseUrl));

  Future<File?> pickExcelOrCsv() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls'],
    );
    if (res == null || res.files.isEmpty) return null;
    return File(res.files.single.path!);
  }

  Future<File> kirimDanAmbil({
    required File log,
    required File pretest,
    void Function(int, int)? onSendProgress,
  }) async {
    final form = FormData.fromMap({
      'log': await MultipartFile.fromFile(
        log.path,
        filename: log.uri.pathSegments.last,
      ),
      'pretest': await MultipartFile.fromFile(
        pretest.path,
        filename: pretest.uri.pathSegments.last,
      ),
    });

    final resp = await _dio.post(
      '/presensi',
      data: form,
      options: Options(responseType: ResponseType.bytes),
      onSendProgress: onSendProgress,
    );

    // ⇩ simpan ke Downloads kalau ada (Windows/macOS/Linux), fallback ke Documents
    final downloads = await getDownloadsDirectory();
    final dir = downloads ?? await getApplicationDocumentsDirectory();

    // ⇩ nama file unik biar tidak mentok kalau file lama masih terbuka
    final ts = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final outPath =
        '${dir.path}${Platform.pathSeparator}Hasil_Presensi_$ts.xlsx';

    final file = File(outPath);
    await file.writeAsBytes(resp.data, flush: true);
    return file;
  }
}
