# Hướng Dẫn Root Pixel 9a (Android 16) & Thiết Lập Device Owner

Tài liệu này hướng dẫn chi tiết từng bước cách root Google Pixel 9a chạy Android 16 thông qua phương pháp patch `init_boot.img` bằng Magisk, đồng thời cài đặt và cấp quyền quản trị cao nhất (Device Owner) cho một ứng dụng tùy chỉnh qua ADB.

---

## ⚠️ Lưu ý quan trọng
* **Mất toàn bộ dữ liệu:** Quá trình mở khóa Bootloader sẽ kích hoạt Factory Reset. Hãy sao lưu toàn bộ dữ liệu quan trọng trước khi bắt đầu.
* **Đúng phân vùng:** Trên Android 13+, bắt buộc phải can thiệp vào phân vùng `init_boot`, tuyệt đối không flash vào phân vùng `boot` để tránh lỗi bootloop.

---

## 🛠 Chuẩn bị công cụ
1. Máy tính đã cài đặt [SDK Platform-Tools (ADB & Fastboot)](https://developer.android.com/studio/releases/platform-tools).
2. Tải bản ROM (Factory Image) chuẩn xác 100% với **Số bản dựng (Build number)** hiện tại của máy từ trang chủ Google.
3. Tải ứng dụng **Magisk APK** mới nhất từ [GitHub của topjohnwu](https://github.com/topjohnwu/Magisk).
4. Cáp kết nối USB chất lượng tốt.

---

## Phần 1: Mở khóa Bootloader & Root (Magisk)

### Bước 1: Trích xuất file hệ thống
1. Giải nén bản ROM Factory Image vừa tải.
2. Tìm và giải nén tiếp file zip bên trong (có tên dạng `image-[tên_mã]-[phiên_bản].zip`).
3. Copy file `init_boot.img` và dán vào thư mục `platform-tools` trên máy tính.

### Bước 2: Mở khóa Bootloader
1. Trên điện thoại, vào **Cài đặt > Giới thiệu điện thoại**, chạm 7 lần vào **Số bản dựng** để bật Tùy chọn nhà phát triển.
2. Vào **Hệ thống > Tùy chọn nhà phát triển**, bật **Mở khóa OEM (OEM Unlocking)** và **Gỡ lỗi USB (USB Debugging)**.
3. Kết nối cáp, mở Terminal/CMD tại thư mục `platform-tools` và chạy lệnh:
```bash
adb reboot bootloader
```
4. Khi máy vào màn hình Fastboot, chạy lệnh:
```bash
fastboot flashing unlock
```
5. Dùng phím Âm lượng trên điện thoại chọn **Unlock the bootloader** và bấm phím Nguồn để xác nhận. Máy sẽ khởi động lại và xóa dữ liệu.
6. Thiết lập nhanh máy, bật lại **Gỡ lỗi USB**.

### Bước 3: Patch file bằng Magisk
1. Bỏ file Magisk APK vào điện thoại và cài đặt.
2. Đẩy file `init_boot.img` từ máy tính vào điện thoại bằng lệnh:
```bash
adb push init_boot.img /sdcard/Download/
```
3. Mở ứng dụng **Magisk**, chọn **Install (Cài đặt)** > **Select and Patch a File**.
4. Chọn file `init_boot.img` trong thư mục Download và bấm **Let's Go**. 
5. Magisk sẽ tạo ra một file mới có dạng `magisk_patched-[...].img`.

### Bước 4: Flash file Root
1. Kéo file đã patch về lại máy tính (nhớ thay đúng tên file thực tế):
```bash
adb pull /sdcard/Download/magisk_patched-[chuỗi_ngẫu_nhiên].img
```
2. Đưa máy vào lại Fastboot:
```bash
adb reboot bootloader
```
3. Flash file vào phân vùng `init_boot`:
```bash
fastboot flash init_boot magisk_patched-[chuỗi_ngẫu_nhiên].img
```
4. Khởi động lại thiết bị:
```bash
fastboot reboot
```
5. Mở lại Magisk trên điện thoại, hoàn tất cài đặt bổ sung nếu được yêu cầu và bật **Zygisk** trong cài đặt.

---

## Phần 2: Cài đặt và Cấp quyền Device Owner

> **QUAN TRỌNG:** Để cấp quyền Device Owner, máy **KHÔNG ĐƯỢC CÓ BẤT KỲ TÀI KHOẢN NÀO**. Hãy vào *Cài đặt > Mật khẩu và tài khoản* và xóa toàn bộ tài khoản (Google, Mạng xã hội...) trước khi thực thi.

### Bước 1: Cài đặt APK qua ADB
Copy file APK của bạn (ví dụ: `app-dev-debug.apk`) vào chung thư mục `platform-tools`. Cài đặt nhanh bằng lệnh:
```bash
adb install app-dev-debug.apk
```

### Bước 2: Kích hoạt quyền Device Owner
Chạy lệnh sau để ép quyền quản trị thiết bị. Cần ghép đúng **Tên gói (Package Name)** và **Tên class Receiver** đã khai báo trong mã nguồn ứng dụng:
```bash
adb shell dpm set-device-owner com.example.android_rat/.MyDeviceAdminReceiver
```
*(Thay thế `com.example.android_rat/.MyDeviceAdminReceiver` bằng package và receiver thực tế của bạn)*

Nếu Terminal trả về **`Success: Device owner set...`**, thao tác đã thành công!

### Bước 3: Kiểm tra lại (Tùy chọn)
Để chắc chắn ứng dụng đã nắm quyền, chạy lệnh sau:
```bash
adb shell dumpsys device_policy | findstr "Device Owner"
```
Hoặc kiểm tra trực tiếp trên điện thoại tại **Cài đặt > Bảo mật và quyền riêng tư > Ứng dụng dành cho quản trị viên thiết bị**. Tại đây, ứng dụng Device Owner sẽ không thể tắt thanh trượt bằng tay.

Sau khi hoàn tất, bạn có thể đăng nhập lại các tài khoản cá nhân vào máy.