import 'package:flutter/material.dart';
import '../ui/theme/app_theme.dart';

class ReleaseNoteItem {
  final String version;
  final String date;
  final String build;
  final String summary;
  final List<String> features;
  final List<String> fixes;

  const ReleaseNoteItem({
    required this.version,
    required this.date,
    required this.build,
    required this.summary,
    required this.features,
    required this.fixes,
  });
}

class ReleaseNotesData {
  static const String currentVersion = '1.0.8';
  static const int currentBuild = 8;

  static const List<ReleaseNoteItem> history = [
    ReleaseNoteItem(
      version: 'v1.0.8',
      date: '27/11/2026',
      build: 'Build 8',
      summary: 'Chuẩn hóa hiển thị phiên bản Backend & Đồng bộ học liệu Offline',
      features: [
        'Chuẩn hóa hiển thị Backend Version v1.1.0 chính xác ở mọi trạng thái mạng (online/offline).',
        'Đồng bộ toàn bộ 52 bài học và 2 môn học mới (Địa Lý và Khoa Học 5 HK1) vào gói dữ liệu offline của app.',
      ],
      fixes: [
        'Khắc phục hiển thị "vOffline" khi ứng dụng nạp dữ liệu từ bộ nhớ đệm cục bộ.',
      ],
    ),
    ReleaseNoteItem(
      version: 'v1.0.7',
      date: '26/11/2026',
      build: 'Build 7',
      summary: 'Tối ưu giao diện AppBar Mobile & Tích hợp hiển thị Version Backend độc lập',
      features: [
        'Hiển thị thông tin phiên bản Backend (BE v...) độc lập song song với phiên bản App ở chân trang và màn hình Cài đặt (About).',
        'Tích hợp tính năng kéo xuống làm mới (Pull-to-Refresh) ngay trên danh sách môn học để cập nhật bài học mới từ Backend tức thì.',
      ],
      fixes: [
        'Khắc phục triệt để lỗi hiển thị đè chữ trên thanh tiêu đề AppBar của thiết bị di động: tự động co giãn kích thước, căn chỉnh khoảng cách và ẩn bớt huy hiệu thừa khi màn hình hẹp.',
      ],
    ),
    ReleaseNoteItem(
      version: 'v1.0.6',
      date: '22/11/2026',
      build: 'Build 6',
      summary: 'Mở rộng Tab TOEIC & Bộ Game ETS 2026 từ kho thẻ Anki',
      features: [
        'Thêm Tab Khối Luyện Thi TOEIC mới song song với các Khối Lớp phổ thông.',
        'Tích hợp 86 thẻ Anki ETS 2026 chuẩn 750+ vào 3 môn học: ETS 2026 Listening (Part 1-4), ETS 2026 Reading (Part 5-6), và Đấu trường Blooket Master.',
        'Hỗ trợ thanh Tab cuộn ngang mượt mà trên mọi kích thước màn hình thiết bị di động.',
        'Người dùng Android đã cài app tự động cập nhật Tab TOEIC qua Server-Driven UI mà không cần tải lại app.',
      ],
      fixes: [
        'Tối ưu hóa endpoint API backend hỗ trợ mã định danh khối linh hoạt cho các kỳ thi chứng chỉ.',
      ],
    ),
    ReleaseNoteItem(
      version: 'v1.0.5',
      date: '22/11/2026',
      build: 'Build 5',
      summary: 'Kiến trúc Server-Driven UI & Hiển thị phiên bản trực quan',
      features: [
        'Server-Driven UI 100%: Toàn bộ màu sắc, nhãn trạng thái, biểu tượng emoji của tuần học được quản lý động từ Backend qua API.',
        'Huy hiệu phiên bản trực quan trên thanh AppBar và chân trang Web, kèm cửa sổ tra cứu Release Notes.',
        'Màn hình Release Notes trực quan, tiện lợi kiểm tra lịch sử nâng cấp và bug fixes.',
      ],
      fixes: [
        'Sửa lỗi cú pháp dấu ngoặc nhọn trong weeks_screen.dart giúp quy trình CI/CD build Web hoàn tất 100%.',
        'Bộ lọc màu HEX an toàn tránh lỗi hiển thị khi Backend trả về mã màu mới.',
      ],
    ),
    ReleaseNoteItem(
      version: 'v1.0.4',
      date: '21/11/2026',
      build: 'Build 4',
      summary: 'Đại cập nhật Ôn Thi Cuối Kì 1 (W10) & Google Play Closed Testing',
      features: [
        'Tuần 10: Review Final Test 1 siêu chi tiết với 28 thẻ Flashcard và 40 câu hỏi trắc nghiệm Anh Văn Blooket chuẩn hóa.',
        'Môn Khoa Học & Toán Học bổ sung ngân hàng câu hỏi ôn tập Cuối Kì 1.',
        'Hoàn thiện nội dung cho toàn bộ các tuần W3, W4, W5, W7 từ tài liệu thực tế.',
        'Đóng gói AAB và nộp thành công lên Google Play Store track Closed Testing.',
      ],
      fixes: [
        'Bổ sung chính sách quyền riêng tư đạt chuẩn yêu cầu chính sách trẻ em của Google Play.',
      ],
    ),
    ReleaseNoteItem(
      version: 'v1.0.3',
      date: '21/11/2026',
      build: 'Build 3',
      summary: 'Tự động hóa phát hành qua Firebase App Distribution',
      features: [
        'Tích hợp Fastlane tự động ký số bằng Keystore.',
        'Tự động gửi bản APK cho nhóm kiểm thử blooket-app-tester trên Firebase.',
      ],
      fixes: [],
    ),
    ReleaseNoteItem(
      version: 'v1.0.2',
      date: '20/11/2026',
      build: 'Build 2',
      summary: 'Dynamic In-Game Shuffling & Giao diện chuẩn Wireframe',
      features: [
        'Cơ chế chống học vẹt: Tự động đảo ngẫu nhiên vị trí đáp án đúng mỗi khi câu hỏi xuất hiện.',
        'Thêm màn hình Giới thiệu About & Cài đặt thông số Text-To-Speech bản xứ.',
      ],
      fixes: [],
    ),
    ReleaseNoteItem(
      version: 'v1.0.0',
      date: '20/11/2026',
      build: 'Build 1',
      summary: 'Khởi tạo nền tảng đa nền tảng Flutter & API Server',
      features: [
        'Hệ thống Flutter đa nền tảng cho Web, Android, iOS.',
        'Backend Node.js + TypeScript phục vụ API qua Cloudflare Tunnel Zero Trust.',
        'Web App hoạt động trên container Nginx tại blooket.huypham.io.vn.',
      ],
      fixes: [],
    ),
  ];

  static void showReleaseNotesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620, maxHeight: 680),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.history_edu_rounded, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nhật Ký Phát Hành',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textMain,
                            ),
                          ),
                          Text(
                            'Release Notes & Bug Fixes theo từng phiên bản',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // History List
                Expanded(
                  child: ListView.separated(
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final isLatest = index == 0;

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isLatest ? const Color(0xFFFAF5FF) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isLatest ? AppColors.purple : AppColors.border,
                            width: isLatest ? 1.8 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Version Tag & Date
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isLatest ? AppColors.purple : AppColors.textMain,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item.version,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${item.build} • ${item.date})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                if (isLatest)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Mới nhất',
                                      style: TextStyle(
                                        color: Color(0xFF15803D),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.summary,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Features
                            if (item.features.isNotEmpty) ...[
                              const Text(
                                '✨ Tính năng & Cải tiến:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4338CA),
                                ),
                              ),
                              const SizedBox(height: 4),
                              ...item.features.map(
                                (f) => Padding(
                                  padding: const EdgeInsets.only(left: 6, bottom: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ', style: TextStyle(color: AppColors.primary)),
                                      Expanded(
                                        child: Text(
                                          f,
                                          style: const TextStyle(fontSize: 12, color: AppColors.textMain),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            // Fixes
                            if (item.fixes.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              const Text(
                                '🐛 Sửa lỗi (Bug Fixes):',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB91C1C),
                                ),
                              ),
                              const SizedBox(height: 4),
                              ...item.fixes.map(
                                (fx) => Padding(
                                  padding: const EdgeInsets.only(left: 6, bottom: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ', style: TextStyle(color: AppColors.error)),
                                      Expanded(
                                        child: Text(
                                          fx,
                                          style: const TextStyle(fontSize: 12, color: AppColors.textMain),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đóng', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
