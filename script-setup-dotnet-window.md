# Script Cài Đặt Môi Trường .NET Developer Trên Windows

Script PowerShell này giúp bạn tự động hóa việc cài đặt toàn bộ môi trường làm việc cho một .NET Developer trên Windows mới (bao gồm SDK, IDE, Database tools, và các tiện ích cần thiết).

## Cách sử dụng

1. Mở **PowerShell** với quyền **Administrator** (Click chuột phải vào biểu tượng Windows (Start) > chọn **Windows PowerShell (Admin)** hoặc **Terminal (Admin)**).
2. Nhấn vào nút **Copy** (biểu tượng sao chép) ở góc trên bên phải của khối code bên dưới.
3. Dán (Paste) toàn bộ đoạn script vào cửa sổ PowerShell và nhấn `Enter`.
4. Đợi quá trình tự động tải và cài đặt hoàn tất, sau đó **Khởi động lại máy tính**.

## Script tự động (Copy toàn bộ)

```powershell
# Kiểm tra quyền Administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "LỖI: Vui lòng click chuột phải vào PowerShell chọn 'Run as Administrator' để chạy lệnh này!" -ForegroundColor Red
    Break
}

Write-Host "=========================================================" -ForegroundColor Green
Write-Host "BẮT ĐẦU CÀI ĐẶT MÔI TRƯỜNG .NET DEVELOPER TỪ A-Z" -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green

# 1. Bật .NET Framework 3.5 (Dành cho các dự án legacy cũ)
Write-Host "`n[1/6] Đang kích hoạt .NET Framework 3.5..." -ForegroundColor Cyan
Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -All -NoRestart

Write-Host "`nĐang làm mới nguồn tải winget (để tránh lỗi khi tải các package)..." -ForegroundColor Cyan
winget source reset --force
winget source update

# 2. Cài đặt các phiên bản .NET SDK cốt lõi & Node.js
Write-Host "`n[2/6] Đang tải và cài đặt .NET 8, .NET 9 SDK & Node.js..." -ForegroundColor Cyan
winget install Microsoft.DotNet.SDK.8 -e --accept-package-agreements --accept-source-agreements
winget install Microsoft.DotNet.SDK.9 -e --accept-package-agreements --accept-source-agreements
winget install OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements

# 3. Cài đặt Terminal, Version Control và IDE (Kèm Workload ASP.NET & Desktop)
Write-Host "`n[3/6] Đang cài đặt Git, Terminal, VS Code và Visual Studio 2022 Pro (Tự động tải Workload)..." -ForegroundColor Cyan
winget install Git.Git -e --accept-package-agreements --accept-source-agreements
winget install Microsoft.WindowsTerminal -e --accept-package-agreements --accept-source-agreements
winget install GUIClientForGit.SourceTree -e --accept-package-agreements --accept-source-agreements
winget install Microsoft.VisualStudioCode -e --accept-package-agreements --accept-source-agreements
winget install Microsoft.VisualStudio.2022.Professional -e --accept-package-agreements --accept-source-agreements --override "--passive --norestart --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.ManagedDesktop"

# 4. Cài đặt Công cụ quản trị Database
Write-Host "`n[4/6] Đang cài đặt SSMS & DBeaver..." -ForegroundColor Cyan
winget install Microsoft.SQLServerManagementStudio -e --accept-package-agreements --accept-source-agreements
winget install dbeaver.dbeaver -e --accept-package-agreements --accept-source-agreements

# 5. Cài đặt Ảo hóa, Test API & Tiện ích
Write-Host "`n[5/6] Đang cài đặt Docker, Postman, 7-Zip, Notepad++, Everything..." -ForegroundColor Cyan
winget install Docker.DockerDesktop -e --accept-package-agreements --accept-source-agreements
winget install Postman.Postman -e --accept-package-agreements --accept-source-agreements
winget install 7zip.7zip -e --accept-package-agreements --accept-source-agreements
winget install Notepad++.Notepad++ -e --accept-package-agreements --accept-source-agreements
winget install voidtools.Everything -e --accept-package-agreements --accept-source-agreements

# 6. Cài đặt Global Tool & WSL
Write-Host "`n[6/6] Đang cài đặt Entity Framework CLI và Kích hoạt WSL..." -ForegroundColor Cyan

# Làm mới biến môi trường PATH cho phiên PowerShell hiện tại
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Kiểm tra xem dotnet-ef đã được cài chưa
$efInstalled = dotnet tool list --global | Select-String -Pattern "dotnet-ef" -Quiet
if ($efInstalled) {
    Write-Host "=> dotnet-ef đã được cài đặt sẵn, bỏ qua!" -ForegroundColor Yellow
} else {
    # Chạy lệnh cài đặt dotnet tool nếu chưa có
    dotnet tool install --global dotnet-ef
}

Write-Host "`nĐang kích hoạt môi trường WSL (Windows Subsystem for Linux)..." -ForegroundColor Cyan
wsl --install --no-distribution

Write-Host "`n=========================================================" -ForegroundColor Green
Write-Host "CÀI ĐẶT HOÀN TẤT! VUI LÒNG KHỞI ĐỘNG LẠI MÁY TÍNH (RESTART)." -ForegroundColor Yellow
Write-Host "Lưu ý: Visual Studio đã được cài sẵn Workload Web và Desktop. Nếu cần thêm công cụ khác, hãy mở Visual Studio Installer." -ForegroundColor Yellow
Write-Host "=========================================================" -ForegroundColor Green
```
