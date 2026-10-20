import base64
import getpass

# ==========================================
# TOOL BẢO MẬT 6 LỚP - CÔNG THỨC LÕI CỦA ANH NGHĨA
# 6 số key và chuỗi xử lý được NHẬP KHI CHẠY, không lưu cứng trong file.
# (Tránh để lộ cả key lẫn chuỗi mã hóa cùng một chỗ khi đẩy lên GitHub.)
# ==========================================

def generate_shift(index, a, b, c, x, y, z):
    # Công thức: [ ( (a * index) + b - c ) * x ] // y + z
    return (((a * index) + b - c) * x) // y + z

def encode_text(text, a, b, c, x, y, z):
    text_bytes = text.encode('utf-8')
    shifted_bytes = bytearray()
    for i, byte in enumerate(text_bytes):
        shift = generate_shift(i, a, b, c, x, y, z)
        shifted_bytes.append((byte + shift) % 256)
    return base64.b64encode(shifted_bytes).decode('utf-8')

def decode_text(encoded_text, a, b, c, x, y, z):
    try:
        shifted_bytes = base64.b64decode(encoded_text)
        original_bytes = bytearray()
        for i, byte in enumerate(shifted_bytes):
            shift = generate_shift(i, a, b, c, x, y, z)
            original_bytes.append((byte - shift) % 256)
        return original_bytes.decode('utf-8')
    except Exception as e:
        return f"Lỗi giải mã! Có thể sai 1 trong 6 số hoặc sai chuỗi. (Chi tiết: {e})"

def nhap_6_so():
    print("Nhập 6 số bí mật (key) của bạn:")
    while True:
        try:
            a = int(input("  A = "))
            b = int(input("  B = "))
            c = int(input("  C = "))
            x = int(input("  X = "))
            y = int(input("  Y = "))
            z = int(input("  Z = "))
        except ValueError:
            print("  -> Vui lòng chỉ nhập số nguyên. Thử lại.\n")
            continue
        if y == 0:
            print("  -> Số 'Y' không được bằng 0 (tránh lỗi chia cho 0). Thử lại.\n")
            continue
        return a, b, c, x, y, z

if __name__ == "__main__":
    print("=== TOOL BẢO MẬT 6 LỚP ===")
    print("1: Mã hóa (Giấu mật khẩu)")
    print("2: Giải mã (Lấy lại mật khẩu)")
    chuc_nang = input("Chọn chức năng (1/2): ").strip()

    if chuc_nang == "1":
        mat_khau = getpass.getpass("Nhập mật khẩu cần giấu (gõ ẩn): ")
        keys = nhap_6_so()
        print(f"\n[+] Chuỗi an toàn để lưu công khai:\n{encode_text(mat_khau, *keys)}")

    elif chuc_nang == "2":
        chuoi = input("Dán chuỗi cần giải mã: ").strip()
        keys = nhap_6_so()
        print(f"\n[+] Mật khẩu gốc của bạn là:\n{decode_text(chuoi, *keys)}")

    else:
        print("\nLỗi: Lựa chọn không hợp lệ. Vui lòng chạy lại và nhập 1 hoặc 2.")
