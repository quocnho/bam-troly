---
name: game-character-graphics
description: Tiêu chuẩn và kỹ thuật xây dựng đồ họa nhân vật Mascot chuẩn Game Engine trong C++20 và Qt6 Scene Graph (12 Disney Principles, DOD/ECS, Fiber Job System, Frame Allocator, Bindless Rendering).
---

# Game Character Graphics Engine & Mascot Rigging (C++20 / Qt6 Scene Graph)

Kỹ năng này cung cấp đặc tả kiến trúc kỹ thuật chuẩn mực của một **Game Character Engine AAA** dành cho Mascot: kế thừa **12 Nguyên Tắc Hoạt Hình Disney**, chuyển đổi toàn diện sang **Data-Oriented Design (DOD / ECS)**, kiến trúc đa luồng **Fiber-based Job System**, quản lý bộ nhớ **Linear Frame Allocator (Zero-Alloc)**, và luồng kết xuất **Bindless / GPU-Driven Pipeline** trên nền tảng Qt6 Scene Graph & RHI.

---

## 1. Bản Đồ Ánh Xạ: 12 Nguyên Tắc Hoạt Hình Disney Sang Game Engine Mathematics

| # | Nguyên Tắc Disney | Bản Chất Đồ Họa Số / Game Engine | Mô Hình Toán Học & Thuật Toán C++20 |
|---|---|---|---|
| 1 | **Squash & Stretch** (Nén & Giãn) | Biến dạng thể tích bảo toàn (Volume Conservation) khi va chạm hoặc gia tốc. | Giữ nguyên thể tích: $S_x \cdot S_y \cdot S_z = 1.0$. Khi nén trục Y ($S_y < 1.0$), tự động giãn $S_x = S_z = \frac{1}{\sqrt{S_y}}$. |
| 2 | **Anticipation** (Lấy đà / Dự báo) | Chuyển động ngược pha trước khi bùng nổ hành động chính (chùng gối trước khi nhảy). | Keyframe Pose hoặc Procedural Reverse-Dip: Áp dụng gia tốc âm trong $\Delta t_{\text{anticipate}}$ (50 - 100ms) trước khi kích hoạt Impulse. |
| 3 | **Staging** (Dàn cảnh / Điểm nhìn) | Điều phối hướng nhìn (Look-At target) và phân cấp trọng tâm thị giác nhân vật. | Tính toán ma trận Camera Projection & Head Orientation Target hướng về con trỏ chuột/tâm chat. |
| 4 | **Straight Ahead & Pose to Pose** | Kết hợp Keyframe Bone Poses (cử chỉ định hình) và Procedural Physics (vật lý liên tục). | Trộn lẫn giữa Keyframe Clip Interpolation (Pose-to-Pose) và Verlet/Spring Physics (Straight Ahead). |
| 5 | **Follow Through & Overlapping** | Chuyển động kế tiếp và trễ pha của các bộ phận mềm (tai vểnh, chóp đuôi, mỡ má, vòng cổ). | **Phase-Lag Spring Chain**: Khớp con cập nhật dựa trên vị trí khớp cha ở frame trước ($t - \Delta t$) kèm độ trễ quán tính (Inertial Delay). |
| 6 | **Slow In & Slow Out** (Tăng / Giảm tốc) | Chuyển động tự nhiên không tuyến tính, loại bỏ hoàn toàn Linear Interpolation. | Sử dụng đường cong **Cubic Hermite Spline** hoặc **SmoothStep / Ease-In-Out Quintic**: $f(t) = 6t^5 - 15t^4 + 10t^3$. |
| 7 | **Arcs** (Quỹ đạo vòng cung) | Mọi chuyển động sinh học (vẫy đuôi, lắc đầu, bước chân) đều theo đường cung parabol/elip. | Cập nhật vị trí qua **Quadratic/Cubic Bézier Paths** hoặc ma trận xoay góc cực thay vì tịnh tiến Cartesian thẳng trục. |
| 8 | **Secondary Action** (Hành động phụ) | Chi tiết sống động bổ trợ (mắt chớp, mũi hếch rung, ngực phồng thở khi đứng yên). | Các sub-emitters và procedural micro-oscillators tần số cao dao động độc lập trên xương phụ. |
| 9 | **Timing** (Nhịp điệu) | Tốc độ và khoảng cách giữa các cử chỉ để truyền tải cân nặng, sức ì và cảm xúc. | Điều biến `tick_rate` và trọng số quán tính theo khối lượng ảo $m$ của từng bộ phận ($F = ma$). |
| 10 | **Exaggeration** (Cường điệu hóa) | Phóng đại biên độ cảm xúc và động tác nhưng không phá vỡ liên kết giải phẫu nhân vật. | Hệ số nhân độ lệch $\kappa > 1.0$ trên các kênh biến dạng giới hạn (Clamped Deformation Multiplier). |
| 11 | **Solid Drawing** (Hình khối vững chắc) | Đảm bảo tính nhất quán 3D/2.5D về khối lượng, tỉ lệ giải phẫu dù biến dạng. | Ràng buộc **Inverse Kinematics (IK Fabrik/CCD)** giữ cố định chiều dài các đoạn xương (Bone Length Invariance). |
| 12 | **Appeal** (Sức hút nhân vật) | Thiết kế tỷ lệ vàng hoạt họa (đầu to, mắt lúng liếng, má ửng, chuyển động mượt 60fps). | Vi chỉnh tham số hình thái học (Morph Targets / Shape Keys) và tính đối xứng động (Dynamic Asymmetry). |

---

## 2. Kiến Trúc Data-Oriented Design (DOD) & Entity-Component-System (ECS)

Thay vì tổ chức theo hướng đối tượng truyền thống OOP (vốn gây pointer chasing và cache miss phân mảnh), toàn bộ nhân vật được mô hình hóa theo **Structure of Arrays (SoA)** và Contiguous Memory Arrays:

```
┌────────────────────────────────────────────────────────────────────────┐
│                   DOD / ECS MASCOT ENGINE ARCHITECTURE                 │
├────────────────────────────────────────────────────────────────────────┤
│ Entity Registry: MascotID, BoneIDs (Contiguous uint32_t)               │
├────────────────────────────────────────────────────────────────────────┤
│ Components (Packed Contiguous Flat Arrays - SoA):                      │
│  ├── TransformComponentSoA  : [pos_x[], pos_y[], rot_rad[], scale[]]    │
│  ├── HierarchyComponent     : [parent_idx[], depth_level[]]            │
│  ├── SpringDynamicsSoA      : [pos[], vel[], target[], stiffness[], damping[]]│
│  ├── DisneyDeformComponent  : [squash_factor[], phase_delay[], arc_rad[]]│
│  └── RenderMeshComponent    : [vertex_offset[], index_offset[], atlas_uv[]]│
├────────────────────────────────────────────────────────────────────────┤
│ Systems (SIMD / Cache-Friendly Iterators):                             │
│  ├── KinematicsSystem       : Duyệt tuần tự mảng cha -> con (No recursion)│
│  ├── SpringPhysicsSystem    : SIMD AVX2/NEON update cho toàn bộ joints │
│  ├── DisneyProceduralSystem : Đánh giá Squash/Stretch & Overlap Phase  │
│  └── VertexSkinningSystem   : Ghi ma trận biến đổi vào GPU Vertex Buffer│
└────────────────────────────────────────────────────────────────────────┘
```

### Triết Lý Thiết Kế DOD / ECS Trong C++20:
- **Tập trung Dữ liệu (Cache Line Friendly)**: 100% dữ liệu biến đổi nằm trong các mảng tuyến tính liền kề (64-byte aligned).
- **Loại bỏ Đệ quy (Zero Recursion)**: Cấu trúc cây xương phân cấp được lưu theo thứ tự topological sort (cha luôn đứng trước con), cho phép duyệt bằng vòng lặp phẳng `for (size_t i = 0; i < boneCount; ++i)`.
- **Tối ưu SIMD Vectorization**: Tính toán song song 4 đến 8 khớp xương cùng lúc thông qua SIMD intrinsic hoặc auto-vectorization của compiler.

---

## 3. Kiến Trúc Đa Luồng Fiber-Based Job System

Tách biệt hoàn toàn việc tính toán nhân vật khỏi Qt GUI Main Thread bằng hệ thống Task Graph (Directed Acyclic Graph - DAG) dựa trên Work-Stealing Workers:

```
[Frame Start Event / V-Sync Tick]
               │
               ▼
   [Fiber Task: Input & Target Gathering] (Mouse pos, Window Drag, Chat AI State)
               │
               ▼
   ┌───────────────────────────────────────────────┐
   │ PARALLEL JOB DISPATCH (Worker Thread Pool)    │
   ├───────────────────────────────────────────────┤
   │ [Job A: Animation Pose Clip Sampling]         │
   │ [Job B: Procedural Spring Secondary Dynamics] │
   └───────────────────────────────────────────────┘
               │
               ▼ (Barrier / Fiber Counter Wait)
   [Job C: Hierarchical World Transform Propagation] (DOD Kinematics)
               │
               ▼
   [Job D: Disney Squash/Stretch & Volume Deform]
               │
               ▼
   [Job E: Vertex Skinning & Linear Frame Pack]
               │
               ▼
[Render Thread / Qt RHI]: Direct Upload & Draw Call (<= 2 Draw Calls)
```

- **Zero Lock Contention**: Giao tiếp giữa các luồng bằng Atomic Task Counters và Lock-free Ring Buffers.
- **Micro-Fiber Suspend/Resume**: Cho phép các tác vụ nhẹ tạm dừng chờ dependency mà không block OS thread, tối đa hóa hiệu suất CPU Core trên Linux/BamOS.

---

## 4. Quản Lý Bộ Nhớ & Tài Nguyên (Memory & Resource Management)

### A. Linear / Arena Frame Allocator (Zero-Allocation Loop)
- **Quy tắc tuyệt đối**: Không gọi `malloc`, `free`, `new`, `delete` hoặc resize `std::vector` trong vòng lặp game loop.
- **Double-Buffered Frame Arena**:
  - Khởi tạo trước một vùng nhớ tĩnh (ví dụ: 4MB - 8MB) cho mỗi frame.
  - Cấp phát siêu tốc trong frame chỉ bằng phép cộng con trỏ (Pointer Bump Allocator - độ phức tạp $O(1)$).
  - Kết thúc frame: Reset con trỏ offset về 0 ($O(1)$) để tái sử dụng cho frame kế tiếp, triệt tiêu 100% hiện tượng phân mảnh heap (Memory Fragmentation).

```cpp
class FrameArenaAllocator {
public:
    explicit FrameArenaAllocator(size_t capacity) 
        : m_buffer(new uint8_t[capacity]), m_capacity(capacity) {}
    ~FrameArenaAllocator() { delete[] m_buffer; }

    void* allocate(size_t bytes, size_t alignment = alignof(std::max_align_t)) noexcept {
        size_t current = reinterpret_cast<uintptr_t>(m_buffer + m_offset);
        size_t aligned = (current + alignment - 1) & ~(alignment - 1);
        size_t newOffset = (aligned - reinterpret_cast<uintptr_t>(m_buffer)) + bytes;
        if (newOffset > m_capacity) return nullptr; // Out of frame budget
        m_offset = newOffset;
        return reinterpret_cast<void*>(aligned);
    }
    void reset() noexcept { m_offset = 0; }
private:
    uint8_t* m_buffer{nullptr};
    size_t m_capacity{0};
    size_t m_offset{0};
};
```

---

## 5. Bindless Rendering & GPU-Driven Pipeline

Để đạt tiêu chuẩn khắt khe **<= 2 Draw Calls** trên toàn bộ cửa sổ linh vật:

1. **Texture Atlas & Bindless Textures / Descriptor Indexing**:
   - Toàn bộ mắt, lông, biểu cảm má hồng, phụ kiện nơ/bảng tên được gom chung vào một Texture Atlas duy nhất.
   - Hoặc sử dụng descriptor indexing / bindless resource array để shader truy xuất tài nguyên trực tiếp qua Index mà không cần chuyển đổi Pipeline State.
2. **GPU Vertex Skinning qua SSBO / Dynamic Vertex Buffer**:
   - Thay vì CPU biến đổi từng đỉnh và nạp lại vào GPU, nạp toàn bộ danh sách Ma trận Xương (`BoneMatrix[]`) hoặc Dynamic Joint Coordinates vào Shader Storage Buffer Object (SSBO) hoặc Qt RHI Uniform Buffer.
   - Vertex Shader trực tiếp tính toán vị trí đỉnh cuối cùng theo trọng số (Skinning Weight).
3. **Single Indexed Batch Rendering**:
   - Sử dụng một `QSGGeometryNode` duy nhất chứa toàn bộ Mesh của Mascot (Triangles với Index Buffer liền mạch).
   - Render Pass duy nhất kết xuất toàn bộ cơ thể nhân vật trong đúng 1 Draw Call.

---

## 6. Danh Mục Kiểm Tra Kỹ Thuật (Architecture Checklist)

1. [ ] **Toán học Disney**: Áp dụng bảo toàn thể tích (Squash & Stretch) và độ trễ pha (Follow Through) bằng công thức giải tích.
2. [ ] **DOD / SoA Data Layout**: Các biến số của xương và lò xo được lưu trong mảng phẳng liền kề, không tạo con trỏ lồng nhau.
3. [ ] **Zero-Allocation**: Kiểm tra bộ nhớ per-frame: không phát sinh bất kỳ syscall cấp phát heap nào trong render loop.
4. [ ] **Draw Calls <= 2**: Kiểm tra qua GPU Profiler (RenderDoc / Qt Quick Profiler), toàn bộ Mascot không vượt quá 2 draw calls.
5. [ ] **Non-blocking Main Thread**: Luồng tính toán chuyển động và skinning chạy tách biệt, đảm bảo UI giữ vững 60fps mượt mà.
