# AGENTS.md — Hướng Dẫn Frontend (Blooket App)

1. **Không push hoặc merge vào `main` khi chưa có lệnh release** vì `deploy.yml` (Web) và `android_deploy.yml` (Firebase APK) chạy tự động trên mọi push `main` (tag `v*` đẩy Google Play).
2. **Nhánh đang chờ release (`fix/appbar-and-backend-version`):**
   * Đã fix lỗi AppBar mobile đè chữ tiêu đề & chip version.
   * Đã tích hợp hiển thị `BE v...` độc lập từ `DataService().backendVersion` ở Footer và Settings -> About.
   * Đã thêm `RefreshIndicator` kéo xuống làm mới trên `SubjectsScreen`.
3. **Khi người dùng yêu cầu release `v1.0.7`:**
   * Đọc `NEXT_BUILD_NOTES.md` để làm nốt các mục còn lại (TTS `vi-VN`, nút Next ở `WeeksScreen`, icon mới, đồng bộ `assets/data/`, nâng version `pubspec.yaml` & `release_notes_data.dart`), rồi mới merge nhánh này vào `main`.
4. **Phạm vi:** Chỉ Web & Android. **Chưa triển khai iOS** vào thời điểm này.
