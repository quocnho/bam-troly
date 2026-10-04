---
name: troly-agile-workflow
description: Quy trình phối hợp Agile Scrum cho Solo Coder và AI Agent trên bam-troly. Quản lý ý tưởng (idea.md -> bk_idea.md), nhịp Sprint, DoD, và release milestone.
---

# Bam Trợ Lý Agile & Vibe Coding Workflow Skill

Kỹ năng phối hợp theo phương pháp Agile Scrum giữa Solo Coder và AI Agent trong dự án **bam-troly**:

## 1. Phân Định Vai Trò
- **Solo Coder**: Product Owner & Lead Architect. Định hướng kiến trúc, phê duyệt kế hoạch, nghiệm thu sản phẩm.
- **AI Agent**: Scrum Master & Senior Co-pilot. Kiểm soát tiêu chuẩn DoD, cập nhật sprint, kiểm soát trần dòng file (<80 QML/Nix, <100 C++), đảm bảo tính toàn vẹn hệ thống.

## 2. Quy Trình Refine Ý Tưởng & Git Branching
1. **Tiếp nhận**: Đọc yêu cầu từ chat hoặc `idea.md`.
2. **Refine & Reframe**:
   - Bóc tách User Story, Task kỹ thuật, Scope tác động.
   - **Xác định Git branch mục tiêu** (`feat/troly-...`, `fix/troly-...`, `refactor/troly-...`).
   - Đánh giá có cần nâng chỉ số `CC` của phiên bản (`vAA.BB.CC`) hay không.
3. **Cổng Xác Nhận (Gate)**: Trình bày kế hoạch chi tiết kèm tên branch và đợi xác nhận.
4. **Lưu trữ & Triển khai**: Sau xác nhận, chuyển ý tưởng đã duyệt vào `bk_idea.md` (nếu có từ `idea.md`), tạo branch và tiến hành code.

## 3. Tiêu Chuẩn Nghiệm Thu (Definition of Done - DoD)
1. **Biên dịch**: `cmake --build build` thành công, không cảnh báo hay lỗi cú pháp.
2. **Kiến trúc Micro-module**: < 80 dòng/file (QML, Nix, CMake), < 100 dòng/file (C++).
3. **Hiệu năng**: 60fps trên Wayland/BamOS, Draw Calls <= 2, Zero-Alloc trong render loop.
4. **Git Branch & Bloat**: Code trên đúng feature branch hoặc `develop`, không commit file rác (`build/`, `.db`, `.gguf`).
