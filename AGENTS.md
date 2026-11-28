# AGENTS.md — Hướng Dẫn Frontend (Blooket App)

1. **Chiến thuật Git Branching chuẩn hóa (BẮT BUỘC TUÂN THỦ):**
   * **Nhánh `uat` (Pre-release):**
     * Mọi code thay đổi, sửa lỗi, tính năng mới từ các nhánh feature (`feat/*`, `fix/*`) **bắt buộc phải merge vào `uat` trước**.
     * **Quy tắc:** Mỗi lần merge vào `uat`, phải tăng phiên bản ứng dụng (`version: X.Y.Z+build` trong `pubspec.yaml`, cập nhật `release_notes_data.dart` và `RELEASE_NOTES.md`).
     * Khi push vào `uat`: GitHub Actions (`android_deploy.yml`) sẽ tự động build **file APK** và tải lên **Firebase App Distribution** cho nhóm testers (`blooket-app-tester`).
   * **Nhánh `main` (Production Release):**
     * **Tuyệt đối KHÔNG push hoặc merge code trực tiếp từ nhánh feature vào `main`**.
     * `main` chỉ nhận code merge từ `uat` khi người dùng yêu cầu phát hành chính thức phiên bản đó lên Google Play.
     * Khi merge `uat` vào `main`: GitHub Actions sẽ tự động build **file AAB** đẩy lên **Google Play Console** (track Closed Testing/Production) và build **Web Release** deploy lên server Armbian.

2. **Trạng thái hiện tại trên `uat` (v1.0.7 - Build 7):**
   * Đã sửa lỗi tiêu đề AppBar mobile bị 2 badge cờ và streak đè lên chữ.
   * Đã tách biệt và hiển thị thông tin phiên bản Backend (`BE v...`) độc lập ở Footer và màn hình Cài đặt (`About`), không còn hiển thị text `(Live via Cloudflare)`.
   * Đã bổ sung `RefreshIndicator` kéo xuống làm mới bài học từ Backend.

3. **Phạm vi nền tảng:** Chỉ tập trung Web & Android. **Chưa triển khai iOS / TestFlight** vào thời điểm này.
