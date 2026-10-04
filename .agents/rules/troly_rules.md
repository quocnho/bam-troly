# Bam Trợ Lý Agent Rules & Conventions

Quy tắc bắt buộc dành cho mọi AI Agent (Gemini, Claude, GPT, Antigravity, Cursor, Zed) khi làm việc trong dự án **bam-troly**:

## 1. Cơ Chế Bắt Buộc: Git Workflow & An Toàn Nhánh
- **Đọc kỹ năng trước khi code**: BẮT BUỘC đọc [.agents/skills/troly-git-workflow/SKILL.md](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/.agents/skills/troly-git-workflow/SKILL.md).
- **Kiểm tra nhánh**: Luôn phát triển trên `develop` hoặc feature branch (`feat/troly-...`, `fix/...`, `refactor/...`). Nếu ở `main`, lập tức chuyển sang `develop`.
- **Tạo branch có xác nhận**: Đưa tên branch vào bản Refine & Reframe để người dùng duyệt trước khi tạo.
- **Quy chuẩn Bump Version**: Nâng chỉ số `CC` (`vAA.BB.CC`) khi có tính năng mới hoặc cấu trúc lớn.
- **Git Add & Commit Gate**: Chủ động `git add` trước khi commit, soạn thảo commit What-Why-How và hỏi xác nhận từ người dùng.
- **Branch Cleanup Gate**: Sau khi commit trên feature branch, hỏi người dùng có muốn checkout về `develop` và xóa nhánh không.

## 2. Quy Trình Refine & Reframe Prompt (Top-tier Domain Expert)
- **Đọc hiểu & Phân tích chuyên sâu**: Đóng vai trò Chuyên gia Hàng đầu Thế giới trong lĩnh vực liên quan để đối chuẩn công nghệ.
- **Refine & Reframe thành Kế hoạch chi tiết**: Tuân thủ [.agents/skills/troly-prompt-refiner/SKILL.md](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/.agents/skills/troly-prompt-refiner/SKILL.md) với User Story, Task Matrix, Scope tác động và DoD.
- **Cổng Xác Nhận Bắt Buộc**: Chờ người dùng xác nhận kế hoạch trước khi chỉnh sửa mã nguồn.

## 3. Giới Hạn Dòng Mã Nguồn (Strict Ceiling)
- **File Nix, QML, CMake**: Tối đa **< 80 dòng/file**. Khi đạt ~70 dòng, chủ động tách component con.
- **File C++ (`.hpp`, `.cpp`)**: Tối đa **< 100 dòng/file**. Tách nhỏ class, helpers, workers.
- **Tuyệt đối không gộp**: Giữ nguyên tính độc lập của từng bộ phận (Parts, Behaviors, Views, Controllers).

## 4. Bản Quyền & Triết Lý Phần Mềm Tự Do (Strict 100% FOSS)
- Chỉ sử dụng các thư viện, component, fonts có giấy phép mã nguồn mở tự do (MIT, LGPLv3, Apache-2.0, SIL OFL).

## 5. UI Invariants & Bulkhead Architecture
- Cửa sổ trong suốt, frameless, `Qt.WindowStaysOnTopHint`, kéo thả qua `DragHandler` + `startSystemMove()`.
- Tách biệt luồng AI inference (`llama.cpp`) sang background thread (`std::jthread`), truyền dữ liệu về UI qua Qt Signal/Slot (`Qt::QueuedConnection`) để UI luôn mượt mà 60fps.

## 6. Đồ Họa Nhân Vật Chuẩn Game (Game Character Graphics)
- Tuân thủ nghiêm ngặt [.agents/rules/character_graphics_rules.md](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/.agents/rules/character_graphics_rules.md) và [.agents/skills/game-character-graphics/SKILL.md](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/.agents/skills/game-character-graphics/SKILL.md).
- Ưu tiên Skeletal Hierarchy, Spring Physics, State Blending và Batching <= 2 Draw Calls.
