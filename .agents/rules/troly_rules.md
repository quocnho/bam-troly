# Bam Trợ Lý Agent Rules & Conventions

Quy tắc bắt buộc dành cho mọi AI Agent khi làm việc trong dự án **bam-troly**:

## 1. Giới Hạn Dòng (Strict Ceiling)
- **QML, Nix, CMake**: Tối đa **< 80 dòng/file**. Đạt ~70 dòng phải tách component con.
- **C++ (`.hpp`, `.cpp`)**: Tối đa **< 100 dòng/file**. Tách biệt structs, logic và workers.

## 2. Token-Saving & Targeted Reading
- Không đọc toàn bộ file dài; dùng `grep_search` và `view_file` với `StartLine`/`EndLine`.
- Cấm đọc file rác: `build/`, `.direnv/`, `.devenv/`, `*.gguf`, `*.db`.
- Tối giản phản hồi: Không nói dông dài, dùng khung Compact Plan ở [troly-prompt-refiner](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/.agents/skills/troly-prompt-refiner/SKILL.md).

## 3. Quy Trình Refine Prompt & Cổng Xác Nhận
- Tiếp nhận yêu cầu -> Lập kế hoạch kỹ thuật cô đọng (Compact Plan) -> Chờ người dùng xác nhận trước khi sửa mã nguồn.

## 4. Git Invariants
- Phát triển trên `develop` hoặc feature branch (`feat/troly-...`, `fix/...`, `refactor/...`). Không sửa trực tiếp trên `main`.
- Nâng `CC` (`vAA.BB.CC`) khi có tính năng/refactor lớn hoặc trước khi merge vào `main`.
- **CI/CD**: Chỉ trigger trên `main` hoặc release tag `v*` (không chạy trên `develop` / PRs).
- Chủ động `git add`, soạn commit What-Why-How và hỏi xác nhận từ người dùng trước khi commit.

## 5. UI & Architecture Invariants
- **Mô hình Surface**: Bắt buộc **Single Dynamic Window** (1 Native Window duy nhất, co giãn geometry linh hoạt). Cấm tạo nhiều Window con độc lập và cấm dùng Window fullscreen đục lỗ (input mask) để tránh lỗi Wayland input protocol và lãng phí VRAM.
- Nền trong suốt, frameless, `Qt.WindowStaysOnTopHint`, kéo thả bằng `DragHandler` + `startSystemMove()`.
- AI Inference (`llama.cpp`) chạy trên `std::jthread`, truyền token qua Qt Signal/Slot (non-blocking UI 60fps).
- Đồ họa nhân vật: Skeletal hierarchy, spring physics, Draw Calls <= 2.
- 100% FOSS: Giấy phép tự do (MIT, LGPLv3, Apache-2.0).

