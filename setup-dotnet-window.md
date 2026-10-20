# Hướng Dẫn Cài Đặt Môi Trường Làm Việc .NET Trên Windows

Tài liệu này cung cấp danh sách (checklist) các phần mềm và cấu hình cần thiết để thiết lập máy tính chạy hệ điều hành Windows cho một nhân sự mới ở vị trí **.NET Developer**.

## 1. Core Components (Bắt buộc)
- [ ] **.NET SDK & Runtime:** Tải và cài đặt phiên bản LTS mới nhất (VD: .NET 8) và phiên bản hiện hành (.NET 9) từ trang chủ Microsoft.
- [ ] **.NET Framework:** Mở *Turn Windows features on or off*, tích chọn bật **.NET Framework 3.5** và **4.8** (cần thiết cho các dự án legacy).
- [ ] **Global CLI Tools:** Mở PowerShell và chạy lệnh cài đặt Entity Framework CLI:
  `dotnet tool install --global dotnet-ef`

## 2. IDE & Editor
- [ ] **Visual Studio (Chính):** Cài đặt bản Professional hoặc Enterprise. 
  - *Workload bắt buộc:* ASP.NET and web development, .NET desktop development, Data storage and processing.
- [ ] **Visual Studio Code (Phụ trợ):** Cài đặt IDE nhẹ để mở file nhanh.
  - *Extensions thiết yếu:* C# Dev Kit, C# (Microsoft), NuGet Package Manager, GitLens, Prettier, Docker.
- [ ] **JetBrains Rider:** (Chỉ cài nếu công ty có cấp bản quyền thay thế cho Visual Studio).

## 3. Version Control & Terminal
- [ ] **Git for Windows:** Cài đặt Git mới nhất (đã bao gồm sẵn Git Bash).
- [ ] **Git GUI Client:** Cài đặt SourceTree, GitKraken, hoặc GitHub Desktop.
- [ ] **Windows Terminal:** Cài đặt từ Microsoft Store để quản lý nhiều tab (PowerShell, Command Prompt, Git Bash, WSL).
- [ ] **WSL2 (Windows Subsystem for Linux):** Mở PowerShell quyền Admin và chạy lệnh `wsl --install` (nếu dự án cần môi trường Linux/Docker).

## 4. Database Tools
- [ ] **SQL Server Tools:** Cài đặt **SSMS (SQL Server Management Studio)** để quản trị DB. Có thể cài thêm **Azure Data Studio**.
- [ ] **Hệ quản trị khác (PostgreSQL / MySQL):** Cài đặt **DBeaver** (Khuyên dùng) hoặc các tool chuyên dụng như pgAdmin / MySQL Workbench.
- [ ] **Local DB Service:** Cài đặt SQL Server Express / Developer Edition để dev chạy database trực tiếp trên máy (nếu không dùng Docker).

## 5. Ảo hóa, Test API & Tiện ích
- [ ] **Docker Desktop for Windows:** Cài đặt và trong phần Settings, đảm bảo đã bật **Use the WSL 2 based engine**.
- [ ] **API Client:** Cài đặt **Postman** hoặc **Insomnia**.
- [ ] **Tiện ích Windows:** Cài đặt 7-Zip, Notepad++, và Everything (công cụ tìm kiếm file siêu tốc).
- [ ] **Trình duyệt:** Google Chrome, Microsoft Edge (có sẵn).

## 6. Mạng, Bảo mật & Cấu hình hệ thống
- [ ] **VPN & Mạng:** Cài đặt phần mềm kết nối mạng nội bộ công ty (OpenVPN, FortiClient, Cisco AnyConnect...).
- [ ] **Chứng chỉ số (SSL/TLS Root CA):** Mở `certlm.msc`, import chứng chỉ nội bộ của công ty vào mục *Trusted Root Certification Authorities* để tránh lỗi SSL khi tải NuGet packages.
- [ ] **Phần mềm diệt virus / MDM:** Cài đặt phần mềm bảo mật theo đúng chính sách của phòng IT.
- [ ] **Phân quyền tài khoản:** Đảm bảo user Windows của Dev được cấp quyền **Local Administrator** để có thể cài gói NuGet toàn cục, sửa file hosts, và cấp quyền cho Docker.

---
> 💡 **Ghi chú trước khi bàn giao máy:**
> Hãy mở PowerShell và chạy thử các lệnh sau để đảm bảo hệ thống (Environment Variables PATH) đã nhận diện chính xác công cụ:
> `dotnet --info`
> `git --version`