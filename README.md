# Bam Trợ Lý (bam-troly)

Ứng dụng Trợ lý AI Native chạy độc lập dưới dạng đối tượng nổi trong suốt (Frameless, Transparent Floating Widget), Always-on-Top, kéo thả tự do trên **BamOS (Wayland)** và **Windows**.
Hỗ trợ cả 2 chế độ: **Bản Lite Offline** (nhúng trực tiếp `llama.cpp` + SQLite RAG) và **Bản Enterprise Client** (kết nối đồng bộ với hệ thống `troly.info`).

## 1. Công nghệ cốt lõi
- **Ngôn ngữ**: C++20 (CMake >= 3.24, Ninja).
- **Giao diện**: Qt6 Quick / QML (Nền trong suốt, không viền, `DragHandler` kéo thả tự do, tự động focus input khi mở).
- **AI Agent**: Kiến trúc ReAct (OpenClaw-like pattern: Reasoning ➔ Acting ➔ Tool Call ➔ Reply) & cơ chế tự động Refine & Reframe yêu cầu.
- **Edge AI**: `llama.cpp` nhúng trực tiếp in-process, chạy các mô hình GGUF offline 100%.
- **Lưu trữ & RAG**: SQLite3 WAL mode + FTS5 & `sqlite-vec` (384 dimensions).
- **Linh vật Trợ lý Hoạt họa Đa Tầng (Multi-part Rigging & 12 Disney Principles)**:
  - **Tách khớp cử động độc lập**: Chuyển động tự nhiên, biểu cảm sống động:
    - **Đôi mắt lúng liếng (`DogEyes.qml`)**: Đảo mắt nhìn quanh, chớp mắt tự nhiên (*Blink cycle*) và có đốm sáng phản chiếu (*Catchlight*) di chuyển theo ánh nhìn.
    - **Đôi tai vểnh (`DogEars.qml`)**: Cụp mềm mại, định kỳ vẩy tai (*ear twitch*) lắng nghe, rủ xuống khi ngủ say.
    - **Mõm & Lưỡi rung (`DogMouth.qml`)**: Mũi đen bóng ướt, miệng cười mở rộng và lưỡi hồng rung nhịp khi sủa hoặc thở.
    - **Cái đuôi xoắn (`DogTail.qml`)**: Vẫy nhanh linh hoạt theo nguyên tắc *Follow-through & Overlapping*.
    - **Ngực phồng & Co người (`DogTorso.qml`)**: *Squash & Stretch* tự nhiên, ngực phồng lên lấy đà khi sủa.
    - **Bước chân lúp xúp (`DogSideWalk.qml`)**: Chân cử động tự nhiên khi di chuyển hoặc chạy bộ.
    - **Nhảy cẫng mừng rỡ (`JumpBounceAnimationFlow.qml`)**: Chú chó nhún nhảy tưng tưng chào đón.
  - **Khởi động**: Chạy từ góc màn hình ra, dừng lại vẫy đuôi mừng rỡ và sủa *"Gâu! 🐾"* dứt khoát.
  - **Trạng thái Nghỉ (Idle State Machine)**: Sau 3 phút ngồi quan sát; sau 5 phút nằm mở mắt vẩy tai; sau 10 phút chìm vào giấc ngủ với bóng ngủ `💤`.
  - **Đánh thức & Chat**: Click chuột vào chú chó sẽ bật dậy và khung chat nổi lên ngay trên đầu.
- **Khung Chat Chuyên Nghiệp & Tab Panels**:
  - Hỗ trợ hiển thị Code Blocks (`CodeBlockView.qml`) kèm nút copy 1 chạm và tooltip phản hồi nhanh.
  - Phân tách bong bóng chat người dùng & trợ lý rõ ràng (`MessageBubble.qml`).
  - Hỗ trợ mở rộng các Drawer/Tab Panels (Chat, Settings, Model Manager) linh hoạt trên cùng một khung vẽ.
- **Kiến trúc Single Dynamic Window**: 
  - Chỉ sử dụng **1 Native OS Window duy nhất** có kích thước co giãn động theo trạng thái (thu nhỏ 126x116 ôm sát Mascot, mở rộng khi bật Chat/Tabs).
  - Tối ưu VRAM (<15MB) và băng thông GPU, không gây xung đột Input Mask trên Linux Wayland, đồng bộ 100% Scene Graph 60fps.
  - Clean Architecture gom theo tính năng/hành vi & Micro-Modules (< 80 dòng QML, < 100 dòng C++).

## 2. Phát triển & Biên dịch Cục bộ (devenv)
Sử dụng môi trường Nix thông qua `direnv` hoặc `devenv`:

```bash
# 1. Kích hoạt môi trường (chỉ cần chạy 1 lần)
direnv allow   # hoặc: devenv shell

# 2. Biên dịch dự án
troly build

# 3. Khởi chạy thử nghiệm
troly run

# 4. Dọn dẹp bản build
troly clean
```

> **Cách biên dịch thủ công (bằng CMake):**
> ```bash
> cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
> cmake --build build
> ./build/bam-troly
> ```

## 3. Đóng gói & Triển khai trên BamOS / NixOS
Dự án cung cấp sẵn tệp đặc tả [package.nix](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/package.nix) để tích hợp vào Flake của BamOS (`/etc/nixos/flake.nix`):

```nix
# Trong cấu hình Flake hoặc overlay của BamOS:
bam-troly = pkgs.callPackage ./package.nix { };
```

Khi cài đặt qua Nix derivation, ứng dụng sẽ tự động sinh file desktop entry tại `/share/applications/bam-troly.desktop` và có thể tìm kiếm, khởi chạy trực tiếp từ GNOME App Grid.

## 4. Thao tác Người Dùng & Phím Tắt
- **Đánh thức & Mở rộng chat**: Click chuột trái vào chú chó để chú chó bật dậy và mở khung chat ngay trên đầu.
- **Trạng thái linh vật**:
  - *Vừa khởi động*: Chạy từ góc màn hình ra, dừng lại vẫy đuôi chào mừng.
  - *Sau 3 phút rảnh*: Chú chó chuyển sang tư thế ngồi ngoan ngoãn.
  - *Sau 5 phút rảnh*: Chú chó chuyển sang tư thế nằm, mở mắt và vẩy tai lắng nghe.
  - *Sau 10 phút rảnh*: Chú chó ngủ say sưa.
- **Tự động Focus**: Con trỏ phím tự động kích hoạt vào ô nhập liệu để bắt đầu gõ lệnh/chat ngay lập tức.
- **Kéo thả tự do**: Kéo chú chó hoặc thanh header đến bất kỳ vị trí nào trên màn hình.
- **Nút Thu nhỏ (`−`)**: Click vào nút `−` trên thanh Header để thu gọn khung chat về lại chú chó.
- **Nút Đóng (`✕`) & Xác nhận**: Click vào nút `✕` trên thanh Header sẽ mở hộp thoại xác nhận:
  - **Có (Xóa)**: Xóa sạch dữ liệu lịch sử hội thoại và thoát ứng dụng.
  - **Không (Giữ)**: Giữ nguyên lịch sử hội thoại và thoát ứng dụng.
  - **Hủy**: Đóng hộp thoại và tiếp tục sử dụng trợ lý.

## 5. Quy Chuẩn AI Agent & Tiết Kiệm Token
- **Quy tắc & Kỹ năng**: Tự động tuân thủ [.agents/rules/troly_rules.md](file:///.agents/rules/troly_rules.md) và [.agents/skills/troly-prompt-refiner/SKILL.md](file:///.agents/skills/troly-prompt-refiner/SKILL.md).
- **Quy trình Tối ưu Token**: Áp dụng Compact Confirmation Gate, đọc vi phẫu (Targeted Reading) và sửa vi phẫu (Surgical Edits) để tối ưu hoá tốc độ và chi phí token.

