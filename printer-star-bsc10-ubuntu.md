#!/bin/bash

echo "=== BẮT ĐẦU CÀI ĐẶT DRIVER MÁY IN BSC10 (ESC/POS MODE) ==="

# 1. Cài đặt các thư viện cần thiết để biên dịch
echo "1/6: Đang cài đặt công cụ biên dịch và thư viện CUPS..."
sudo apt update
sudo apt install -y git gcc build-essential libcups2-dev libcupsimage2-dev

# 2. Tải bộ mã nguồn từ Github vào thư mục tạm
echo "2/6: Đang tải bộ mã nguồn zj-58..."
cd /tmp
rm -rf zj-58  # Xóa thư mục cũ nếu có
git clone https://github.com/klirichek/zj-58.git
cd zj-58

# 3. Biên dịch lõi chuyển đổi hình ảnh sang ESC/POS
echo "3/6: Đang biên dịch lõi rastertozj..."
gcc -Wall -fPIC -O3 -o rastertozj rastertozj.c -lcupsimage -lcups

# 4. Cài đặt file thực thi vào hệ thống
echo "4/6: Đưa lõi lọc vào hệ thống CUPS..."
sudo cp rastertozj /usr/lib/cups/filter/
sudo chmod +x /usr/lib/cups/filter/rastertozj

# 5. Phân quyền và cài đặt file cấu hình (PPD)
echo "5/6: Đang cấu hình file khổ giấy 80mm..."
sudo mkdir -p /usr/share/cups/model/zijiang
sudo cp zj80.ppd /usr/share/cups/model/zijiang/
sudo chmod 644 /usr/share/cups/model/zijiang/zj80.ppd

# 6. Tạo hàng đợi và mở khóa máy in
echo "6/6: Khai báo máy in Star_BSC10 với hệ thống..."
# Xóa máy in cũ nếu tồn tại (chặn thông báo lỗi nếu không có)
sudo lpadmin -x Star_BSC10 2>/dev/null

# Khai báo máy in mới
sudo lpadmin -p Star_BSC10 -E -v "usb://Star/BSC10%20(ESP-001)" -P /usr/share/cups/model/zijiang/zj80.ppd

# Đặt làm mặc định và kích hoạt
sudo lpoptions -d Star_BSC10
sudo cupsaccept Star_BSC10
sudo cupsenable Star_BSC10

echo "=== HOÀN TẤT! MÁY IN ĐÃ SẴN SÀNG ==="