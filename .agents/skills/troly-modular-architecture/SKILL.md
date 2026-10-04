---
name: troly-modular-architecture
description: Enforces file length (< 80 lines for Nix/QML, < 100 lines for C++), Atomic Micro-Modules, token conservation strategy, and FOSS licensing in bam-troly.
---

# Bam Trợ Lý Modular Architecture & Token Conservation Skill

Quy chuẩn kiến trúc vi mô và kỹ thuật tiết kiệm token AI tối đa khi làm việc trên **bam-troly**:

## 1. Triết Lý Atomic Micro-Modules
- **Ngưỡng trần giới hạn dòng (Strict Ceiling)**:
  - File QML, Nix, CMake: **TỐI ĐA < 80 dòng/file**. Khi đạt ~70 dòng, chủ động phân tách component con.
  - File mã nguồn C++ (`.hpp`, `.cpp`): **TỐI ĐA < 100 dòng/file**. Tách biệt structs, algorithms, workers.
- **Tính độc lập & Clean Architecture**:
  - Không gộp nhiều trách nhiệm vào một file duy nhất.
  - Tách bạch rõ 5 tầng: Presentation (QML/ViewModel), Workflow (Use cases), Plugins/Tools, Modules (Graphics, AI, DB), Core (Entities).

## 2. Chiến Lược Tiết Kiệm Token AI Tối Đa
- **Đọc chính xác (Targeted Reading)**:
  - Tra cứu cấu trúc file trong [AGENTS.md](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/AGENTS.md) trước khi đọc.
  - Sử dụng `grep_search` để định vị hàm/biến thay vì đọc tràn lan.
  - Luôn chỉ định `StartLine` và `EndLine` khi gọi `view_file`.
  - **Không bao giờ đọc**: `build/`, `.direnv/`, `.devenv/`, file `.gguf`, `.db`, thư viện bên thứ 3.
- **Chỉnh sửa vi phẫu (Surgical Edits)**:
  - Dùng `replace_file_content` hoặc `multi_replace_file_content` với chunk tối giản.
  - Tránh ghi đè toàn bộ file chỉ để sửa một vài dòng.

## 3. Tiêu Chuẩn 100% FOSS
- Toàn bộ thư viện, fonts, assets phải có giấy phép mã nguồn mở tự do (MIT, LGPLv3, Apache-2.0, SIL OFL).
- Tuyệt đối không tích hợp các thành phần đòi hỏi license thương mại hoặc đóng mã nguồn.
