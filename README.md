# Blooket Ôn Luyện — Frontend (Flutter Multiplatform)

Ứng dụng ôn luyện kiến thức tương tác theo phong cách Blooket (Flashcard 3D & Flag Cards Game) dành cho học sinh Lớp 5, người luyện thi TOEIC, v.v.

---

## 🚀 Chiến Thuật Phân Nhánh Git (Git Branching Strategy) & CI/CD Pipeline

Dự án áp dụng quy trình kiểm thử trước phát hành nghiêm ngặt qua 2 nhánh chính (`uat` và `main`):

```
[feature/fix branches]
         │
         ▼ (PR / Merge sau khi tăng version trong pubspec.yaml)
       [uat] ───► GitHub Actions: Build APK Release ───► Firebase App Distribution (Group: blooket-app-tester)
         │                                               (Kiểm thử trước khi phát hành)
         ▼ (Sau khi testers xác nhận đạt chuẩn)
      [main] ───► GitHub Actions: Build AAB Release ───► Google Play Console (Closed Testing / Production)
                + GitHub Actions: Build Web Release ────► Armbian Server (blooket.huypham.io.vn)
```

### 1. Nhánh `uat` (Pre-release / Testing):
* Mọi tính năng mới, sửa lỗi UI hoặc cập nhật từ các nhánh tính năng (`feat/*`, `fix/*`) **bắt buộc phải merge vào `uat` trước**.
* **Quy tắc bắt buộc:** Trước khi merge vào `uat`, phải tăng phiên bản ứng dụng (`version: X.Y.Z+build`) trong `pubspec.yaml`, cập nhật `lib/services/release_notes_data.dart` và `RELEASE_NOTES.md`.
* Khi code được push/merge vào `uat`:
  * GitHub Actions workflow (`android_deploy.yml`) sẽ tự động kích hoạt.
  * Chỉ biên dịch file **APK Release** và tự động tải lên **Firebase App Distribution** cho nhóm kiểm thử `blooket-app-tester`.
  * **Không ảnh hưởng** đến Google Play Store hay bản Web Production.

### 2. Nhánh `main` (Production Release):
* Chỉ nhận code merge từ nhánh `uat` khi phiên bản thử nghiệm trên Firebase đã đạt độ ổn định và sẵn sàng phát hành.
* Khi merge từ `uat` vào `main`:
  * **Android:** Biên dịch file **AAB (Android App Bundle)** đã ký số bằng Keystore và tự động tải lên **Google Play Console** (track Closed Testing/Production).
  * **Web:** Biên dịch `flutter build web --release` và đồng bộ qua Cloudflare SSH tới máy chủ Armbian.
  * Phiên bản trên Firebase và Google Play sẽ luôn đồng nhất hoàn toàn.

---

## 🛠️ Cấu Trúc Mã Nguồn

* `lib/models/`: Định nghĩa dữ liệu bài học (`LessonData`, `TheoryCard`, `ExerciseItem`), tiến trình học tập và cây chương trình (`CurriculumTree`).
* `lib/services/`:
  * `data_service.dart`: Nạp dữ liệu Server-Driven UI từ Backend API (`https://blooket-api.huypham.io.vn`), hỗ trợ offline fallback từ `assets/data/`.
  * `tts_service.dart`: Phát âm giọng đọc Text-To-Speech.
  * `storage_service.dart`: Lưu trữ cờ, sao và điểm kỷ lục trên thiết bị.
  * `release_notes_data.dart`: Danh mục lịch sử phiên bản hiển thị trực tiếp trong app.
* `lib/ui/screens/`: Các màn hình danh sách môn học (`subjects_screen.dart`), chọn tuần (`weeks_screen.dart`), bài học lý thuyết Flashcard 3D (`theory_screen.dart`), và Game trắc nghiệm giật cờ Blooket (`flag_cards_game_screen.dart`).

---

## 📱 Hướng Dẫn Dành Cho AI Agents

* Đọc kỹ file `AGENTS.md` và `NEXT_BUILD_NOTES.md` trước khi thực hiện bất kỳ thay đổi nào.
* Tuyệt đối không đẩy code trực tiếp lên `main` nếu chưa qua kiểm thử trên nhánh `uat`.
