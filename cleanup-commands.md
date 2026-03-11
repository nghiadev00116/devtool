# 🧹 Bí Kíp Dọn Dẹp Ổ Cứng (MacBook SSD Cleanup)

Tổng hợp các lệnh dọn dẹp không gian lưu trữ, tối ưu cho môi trường Dev (AI, Docker, Node.js, Python...).

---

## 🤖 1. Dọn dẹp AI Models (Hugging Face)
Các model AI tải về thường nằm ở `~/.cache/huggingface/hub`.

```bash
# Quét và xóa model qua giao diện terminal (Dùng mũi tên và Space để chọn)
hf cache delete

# Xóa ở chế độ thủ công (Nếu lệnh trên báo lỗi TUI)
hf cache delete --disable-tui
```

## 🐳 2. Dọn dẹp Docker
Giải phóng hàng chục GB từ các image và container không còn sử dụng.

```bash
# Xem thống kê Docker đang chiếm bao nhiêu GB
docker system df

# Dọn dẹp an toàn (Xóa container đã dừng, cache, network rác)
docker system prune

# Dọn dẹp mạnh tay (Xóa TOÀN BỘ image không gắn với container đang chạy)
docker system prune -a

# Xóa Volumes (Ổ cứng ảo mồ côi - Cẩn thận nếu có data quan trọng)
docker volume prune

# 💥 Lệnh dọn dẹp tất tay (Xóa cả image và volume rác)
docker system prune -a --volumes
```

## 🐍 3. Dọn dẹp Python & Conda
Dọn dẹp các file cài đặt dự phòng của môi trường Python.

```bash
# Dọn sạch package rác và cache của Conda (Miniconda/Anaconda)
conda clean --all

# Xóa các file tải tạm của pip
pip cache purge
```

## 🌐 4. Dọn dẹp Node.js & Web Projects
Tiêu diệt các "hố đen" node_modules ở các dự án cũ.

```bash
# Xóa bộ nhớ đệm của npm
npm cache clean --force

# Quét toàn bộ ổ cứng để tìm và xóa các thư mục node_modules (Dùng phím Space để xóa)
npx npkill
```

## 🍏 5. Dọn dẹp macOS System & Tools
Dọn dẹp bộ nhớ đệm hệ thống và các công cụ khác.

```bash
# Xóa các bản cài đặt cũ của Homebrew
brew cleanup

# 🔍 Quét toàn bộ máy Mac để tìm thư mục nặng nhất
ncdu ~
```

### Mẹo dùng ncdu:
- `[Mũi tên Lên/Xuống]`: Di chuyển
- `[Enter]`: Đi sâu vào thư mục
- `[Mũi tên Trái]`: Quay ra ngoài
- `[Phím d]`: Xóa thư mục/file đang chọn
- `[Phím q]`: Thoát

> **Lưu ý:** Nên chạy định kỳ 1-2 tháng/lần để ổ cứng luôn có không gian thở!
