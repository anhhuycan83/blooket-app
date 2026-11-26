# NEXT BUILD NOTES — BLOOKET ÔN LUYỆN (FRONTEND)

> Nhánh hiện tại `fix/appbar-and-backend-version` đã chứa phần fix AppBar mobile + hiển thị Backend Version độc lập (`BE v...`). **Chưa merge vào `main`** để không trigger CI/CD build trước thời điểm release.

## Đã hoàn thành trên nhánh `fix/appbar-and-backend-version`:
* Fix lỗi tiêu đề & chip version trên AppBar `SubjectsScreen` bị 2 icon (`🚩 Cờ`, `🔥`) đè lên nhau trên màn hình điện thoại.
* Đọc `backendVersion` từ `/api/v1/curriculum/tree` trong `DataService` và hiển thị độc lập ở Footer `SubjectsScreen` + hộp thoại `About` trong `SettingsScreen`.
* Thêm `RefreshIndicator` kéo xuống để tải lại dữ liệu mới từ Backend.

## Việc cần làm tiếp khi người dùng yêu cầu Release `v1.0.7`:
1. **TTS tiếng Việt (`vi-VN`)** trong `lib/services/tts_service.dart` (tự nhận diện `geography`, `science_vn` hoặc chữ tiếng Việt có dấu).
2. **Sửa điều hướng Next (`->`) & text cứng `Tuần 9`** trong `lib/ui/screens/weeks_screen.dart` để lấy động theo `widget.subject.weeks`.
3. **Thêm icon môn học mới** (`public`, `headphones`, `menu_book`) trong `lib/ui/screens/subjects_screen.dart`.
4. **Đồng bộ `assets/data/`** từ `../backend/data/` trước khi build bản offline fallback.
5. **Tăng version `pubspec.yaml` (`1.0.7+7`), cập nhật `lib/services/release_notes_data.dart` và `RELEASE_NOTES.md`.**
6. **Merge nhánh `fix/appbar-and-backend-version` vào `main`** (và tạo tag `v1.0.7` nếu đẩy Google Play).
7. **iOS / TestFlight:** Chưa làm ở thời điểm này (chỉ triển khai khi người dùng yêu cầu).
