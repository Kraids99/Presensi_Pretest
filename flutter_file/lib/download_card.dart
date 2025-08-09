import 'package:flutter/material.dart';

class DownloadCard extends StatelessWidget {
  const DownloadCard({super.key});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22);

    return Card(
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.black26,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: radius),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3DDC84),
                  ),
                  width: 12,
                  height: 12,
                ),
                const SizedBox(width: 12),
                Text(
                  'Download Hasil',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Deskripsi
            Text(
              'File presensi akan dihasilkan setelah kedua file berhasil diunggah',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E6),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFFFE7AE)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.hourglass_empty_rounded,
                    size: 18,
                    color: Color(0xFFC89E23),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Menunggu file log dan pretest',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF8A6D1D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Tombol download (disabled)
            ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.download_rounded),
              label: const Text('Download File Presensi'),
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: const Color(
                  0xFF6F66FF,
                ).withOpacity(.35),
                disabledForegroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
