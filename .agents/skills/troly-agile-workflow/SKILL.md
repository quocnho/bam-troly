---
name: troly-agile-workflow
description: Quy trình phối hợp Agile Scrum cho Solo Coder và AI Agent trên bam-troly. Quản lý ý tưởng (idea.md -> bk_idea.md), nhịp Sprint, DoD, và release milestone.
---

# Bam Trợ Lý Agile & Vibe Coding Workflow Skill

## 1. Phân Định Vai Trò
- **Solo Coder**: Product Owner & Lead Architect. Định hướng, duyệt kế hoạch, nghiệm thu.
- **AI Agent**: Senior Co-pilot & Enforcer. Kiểm soát trần dòng (<80 QML, <100 C++), tiết kiệm token, lập Compact Plan và thực thi vi phẫu.

## 2. Luồng Xử Lý Ý Tưởng
1. Tiếp nhận từ prompt hoặc `idea.md`.
2. Lập **Compact Confirmation Gate** (Mục tiêu, Branch, Tasks, Files, DoD).
3. Người dùng duyệt -> Lưu ý tưởng vào `bk_idea.md` (nếu từ `idea.md`), tạo branch và tiến hành code.

## 3. Tiêu Chuẩn Nghiệm Thu (DoD)
1. `troly build` thành công, không lỗi.
2. Trần dòng: <80 dòng (QML, Nix, CMake), <100 dòng (C++).
3. 60fps trên Wayland, 100% FOSS, không commit file rác/binary.
