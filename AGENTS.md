# Bam Trợ Lý (bam-troly) Architecture & Context Map

> **Chỉ thị AI Assistant:**
> Đọc tài liệu này để định tuyến file. Tuân thủ **Clean Architecture, Micro-Modules (< 80 dòng QML/Nix, < 100 dòng C++)**, **Refine Prompt siêu ngắn gọn** và **Targeted Reading** để tiết kiệm tối đa token.

## 1. Cổng Xác Nhận Siêu Ngắn Gọn (Compact Confirmation Gate)
- Lập kế hoạch ngắn gọn (Mục tiêu, Nhánh Git, Tasks, Affected Files, DoD) theo [.agents/skills/troly-prompt-refiner/SKILL.md](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/.agents/skills/troly-prompt-refiner/SKILL.md).
- BẮT BUỘC chờ người dùng xác nhận trước khi sửa mã nguồn.

## 2. Directory Structure Map

```text
bam-troly/
├── devenv.nix                        # Môi trường Nix (C++20, Qt6, CMake, llama-cpp) (< 40 dòng)
├── CMakeLists.txt                    # Build configuration C++20 / Qt6 (< 80 dòng)
├── AGENTS.md                         # Bản đồ kiến trúc & quy tắc AI Agent
├── README.md                         # Tổng quan dự án & hướng dẫn chạy
├── bk_idea.md                        # Lịch sử ý tưởng đã chuẩn hóa
├── idea.md                           # Quick Idea Capture
├── .agents/                          # Quy tắc & Kỹ năng AI tích hợp
│   ├── rules/troly_rules.md          # Bộ quy tắc cốt lõi cho Agent
│   └── skills/                       # Kỹ năng định tuyến, AI resilience, reframing
├── src/
│   ├── main.cpp                      # Khởi tạo QGuiApplication & QML Engine (< 40 dòng)
│   ├── core/                         # Domain: Types & Message entities (< 30 dòng)
│   ├── workflow/                     # Use Cases: ReAct agent workflow (< 45 dòng)
│   ├── plugins/                      # Plugins: Tool registry & builtins (< 40 dòng)
│   ├── modules/                      # Infra: ai (llama.cpp) & storage (sqlite3) (< 75 dòng)
│   └── presentation/                 # ViewModel: app_controller (< 60 dòng)
└── qml/                              # UI Layer: Qt6 Quick (Clean Architecture)
    ├── Main.qml                      # Nền trong suốt, Frameless, DragHandler (< 80 dòng)
    ├── mascot/                       # Mascot parts, behaviors, rigging, action bar (< 80 dòng)
    ├── chat/                         # Floating chat, code block, bubbles, header (< 80 dòng)
    ├── dialogs/                      # Hộp thoại xác nhận (< 60 dòng)
    └── common/                       # Đèn trạng thái & UI dùng chung (< 30 dòng)
```

## 3. Bất Biến Kỹ Thuật (Engineering Invariants)
- **Trần dòng**: < 80 dòng/file (QML, Nix, CMake), < 100 dòng/file (C++).
- **Tiết kiệm token**: Dùng `grep_search` và `view_file` có `StartLine`/`EndLine`. Không đọc file rác/binary.
- **Git**: Phát triển trên `develop` hoặc feature branch. Bump `CC` (`vAA.BB.CC`) khi có tính năng/refactor lớn. Stage bằng `git add` và xin ý kiến xác nhận commit.
- **UI & AI**: Frameless, kéo thả Wayland, `llama.cpp` tách riêng luồng `std::jthread`, UI 60fps, 100% FOSS.
