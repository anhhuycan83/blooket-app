import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../services/release_notes_data.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 12),
            const Text(
              'Về Ứng Dụng',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Blooket Ôn Luyện',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Nền tảng ôn tập kiến thức Flashcards & Flag Game',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            ),
            const Divider(height: 28),
            _buildInfoRow(Icons.person_rounded, 'Tác giả', 'Huy Pham'),
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.verified_rounded,
              'App (Frontend)',
              'v${ReleaseNotesData.currentVersion} (Build ${ReleaseNotesData.currentBuild})',
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.cloud_done_rounded,
              'Data (Backend)',
              'v${DataService().backendVersion} (${DataService().isUsingLiveBackend ? "Live via Cloudflare" : "Offline"})',
            ),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.devices_rounded, 'Nền tảng', 'Web, Android'),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Ứng dụng hỗ trợ học sinh ôn tập các môn Tiếng Anh, Toán và Khoa học thông qua cơ chế thẻ bài và câu hỏi trắc nghiệm tương tác sinh động.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textMain),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: AppColors.textMuted, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt & Tuỳ Chọn'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Section 1: Thông tin & Giới thiệu
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Text(
                  'THÔNG TIN CHUNG',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                      ),
                      title: const Text(
                        'About (Về ứng dụng)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        'App v${ReleaseNotesData.currentVersion} • BE v${DataService().backendVersion}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () => _showAboutDialog(context),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.history_edu_rounded, color: AppColors.purple),
                      ),
                      title: const Text(
                        'Nhật ký cập nhật (Release Notes)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: const Text('Xem lịch sử tính năng mới & các lỗi đã fix'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () => ReleaseNotesData.showReleaseNotesDialog(context),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.security_rounded, color: AppColors.success),
                      ),
                      title: const Text(
                        'Chính sách quyền riêng tư',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: const Text('Bảo mật dữ liệu học tập của học sinh'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: const Text('Chính Sách Riêng Tư', style: TextStyle(fontWeight: FontWeight.bold)),
                            content: const Text(
                              'Ứng dụng Blooket Ôn Luyện cam kết không thu thập dữ liệu vị trí, danh bạ hay thông tin cá nhân nhạy cảm của người dùng. Tiến độ học tập được lưu trữ an toàn trên thiết bị và đồng bộ qua server riêng.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Đã hiểu'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section 2: Trải nghiệm & Âm thanh
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Text(
                  'TRẢI NGHIỆM HỌC TẬP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.record_voice_over_rounded, color: AppColors.accentDark),
                      ),
                      title: const Text(
                        'Text-To-Speech (Phát âm)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: const Text('Giọng đọc chuẩn bản xứ tiếng Anh (en-US)'),
                      trailing: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.shuffle_rounded, color: AppColors.purple),
                      ),
                      title: const Text(
                        'Xáo trộn đáp án ngẫu nhiên',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: const Text('Tự động đổi vị trí A, B, C, D mỗi lượt chơi'),
                      trailing: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
