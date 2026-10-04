---
name: troly-prompt-refiner
description: Tối ưu hoá prompt, lập kế hoạch kỹ thuật cô đọng (Compact Plan) & Cổng xác nhận (Gate Confirmation) trước khi code để tiết kiệm tối đa token.
---

# Bam Trợ Lý Token-Efficient Prompt Refiner Skill

Quy trình Refine & Reframe chuẩn hóa nhằm **tiết kiệm tối đa token AI**:

## 1. Nguyên Tắc Cốt Lõi: Zero-Fluff & High-Density
- Bỏ hoàn toàn văn phong chào mời, phân tích lý thuyết dài dòng.
- Tập trung vào: Mục tiêu, Luồng xử lý kỹ thuật, File tác động, Tiêu chí nghiệm thu.
- Luôn xin xác nhận (Confirmation Gate) trước khi can thiệp mã nguồn.

## 2. Khung Xuất Trình Tinh Gọn (Compact Confirmation Gate)
Mỗi phản hồi tiếp nhận yêu cầu từ người dùng BẮT BUỘC dùng khung mẫu siêu ngắn sau (tiết kiệm token):

```markdown
### 🎯 Mục Tiêu & Kế Hoạch Kỹ Thuật
- **Mục tiêu**: [1-2 câu ngắn gọn về tính năng/lỗi cần sửa]
- **Nhánh Git**: `develop` hoặc `feat/troly-...` / `fix/...`
- **Công việc**:
  1. [Task 1: Cụ thể, súc tích]
  2. [Task 2: Cụ thể, súc tích]
- **Tệp tác động**:
  - `file:///path/to/file1`
  - `file:///path/to/file2`
- **DoD**: Biên dịch `troly build` OK, <80 dòng QML, <100 dòng C++, 60fps.

> ⚠️ **Xác Nhận**: Bạn đồng ý kế hoạch trên không? (Gõ "OK" hoặc phản hồi để thực hiện).
```
