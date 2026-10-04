# Bam Trợ Lý (bam-troly) Architecture & Context Map

> **Dành cho AI Assistants (Gemini, Claude, GPT, Antigravity, Cursor, Zed):**
> Đọc tài liệu này trước để định tuyến trực tiếp đến đúng file cần sửa.
> Tuân thủ nghiêm ngặt **Clean Architecture, Atomic Micro-Modules (< 80 dòng/file QML/Nix, < 100 dòng/file C++)** và **Quy trình Refine/Reframe Prompt**.

## 1. Cơ Chế Bắt Buộc: Refine & Reframe Prompt Chuyên Gia Hàng Đầu
Mỗi khi nhận yêu cầu từ người dùng, AI Agent PHẢI:
1. **Đọc hiểu & Phân tích chuyên sâu**: Đóng vai trò Chuyên gia Hàng đầu Thế giới trong lĩnh vực liên quan để đối chuẩn công nghệ và giải pháp tối ưu.
2. **Refine & Reframe thành Kế hoạch chi tiết**: Trình bày dưới dạng User Story, phân rã công việc (Tasks), phạm vi tác động (Scope & Affected Components) và Tiêu chuẩn nghiệm thu (DoD).
3. **Cổng Xác Nhận (Confirmation Gate)**: BẮT BUỘC gửi kế hoạch chi tiết cho người dùng xem và xin xác nhận. Chỉ tiến hành sửa đổi mã nguồn hoặc can thiệp hệ thống sau khi nhận được sự đồng ý.

## 2. Directory Structure Map (Clean Architecture)

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
│   ├── core/                         # Domain Layer: Thực thể & Kiểu dữ liệu
│   │   ├── types.hpp                 # MessageRole, AgentStatus (< 30 dòng)
│   │   └── message.hpp               # Message struct entity (< 30 dòng)
│   ├── workflow/                     # Use Cases Layer: Quy trình & Hành vi
│   │   ├── agent_workflow.hpp        # ReAct Pipeline interface (< 40 dòng)
│   │   └── agent_workflow.cpp        # Điều phối Reasoning, Tool Call, Reply (< 45 dòng)
│   ├── plugins/                      # Plugins Layer: Mở rộng hành vi & Công cụ
│   │   ├── plugin_interface.hpp      # IAgentTool interface (< 20 dòng)
│   │   ├── tool_registry.hpp         # ToolRegistry header (< 30 dòng)
│   │   ├── tool_registry.cpp         # Quản lý & gọi tools (< 40 dòng)
│   │   └── builtins/                 # Các tools mặc định (System, Memory)
│   ├── modules/                      # Infrastructure Layer: Modules kỹ thuật
│   │   ├── ai/                       # AI Engine & Providers
│   │   │   ├── ai_provider.hpp       # IAIProvider interface (< 25 dòng)
│   │   │   ├── llama_engine.hpp      # llama.cpp RAII header (< 30 dòng)
│   │   │   └── llama_engine.cpp      # llama.cpp worker thread (< 60 dòng)
│   │   └── storage/                  # Lưu trữ CSDL
│   │       ├── db_manager.hpp        # SQLite3 WAL + FTS5 header (< 30 dòng)
│   │       └── db_manager.cpp        # SQLite3 queries & mutations (< 75 dòng)
│   └── presentation/                 # Presentation Layer: Controllers & ViewModel
│       ├── app_controller.hpp        # Qt ViewModel kết nối QML <-> Workflow (< 40 dòng)
│       └── app_controller.cpp        # Signals/slots & UI handlers (< 60 dòng)
└── qml/                              # UI Layer: Qt6 Quick (Clean Architecture)
    ├── Main.qml                      # Cửa sổ trong suốt, Frameless, DragHandler (< 80 dòng)
    ├── mascot/                       # Chức năng Linh vật & Hành vi (Mascot Feature)
    │   ├── DogMascotHost.qml         # Host kết nối tương tác và chuyển động Mascot (< 50 dòng)
    │   ├── parts/                    # Các bộ phận độc lập (Rig Parts)
    │   │   ├── DogEyes.qml           # Mắt lúng liếng, đảo mắt, chớp mắt, catchlight (< 75 dòng)
    │   │   ├── DogEars.qml           # Tai vểnh, tai mềm giật nhẹ/cụp khi ngủ (< 55 dòng)
    │   │   ├── DogMouth.qml          # Mõm, mũi đen và lưỡi hồng rung nhịp (< 50 dòng)
    │   │   ├── DogTail.qml           # Đuôi xoắn vẫy tốc độ cao uốn lượn (< 65 dòng)
    │   │   ├── DogTorso.qml          # Thân mình, ngực phồng, đốm lưng, chân trước (< 80 dòng)
    │   │   ├── DogNameTag.qml        # Bảng tên BamOS treo tự nhiên, thích ứng tư thế (< 75 dòng)
    │   │   ├── DogHeadAssembly.qml   # Lắp ráp hộp sọ, tai, mắt, mõm và má hồng (< 55 dòng)
    │   │   └── DogSideWalk.qml       # Chân chuyển động lúp xúp sang bên (< 65 dòng)
    │   └── behaviors/                # Quy trình & Luồng hành vi hoạt họa (Behaviors & Flows)
    │       ├── DogRigMascot.qml      # Điều phối chuyển động đa tầng 12 Disney (< 75 dòng)
    │       ├── BarkAnimationFlow.qml # Timeline sủa gâu (ngực phồng, ngửa đầu, co người) (< 45 dòng)
    │       ├── JumpBounceAnimationFlow.qml # Hoạt cảnh nhảy mừng rỡ cưng nựng (< 50 dòng)
    │       ├── PlayfulBehavior.qml   # Hành vi dơ chân ngẫu nhiên khi rảnh (< 40 dòng)
    │       ├── MascotInteractionController.qml # Quản lý Idle 3m/5m/10m & Wake (< 40 dòng)
    │       └── IntroRunner.qml       # Hoạt cảnh chạy từ mép màn hình vào (< 35 dòng)
    ├── chat/                         # Tính năng Khung Chat (Chat Feature)
    │   ├── FloatingChatWindow.qml    # Cửa sổ chat nổi bám dính tọa độ Mascot (< 60 dòng)
    │   ├── ChatWindow.qml            # Khung chat nổi 400x580 (< 60 dòng)
    │   ├── ChatHeader.qml            # Header ghim, thu nhỏ, đóng (< 70 dòng)
    │   ├── MessageList.qml           # Danh sách tin nhắn streaming (< 55 dòng)
    │   ├── MessageBubble.qml         # Bong bóng chat hỗ trợ code/markdown (< 75 dòng)
    │   ├── CodeBlockView.qml         # Hộp hiển thị code với nút copy (< 65 dòng)
    │   ├── CopyButton.qml            # Nút copy tiện lợi kèm tooltip (< 35 dòng)
    │   ├── ChatTooltip.qml           # Tooltip gọn gàng (< 25 dòng)
    │   └── PromptInput.qml           # Ô nhập liệu và nút gửi/dừng (< 70 dòng)
    ├── dialogs/                      # Hộp thoại tương tác (Dialogs)
    │   └── ConfirmDialog.qml         # Hộp thoại xác nhận đóng & xóa chat (< 60 dòng)
    └── common/                       # Thành phần dùng chung (Common UI Components)
        └── StatusIndicator.qml       # Đèn trạng thái AI Idle/Streaming (< 20 dòng)
```

## 3. Clean Architecture & Micro-Modules Rules
- **Ngưỡng trần giới hạn dòng (Strict Ceiling)**:
  - Mọi file Nix, QML, CMake: **TỐI ĐA < 80 dòng/file**. Khi đạt ~70 dòng, tách component nhỏ.
  - Mọi file mã nguồn C++ (`.hpp`, `.cpp`): **TỐI ĐA < 100 dòng/file**.
- **Strict FOSS & No Commercial License (100% Tự do)**:
  - Toàn bộ dependencies C++ và Qt6 đều phải là FOSS (LGPLv3, MIT, Apache-2.0).

## 4. UI & Floating Agent Invariants
- **Frameless, Transparent & Drag-and-Drop**:
  - Giao diện nền trong suốt (`color: "transparent"`), không viền, `Qt.WindowStaysOnTopHint`.
  - Hỗ trợ kéo thả tự do trên Wayland (BamOS) và Windows qua `DragHandler` + `startSystemMove()`.
  - Tự động co giãn mượt mà: Linh vật chờ <--> Khung chat / thông báo (400x580).
- **Bulkhead Pattern (Cô lập tài nguyên)**:
  - Tách hoàn toàn việc suy luận AI (`llama.cpp`) sang luồng nền (`std::jthread`).
  - Truyền token streaming qua Qt Signal/Slot (`Qt::QueuedConnection`) để UI luôn mượt 60fps.

## 5. Token Saving & Git Workflow
- **Bắt buộc đọc trước khi code**: [.agents/skills/troly-git-workflow/SKILL.md](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/.agents/skills/troly-git-workflow/SKILL.md).
- **Nhánh Git**: Mặc định phát triển trên `develop`. Nếu ở `main`, bắt buộc checkout sang `develop`. Tạo feature branch (`feat/troly-...`, `fix/...`, `refactor/...`) có xác nhận trong Refine & Reframe.
- **Versioning Standard**: `AA.BB.CC` (ví dụ: `v26.01.01`). Bắt buộc tăng `CC` khi có tính năng mới hoặc thay đổi kiến trúc lớn.
- **Commit theo What-Why-How**: Soạn thảo commit 3 phần (What, Why, How), `git add` và xin ý kiến xác nhận của người dùng trước khi commit.
- **Targeted Reading**: Sử dụng `grep_search` và `view_file` có `StartLine`/`EndLine`.
- **Không đọc**: `build/`, `.direnv/`, `.devenv/`, file nhị phân, model file `.gguf`, file `.db`.

## 6. Game Character Graphics Engine Invariants
- **Kỹ thuật đồ họa**: Xem chi tiết tại [.agents/skills/game-character-graphics/SKILL.md](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/.agents/skills/game-character-graphics/SKILL.md) và [.agents/rules/character_graphics_rules.md](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/.agents/rules/character_graphics_rules.md).
- **Skeletal & Hierarchical Transform**: Xây dựng nhân vật dựa trên cấu trúc xương và động lực học (Spring-Damper), cấm chắp vá DOM/Rectangle nguyên thủy phân mảnh.
- **Batching & Zero-Alloc**: Kết xuất tối đa <= 2 Draw Calls trên GPU, không cấp phát heap trong vòng lặp render/tick.

