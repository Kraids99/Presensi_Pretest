import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class PresensiApi {
  static const baseUrl = 'http://127.0.0.1:8000'; // ganti sesuai target
  final _dio = Dio(BaseOptions(baseUrl: baseUrl));

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

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Hasil_Presensi.xlsx');
    await file.writeAsBytes(resp.data);
    return file;
  }
}
