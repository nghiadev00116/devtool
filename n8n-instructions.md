# Hướng dẫn sử dụng n8n self-host

Dưới đây là các lệnh và thông tin cấu hình cho n8n self-host của bạn:

## 1. Khởi động n8n
Lệnh khởi động n8n kèm cấu hình Webhook URL (sử dụng ngrok):

```bash
export WEBHOOK_URL="https://legal-moustache-security.ngrok-free.dev" && n8n start
```

## 2. Quản lý người dùng
Nếu cần thiết lập lại (reset) thông tin người dùng và mật khẩu, hãy chạy lệnh này:

```bash
npx n8n user-management:reset
```

## 3. Thông tin tài khoản
Sử dụng thông tin sau để đăng nhập vào giao diện n8n:

- **Email:** `nghiadev24h@gmail.com`
- **Password:** `Admin@123`
