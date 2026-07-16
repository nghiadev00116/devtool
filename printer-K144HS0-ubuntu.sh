#!/bin/bash
#chmod +x setup_printer.sh
#./setup_printer.sh

echo "======================================================="
echo "   SCRIPT TỰ ĐỘNG CÀI ĐẶT MÁY IN BILL (ZJIANG 80mm)    "
echo "======================================================="

# 1. Cài đặt các thư viện lõi
echo "[1/6] Đang cập nhật hệ thống và cài đặt thư viện lõi..."
sudo apt-get update -y
sudo apt-get install -y build-essential cmake libcups2-dev libcupsimage2-dev git

# 2. Tải và biên dịch Driver Zjiang từ mã nguồn
echo "[2/6] Đang tải và biên dịch Driver máy in nhiệt..."
cd /tmp
rm -rf zj-58 # Xóa thư mục cũ nếu đã từng tải
git clone https://github.com/klirichek/zj-58.git
cd zj-58
mkdir build && cd build
cmake ..
make
sudo make install

# 3. Khởi động lại dịch vụ in
echo "[3/6] Đang khởi động lại CUPS..."
sudo systemctl restart cups
sleep 3 # Dừng 3 giây để hệ thống kịp nhận diện cổng USB

# 4. Tự động dò tìm cổng USB của máy in
echo "[4/6] Đang dò tìm thiết bị máy in qua cổng USB..."
# Lệnh này sẽ quét và tự động trích xuất chuỗi URI bắt đầu bằng "usb://"
PRINTER_URI=$(lpinfo -v | grep -i "usb://" | awk '{print $NF}' | head -n 1)

if [ -z "$PRINTER_URI" ]; then
    echo "❌ LỖI: Không dò thấy máy in nào cắm qua cổng USB!"
    echo "Vui lòng kiểm tra lại cáp kết nối, bật nguồn máy in và chạy lại script."
    exit 1
fi
echo "=> Đã tìm thấy kết nối máy in tại: $PRINTER_URI"

# 5. Khởi tạo máy in và gắn Driver
echo "[5/6] Đang khởi tạo cấu hình máy in..."

# Tự động cắt lấy tên gốc máy in từ URI (bỏ usb://, bỏ ?serial=, đổi %20 và / thành dấu _)
PRINTER_NAME=$(echo "$PRINTER_URI" | sed -E 's/usb:\/\///; s/\?.*//; s/%20/_/g; s/\//_/g')
echo "=> Tên máy in tự động nhận diện được: $PRINTER_NAME"

# Xóa máy in cũ nếu trùng tên để dọn dẹp hệ thống trước khi cài
sudo lpadmin -x $PRINTER_NAME 2>/dev/null

# Ép tạo máy in mới với Driver Zjiang 80mm (đã sửa chuẩn tên file zj80.ppd viết thường)
sudo lpadmin -p $PRINTER_NAME -v "$PRINTER_URI" -E -m zjiang/zj80.ppd

# 6. Đặt máy in mặc định TOÀN HỆ THỐNG (System-wide Default)
echo "[6/6] Đang thiết lập làm máy in mặc định..."
# Lệnh lpadmin -d sẽ cấu hình mặc định ở cấp độ root, mọi app đều sẽ nhận diện
sudo lpadmin -d $PRINTER_NAME

echo "======================================================="
echo "✅ HOÀN TẤT! HỆ THỐNG ĐÃ SẴN SÀNG ĐỂ IN HÓA ĐƠN."
echo "Tên máy in của bạn là: $PRINTER_NAME (Đã set Default System-wide)"
echo "======================================================="