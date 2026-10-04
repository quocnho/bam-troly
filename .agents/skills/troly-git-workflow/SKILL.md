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
  - **`AA`**: 2 chữ số cuối năm (2026 -> `26`).
  - **`BB`**: Core Milestone (mặc định `01`).
  - **`CC`**: Đợt phát hành / Sprint.
- **BẮT BUỘC tăng `CC` (`CC += 1`)** khi: có tính năng mới (`feat`), tái cấu trúc lớn (`refactor`), hoặc chuẩn bị merge vào `main`.

---

## 3. Quy Trình Sau Hoàn Thành: Git Add, Commit & Cổng Xác Nhận
Sau khi hoàn thành code, kiểm thử hoặc sửa đổi:
1. **Kiểm tra trạng thái**: Chạy `git status -s` để rà soát file thay đổi.
2. **Stage file (`git add`)**: Chỉ add các file thuộc phạm vi tác vụ, không add bừa bãi.
3. **Soạn thảo Commit Message theo mô hình What - Why - How**: Chuẩn bị nội dung commit chuyên nghiệp.
4. **CỔNG XÁC NHẬN COMMIT (Bắt buộc hỏi người dùng)**:
   > *"Tôi đã hoàn thành công việc và chuẩn bị commit với thông điệp bên dưới. Bạn có muốn tôi thực hiện `git commit` ngay bây giờ không?"*
5. **Chỉ commit khi người dùng đồng ý**.

---

## 4. Mô Hình Commit Chuyên Nghiệp: What - Why - How
Mọi commit message phải tuân thủ nghiêm ngặt cấu trúc:

```text
<type>(<scope>): <What - Tóm tắt ngắn gọn thay đổi>

Why:
- Giải thích bối cảnh, nguyên nhân hoặc lý do cần thực hiện thay đổi này.
- Vấn đề gặp phải hoặc mục tiêu của người dùng/hệ thống là gì.

How:
- Chi tiết phương pháp kỹ thuật, thuật toán hoặc module đã can thiệp.
- Các quy chuẩn kiến trúc đã áp dụng (Clean Architecture, Micro-modules, DoD).
```

### Ví dụ Thực Chiến:
```text
feat(workflow): add git post-completion gate and what-why-how format

Why:
- Quy trình phát triển cần sự minh bạch và tránh tự ý commit ngoài tầm kiểm soát của lập trình viên.
- Cần ghi lại bối cảnh kỹ thuật rõ ràng để dễ tra cứu lịch sử Git Log.

How:
- Cập nhật troly-git-workflow bổ sung Cổng xác nhận Commit sau khi code xong.
- Định hình cấu trúc 3 phần: What (header), Why (lý do) và How (kỹ thuật thực thi).
```

---

## 5. Bảo Vệ Kho Chứa (Zero Bloat Invariant)
- Tuyệt đối không commit: `build/`, `.direnv/`, `.devenv/`, `*.gguf`, `*.db`, `*.swp`.
