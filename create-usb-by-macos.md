# Hướng dẫn tạo USB cài đặt Windows 10/11 trên macOS

Hướng dẫn này giúp bạn tạo USB boot Windows chuẩn UEFI trên macOS, giải quyết vấn đề file `install.wim` có dung lượng lớn hơn 4GB không thể copy vào USB định dạng FAT32.

## Yêu cầu chuẩn bị
- Một USB dung lượng tối thiểu 8GB.
- File ISO cài đặt Windows 10 hoặc 11.
- Cài đặt công cụ `wimlib` qua Homebrew (để chia nhỏ file `.wim`):
  ```bash
  brew install wimlib
  ```

## Các bước thực hiện

**Bước 1: Tìm ID của USB**
Cắm USB vào máy Mac và chạy lệnh sau để liệt kê các ổ đĩa. Tìm và ghi nhớ ID của USB (ví dụ: `disk2`, `disk3`...):
```bash
diskutil list
```

**Bước 2: Format USB sang định dạng FAT32**
Tiến hành xoá và format USB. *Lưu ý quan trọng: Thay `diskX` bằng ID USB của bạn (ví dụ: `disk2`). Việc chọn sai ổ có thể gây mất dữ liệu trên máy.*
```bash
diskutil eraseDisk MS-DOS "WIN10" MBR /dev/diskX
```

**Bước 3: Mount file ISO Windows ra ổ đĩa ảo**
Chỉnh sửa lại đường dẫn trỏ tới file ISO Windows mà bạn đã tải về ở lệnh dưới đây:
```bash
hdiutil mount /Users/nghialeegu/Downloads/Win10_22H2_English_x64v1.iso
```

**Bước 4: Copy dữ liệu sang USB**
Sử dụng `rsync` để copy toàn bộ dữ liệu, ngoại trừ file `install.wim` do giới hạn 4GB của định dạng FAT32:
```bash
rsync -vha --exclude=sources/install.wim /Volumes/CCCOMA_X64FRE_EN-US_DV9/ /Volumes/WIN10
```
*(Chú ý: Thay `/Volumes/CCCOMA_X64FRE_EN-US_DV9/` bằng tên ổ ảo Windows ISO của bạn hiển thị sau khi thực hiện bước 3)*

**Bước 5: Tạo thư mục `sources` trên USB**
```bash
mkdir -p /Volumes/WIN10/sources
```

**Bước 6: Chia nhỏ và copy file `install.wim` vào USB**
Sử dụng `wimlib` để cắt file `install.wim` thành các phần nhỏ (3.8GB) và chép trực tiếp vào thư mục `sources` trên USB:
```bash
wimlib-imagex split /Volumes/CCCOMA_X64FRE_EN-US_DV9/sources/install.wim /Volumes/WIN10/sources/install.swm 3800
```
*(Chú ý: Quá trình này sẽ tốn một ít thời gian. Hãy kiên nhẫn chờ đến khi hoàn tất là bạn đã có một chiếc USB cài Windows sẵn sàng sử dụng!)*