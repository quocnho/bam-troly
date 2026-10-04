---
name: troly-modular-architecture
description: Thực thi trần dòng (<80 dòng QML/Nix, <100 dòng C++), kiến trúc vi mô và kỹ thuật phẫu thuật mã nguồn tiết kiệm token.
---

# Bam Trợ Lý Modular Architecture & Token Saver Skill

## 1. Trần Dòng Nghiêm Ngặt (Strict File Ceiling)
- **QML, Nix, CMake**: Tối đa **< 80 dòng/file**. Đạt ~70 dòng phải tách component con.
- **C++ (`.hpp`, `.cpp`)**: Tối đa **< 100 dòng/file**. Tách biệt structs, logic và workers.

## 2. Kỹ Thuật Tiết Kiệm Token Tuyệt Đối (Zero Token Waste)
- **Đọc Vi Phẫu (Targeted Slice Reading)**:
  - Tra cứu cấu trúc file trong [AGENTS.md](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/AGENTS.md) trước khi đọc.
  - Dùng `grep_search` để định vị hàm/biến thay vì đọc cả file.
  - BẮT BUỘC dùng `StartLine` và `EndLine` khi gọi `view_file` (đọc tối đa đúng đoạn cần sửa).
  - **CẤM đọc**: `build/`, `.direnv/`, `.devenv/`, `*.gguf`, `*.db`, thư viện bên thứ 3.
- **Sửa Vi Phẫu (Surgical Edits)**:
  - Dùng `replace_file_content` hoặc `multi_replace_file_content` cho các chunk nhỏ.
  - Tuyệt đối không ghi đè cả file lớn khi chỉ sửa vài dòng.
- **100% FOSS**: Chỉ dùng giấy phép mã nguồn mở tự do (MIT, LGPLv3, Apache-2.0).
