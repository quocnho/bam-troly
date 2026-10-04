---
name: troly-git-workflow
description: Chuẩn Git workflow, AA.BB.CC versioning, What-Why-How commit và kiểm soát nhánh an toàn.
---

# Bam Trợ Lý Git Workflow & Versioning Skill

## 1. Kiểm Soát Nhánh
- **Nhánh mặc định**: Luôn ở `develop`. Thấy `main` -> chuyển ngay sang `develop`.
- **Feature branch**: `feat/troly-...`, `fix/...`, `refactor/...`. Xác nhận tên branch trong Refine Gate.

## 2. Nâng Phiên Bản (`AA.BB.CC`)
- Tăng `CC` (`vAA.BB.CC`) khi có tính năng mới (`feat`), tái cấu trúc lớn (`refactor`), hoặc trước khi merge vào `main`.

## 3. Hoàn Thành: Add, Commit Gate & Cleanup
1. `git status -s` & chủ động `git add <files>`.
2. Soạn commit What-Why-How:
```text
<type>(<scope>): <What>

Why:
- <Lý do>

How:
- <Giải pháp kỹ thuật>
```
3. **Cổng Xác Nhận**: Hỏi người dùng có duyệt commit thông điệp trên không.
4. **Dọn dẹp**: Hỏi người dùng có muốn checkout về `develop` và xóa feature branch không.
- Cấm commit: `build/`, `.direnv/`, `.devenv/`, `*.gguf`, `*.db`.
