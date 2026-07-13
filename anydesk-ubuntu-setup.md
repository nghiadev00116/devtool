# 🖥️ Hướng dẫn cài đặt Anydesk trên Ubuntu

Dưới đây là các lệnh cài đặt và cấu hình **Anydesk** trên hệ điều hành Ubuntu. Tài liệu này được chuẩn bị để bạn dễ dàng copy và thiết lập máy mới.

## 1. Cập nhật hệ thống và cài đặt gói phụ trợ
```bash
sudo apt update
sudo apt upgrade -y
sudo apt install ca-certificates curl gpg -y
```

## 2. Thêm khóa GPG và kho lưu trữ của Anydesk
```bash
curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmor --yes -o /usr/share/keyrings/anydesk.gpg

printf '%s\n' \
'Types: deb' \
'URIs: https://deb.anydesk.com' \
'Suites: all' \
'Components: main' \
'Signed-By: /usr/share/keyrings/anydesk.gpg' | sudo tee /etc/apt/sources.list.d/anydesk.sources > /dev/null

# Kiểm tra lại nội dung file source vừa tạo
cat /etc/apt/sources.list.d/anydesk.sources
```

## 3. Cài đặt Anydesk
```bash
sudo apt update
apt-cache policy anydesk
sudo apt install anydesk -y
```

## 4. Kiểm tra trạng thái hoạt động
```bash
dpkg -l anydesk | grep '^ii'
systemctl is-enabled anydesk
systemctl is-active anydesk
```

## 5. Tắt Wayland (Bắt buộc để Anydesk nhận diện chuột/bàn phím)
Ubuntu mặc định dùng Wayland, bạn cần tắt nó đi thì Anydesk mới hoạt động ổn định.

Mở file cấu hình bằng nano:
```bash
sudo nano /etc/gdm3/custom.conf
```

Tìm dòng có chữ `#WaylandEnable=false` và **bỏ dấu `#` ở đầu** (hoặc thêm dòng đó vào nếu chưa có), kết quả sẽ như sau:
```ini
WaylandEnable=false
```

Lưu lại file (Nhấn `Ctrl+O`, `Enter` rồi `Ctrl+X` để thoát nano), sau đó khởi động lại dịch vụ hiển thị (Lưu ý: lệnh này sẽ khiến máy lập tức đăng xuất):
```bash
sudo systemctl restart gdm3
```
