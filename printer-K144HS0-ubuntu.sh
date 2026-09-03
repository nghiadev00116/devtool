#!/bin/bash
#chmod +x setup_printer.sh
#./setup_printer.sh

echo "======================================================="
echo "   SCRIPT TỰ ĐỘNG CÀI ĐẶT MÁY IN BILL (ZJIANG 80mm)    "
echo "           (ĐÃ VÁ LỖI CHO UBUNTU PHIÊN BẢN MỚI)        "
echo "======================================================="

# 1. Cài đặt các thư viện lõi
echo "[1/7] Đang cập nhật hệ thống và cài đặt thư viện lõi..."
sudo apt-get update -y
sudo apt-get install -y build-essential cmake libcups2-dev libcupsimage2-dev git

# 2. Tải mã nguồn Driver từ GitHub
echo "[2/7] Đang tải mã nguồn driver máy in nhiệt..."
cd ~/Downloads
rm -rf zj-58 # Xóa thư mục cũ nếu đã từng tải
git clone https://github.com/klirichek/zj-58.git
cd zj-58

# 3. Vá lỗi tương thích cho CMake và GCC (Ubuntu 24/26)
echo "[3/7] Đang vá lỗi mã nguồn cho Ubuntu mới..."
sed -i 's/cmake_minimum_required(VERSION .*/cmake_minimum_required(VERSION 3.5)/' CMakeLists.txt
sed -i 's/void cancelJob() {/void cancelJob(int sig) {/' rastertozj.c

# 4. Biên dịch và cài đặt Driver vào hệ thống
echo "[4/7] Đang biên dịch driver..."
mkdir -p build && cd build
cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5
make
sudo make install

# 5. Khởi động lại dịch vụ in
echo "[5/7] Đang khởi động lại CUPS..."
sudo systemctl restart cups
sleep 3 # Dừng 3 giây để hệ thống kịp nhận diện cổng USB

# 6. Tự động dò tìm cổng USB của máy in
echo "[6/7] Đang dò tìm thiết bị máy in qua cổng USB..."
# Lệnh này sẽ quét và tự động trích xuất chuỗi URI bắt đầu bằng "usb://"
PRINTER_URI=$(lpinfo -v | grep -i "usb://" | awk '{print $NF}' | head -n 1)

if [ -z "$PRINTER_URI" ]; then
    echo "❌ LỖI: Không dò thấy máy in nào cắm qua cổng USB!"
    echo "Vui lòng kiểm tra lại cáp kết nối, bật nguồn máy in và chạy lại script."
    exit 1
fi
echo "=> Đã tìm thấy kết nối máy in tại: $PRINTER_URI"

# 7. Khởi tạo máy in và đặt mặc định
echo "[7/7] Đang khởi tạo cấu hình và đặt máy in mặc định..."

# Tự động cắt lấy tên gốc máy in từ URI (bỏ usb://, bỏ ?serial=, đổi %20 và / thành dấu _)
PRINTER_NAME=$(echo "$PRINTER_URI" | sed -E 's/usb:\/\///; s/\?.*//; s/%20/_/g; s/\//_/g')
echo "=> Tên máy in tự động nhận diện được: $PRINTER_NAME"

# Xóa máy in cũ nếu trùng tên để dọn dẹp hệ thống trước khi cài
sudo lpadmin -x $PRINTER_NAME 2>/dev/null

# Ép tạo máy in mới với Driver Zjiang 80mm (đã sửa chuẩn tên file zj80.ppd viết thường)
sudo lpadmin -p $PRINTER_NAME -v "$PRINTER_URI" -E -m zjiang/zj80.ppd

# Thiết lập làm máy in mặc định TOÀN HỆ THỐNG
sudo lpadmin -d $PRINTER_NAME

echo "======================================================="
echo "✅ HOÀN TẤT! HỆ THỐNG ĐÃ SẴN SÀNG ĐỂ IN HÓA ĐƠN."
echo "Tên máy in của bạn là: $PRINTER_NAME (Đã set Default System-wide)"
echo "======================================================="

#echo -e '--- TEST MAY IN ---\nDong 1: Ket noi USB thanh cong\nDong 2: Driver Zjiang hoat dong tot\nDong 3: San sang in hoa don!\n-------------------' | lp