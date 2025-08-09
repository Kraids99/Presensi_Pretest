import 'package:flutter/material.dart';

class DownloadCard extends StatelessWidget {
  final bool enabled; // aktif jika 2 file sudah dipilih
  final bool busy; // true saat upload/proses berlangsung
  final double progress; // 0..1
  final VoidCallback onPressed;

  const DownloadCard({
    super.key,
    required this.enabled,
    required this.busy,
    required this.progress,
    required this.onPressed,
  });

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
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3DDC84),
                  ),
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
            Text(
              'File presensi akan dihasilkan setelah kedua file berhasil diunggah',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)),
            ),
            const SizedBox(height: 16),

            if (!busy)
              _StatusChip(enabled: enabled)
            else ...[
              LinearProgressIndicator(value: progress == 0 ? null : progress),
              const SizedBox(height: 12),
            ],

            ElevatedButton.icon(
              onPressed: (enabled && !busy) ? onPressed : null,
              icon: const Icon(Icons.download_rounded),
              label: Text(busy ? 'Memproses...' : 'Proses & Download'),
              style: ElevatedButton.styleFrom(
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

class _StatusChip extends StatelessWidget {
  final bool enabled;
  const _StatusChip({required this.enabled});

  @override
  Widget build(BuildContext context) {
    final waiting = !enabled;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: waiting ? const Color(0xFFFFF8E6) : const Color(0xFFE8FFF1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: waiting ? const Color(0xFFFFE7AE) : const Color(0xFFB9F5CE),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            waiting
                ? Icons.hourglass_empty_rounded
                : Icons.check_circle_rounded,
            size: 18,
            color: waiting ? const Color(0xFFC89E23) : const Color(0xFF21A05A),
          ),
          const SizedBox(width: 8),
          Text(
            waiting ? 'Menunggu file log dan pretest' : 'Siap diproses',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: waiting
                  ? const Color(0xFF8A6D1D)
                  : const Color(0xFF176A3E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
