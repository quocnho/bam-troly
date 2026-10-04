---
name: troly-git-workflow
description: Standard Git workflow, AA.BB.CC versioning enforcement, Conventional Commits (What-Why-How), and branch invariants for bam-troly repository.
---

# Bam Trợ Lý Git Workflow & Versioning Skill

> ⚠️ **MANDATORY PRE-ACTION PROTOCOL**:
> **Trước khi code, edit, delete hoặc add bất kỳ file nào, AI Agent BẮT BUỘC phải đọc kỹ năng này.**

---

## 1. Kiểm Soát Nhánh Nghiêm Ngặt (Branch Invariant)
- **Nhánh mặc định khi dev**: Luôn luôn là nhánh `develop`.
- **Phát hiện nhánh `main`**: Lập tức chuyển sang `develop` (`git checkout develop`), tuyệt đối không sửa trực tiếp trên `main`.
- **Tạo Branch tính năng**: Tạo branch từ `develop` (`feat/troly-...`, `fix/troly-...`, `refactor/troly-...`).
- **Đưa tên branch vào Refine & Reframe** để người dùng phê duyệt trước khi tạo.

---

## 2. Quy Chuẩn Nâng Phiên Bản (`AA.BB.CC`)
- **Định dạng**: `AA.BB.CC` (ví dụ `v26.01.01`).
- **BẮT BUỘC tăng `CC` (`CC += 1`)** khi: có tính năng mới (`feat`), tái cấu trúc lớn (`refactor`), hoặc chuẩn bị merge vào `main`.

---

## 3. Quy Trình Hoàn Thành: Git Add, Commit Gate & Branch Cleanup
Sau khi hoàn thành công việc:
1. **Kiểm tra trạng thái**: Chạy `git status -s`.
2. **Thực hiện `git add` trước khi commit**: Chủ động stage các file liên quan bằng lệnh `git add <files>`.
3. **Soạn thảo Commit Message theo mô hình What - Why - How**: Chuẩn bị nội dung commit chuyên nghiệp.
4. **CỔNG XÁC NHẬN COMMIT (Bắt buộc hỏi người dùng)**:
   > *"Tôi đã hoàn thành công việc và thực hiện `git add`. Bạn có muốn tôi commit các thay đổi này với thông điệp bên dưới không?"*
5. **CỔNG DỌN DẸP NHÁNH (Sau khi commit xong trên feature branch)**:
   > *"Công việc trên nhánh này đã hoàn thành và đã commit. Bạn có muốn checkout về `develop` và xóa nhánh này không?"*
   - Nếu người dùng đồng ý:
     ```bash
     git checkout develop
     git merge --no-ff <feature-branch>
     git branch -d <feature-branch>
     ```

---

## 4. Mô Hình Commit Chuyên Nghiệp: What - Why - How
```text
<type>(<scope>): <What - Tóm tắt ngắn gọn thay đổi>

Why:
- Giải thích bối cảnh, nguyên nhân hoặc lý do cần thực hiện thay đổi này.

How:
- Chi tiết phương pháp kỹ thuật, thuật toán hoặc module đã can thiệp.
```

---

## 5. Bảo Vệ Kho Chứa (Zero Bloat Invariant)
- Tuyệt đối không commit: `build/`, `.direnv/`, `.devenv/`, `*.gguf`, `*.db`, `*.swp`.
