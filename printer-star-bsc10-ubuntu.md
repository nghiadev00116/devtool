# 🖨️ Hướng dẫn cài đặt Driver máy in BSC10 trên Ubuntu

Đoạn script dưới đây giúp bạn cài đặt tự động driver máy in **Star BSC10 (ESC/POS Mode)**. Bạn có thể sao chép toàn bộ nội dung trong khung dưới đây, lưu thành một file `.sh` và chạy trực tiếp trên Terminal.

```bash
#!/bin/bash

echo "=== BẮT ĐẦU CÀI ĐẶT DRIVER MÁY IN BSC10 (ESC/POS MODE) ==="

# 1. Cài đặt các thư viện cần thiết để biên dịch
sudo apt update
sudo apt install -y git gcc build-essential libcups2-dev libcupsimage2-dev

# 2. Tải source (chỉ chạy 1 lần)
cd ~/Downloads
git clone https://github.com/klirichek/zj-58.git
cd zj-58

# 3. Tự build lõi lọc bằng gcc
gcc -Wall -fPIC -O3 -o rastertozj rastertozj.c -lcupsimage -lcups

# 4. Copy file thực thi vào CUPS
sudo cp rastertozj /usr/lib/cups/filter/
sudo chmod +x /usr/lib/cups/filter/rastertozj

# 5. Copy các file cấu hình PPD vào vùng an toàn của CUPS
sudo mkdir -p /usr/share/cups/model/zijiang
sudo cp *.ppd /usr/share/cups/model/zijiang/
sudo chmod 644 /usr/share/cups/model/zijiang/*.ppd

# 6. Khai báo máy in với đúng file zj80.ppd (viết thường)
sudo lpadmin -p Star_BSC10 -E -v "usb://Star/BSC10%20(ESP-001)" -P /usr/share/cups/model/zijiang/zj80.ppd

# 7. Thiết lập mặc định và mở khóa
sudo lpoptions -d Star_BSC10
sudo cupsaccept Star_BSC10
sudo cupsenable Star_BSC10
```