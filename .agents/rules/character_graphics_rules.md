# Quy Tắc Đồ Họa Nhân Vật & Hiệu Năng Render (Game Character Graphics Rules)

Quy định bắt buộc đối với việc thiết kế và lập trình nhân vật đồ họa (Mascot chú chó) và các hiệu ứng hình ảnh trong dự án **bam-troly**:

## 1. Tư Duy Game Character Đầu Tiên (Game Character-First Mindset)
- **Cấm ghép nối DOM nguyên thủy**: Không chắp vá các thẻ `Rectangle`, `border` phân mảnh lồng nhau quá sâu để vẽ chi tiết cơ thể nhân vật nếu có thể giải quyết bằng Mesh, Sprite-Sheet Atlas hoặc C++ Scene Graph Node.
- **Skeletal & Hierarchical Transform**: Mọi bộ phận của nhân vật (Đầu, Mắt, Tai, Mõm, Thân, Chân, Đuôi) phải được tính toán dựa trên cấu trúc phân cấp (Parent-Child Transform) hoặc Skeleton Bones thay vì neo tọa độ tuyệt đối.

## 2. Kiểm Soát Draw Calls & Batching Tối Đa
- **Chỉ tiêu Draw Calls**: Toàn bộ nhân vật mascot phải kết xuất tối đa **<= 2 Draw Calls** trên GPU.
- **Atlas Hóa Tài Nguyên (Texture Atlas)**: Mọi texture/skin phải gom vào một sheet duy nhất để tránh texture swapping trong Render Pass.
- **Zero-Allocation Render Loop**:
  - Tuyệt đối không cấp phát bộ nhớ động (`new`, `malloc`, `std::vector::push_back` vượt quá dung lượng) trong hàm tick hoặc `updatePaintNode()`.
  - Tái sử dụng Vertex Buffer và Index Buffer trong `QSGGeometry`.

## 3. Quán Tính & Động Lực Học Thủ Tục (Procedural Dynamics)
- **Vật lý lò xo (Spring-Damper / Verlet)**: Các bộ phận mềm mại (tai vểnh, đuôi vẫy, bảng tên lắc lư) phải ứng dụng cơ chế dao động tắt dần theo quán tính chuyển động (khi cửa sổ mascot bị kéo rê trên Wayland).
- **Animation Blending**: Chuyển trạng thái hành vi (Idle <-> Alert <-> Bark <-> Sleep) phải qua bộ nội suy mượt mà (Lerp/Slerp Blend Weight) từ 100ms - 250ms, cấm ngắt đột ngột gây giật khung hình.

## 4. Tách Biệt 4 Tầng Kiến Trúc (Clean Architecture cho Graphics)
1. **Kinematics & Skeleton Core (C++20)**: Tính toán ma trận biến đổi xương và các biến số vật lý (tối đa < 100 dòng/file).
2. **Animation State Machine (C++20)**: Điều phối trọng số clip hoạt họa, blend timeline.
3. **Render Bridge (QSGNode / RHI)**: Nạp vertex data vào GPU Scene Graph.
4. **QML Presentation Layer**: Chỉ nhận diện sự kiện người dùng (Click, Hover, Drag) và bind vào thuộc tính cấp cao (tối đa < 80 dòng/file).
