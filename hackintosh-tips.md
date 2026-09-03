# Bí Kíp Hackintosh (OpenCore)

Dưới đây là các ghi chú, mẹo và cách sửa lỗi thường gặp khi cài đặt Hackintosh.

## 1. Các lỗi OpenCore thường gặp (Troubleshooting)

### Lỗi thiếu Vault
**Thông báo lỗi:**
```text
oc: configuration requires vault but no vault provided!
```
**Cách khắc phục:** 
Mở file `config.plist`, tìm đến mục `Misc` -> `Security` -> `Vault` và đổi giá trị thành `Optional`.

### Lỗi System-ID (Secure Boot)
**Thông báo lỗi:**
```text
oc: grabbed zero system-id for SB, this is not allowed Halting on critical error
```
**Cách khắc phục:** 
Lỗi này liên quan đến Secure Boot hoặc SMBIOS. Hãy kiểm tra lại phần `PlatformInfo` > `Generic` xem đã tạo System UUID chưa. Ngoài ra, bạn cũng có thể thử đổi `SecureBootModel` (nằm trong `Misc` -> `Security`) thành `Disabled`.

## 2. Boot Arguments (Tham số Boot) quan trọng

- `igfxonln=1` : Tham số này giúp ép hệ thống luôn nhận diện màn hình được kết nối với iGPU (Card đồ họa tích hợp). Rất hữu ích để sửa lỗi "màn hình đen" (Black Screen) hoặc rớt tín hiệu xuất hình trên một số dòng máy.

## 3. Tài nguyên & Link tải EFI
- [Kho EFI Folders build sẵn (Olarila)](https://olarila.com/topic/25111-hackintosh-efi-folders-with-opencore-mod/): Nơi chia sẻ các bộ EFI OpenCore Mod sẵn cho nhiều cấu hình máy tính khác nhau (Desktop, Laptop, chipset thế hệ cũ/mới).
