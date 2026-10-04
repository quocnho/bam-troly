---
name: troly-ecosystem-routing
description: Định tuyến ngữ cảnh subsystem theo tiền tố shorthand (?troly, ?os, ?customizer, ?notes) trong hệ sinh thái BamOS.
---

# Bam Trợ Lý Ecosystem Subsystem Routing Skill

Quy chuẩn điều hướng và nạp ngữ cảnh khi nhận yêu cầu có tiền tố chỉ định subsystem:

## 1. Bảng Tra Cứu Tiền Tố Subsystem (?prefix)

Khi User bắt đầu prompt bằng tiền tố `?<subsystem>:`, `@<subsystem>:`, hoặc `/<subsystem>:`, AI Agent tự động định tuyến vào đúng thư mục con:

| Tiền tố | Subsystem | Thư mục mục tiêu | Công nghệ chính |
| :--- | :--- | :--- | :--- |
| `?troly` | Bam Trợ Lý Desktop App | [BamApps/bam-troly/](file:///home/quocnho/Projects/Bam/BamApps/bam-troly) | C++20, Qt6 Quick, llama.cpp, SQLite3 |
| `?os` hoặc `?bamos` | BamOS Core System | [BamOS/](file:///home/quocnho/Projects/Bam/BamOS) | NixOS, Flakes, Home-Manager |
| `?customizer` | BamOS GUI Customizer | [BamApps/bam-customizer/](file:///home/quocnho/Projects/Bam/BamApps/bam-customizer) | Rust, GTK4, Libadwaita |
| `?notes` | Bam Notes App | [BamApps/bam-notes/](file:///home/quocnho/Projects/Bam/BamApps/bam-notes) | App ecosystem |
| `?installer` hoặc `?iso` | Live ISO & Calamares | [BamOS/profiles/installer/](file:///home/quocnho/Projects/Bam/BamOS/profiles/installer) | Calamares, Python, Nix ISO |
| `?nvim` | Neovim Config | [BamOS/home/dev/nvim/](file:///home/quocnho/Projects/Bam/BamOS/home/dev/nvim) | Lua, LSP, Treesitter |
| `?desktop` hoặc `?gnome` | GNOME & Theme | [BamOS/modules/gnome/](file:///home/quocnho/Projects/Bam/BamOS/modules/gnome) | Dconf, GDM, Extensions |
| `?audio` | PipeWire & Audio | [BamOS/modules/audio/](file:///home/quocnho/Projects/Bam/BamOS/modules/audio) | PipeWire, WirePlumber, Rnnoise |

## 2. Quy Trình Xử Lý Tự Động
1. **Cô Lập Ngữ Cảnh**: Chỉ thao tác và tìm kiếm trong thư mục mục tiêu.
2. **Kích Hoạt Tiêu Chuẩn Riêng**: Tuân thủ [AGENTS.md](file:///home/quocnho/Projects/Bam/BamApps/bam-troly/AGENTS.md) và các file rule của subsystem đó.
3. **Phản Hồi Trực Quan**: Gắn nhãn `[Target: BamApps/bam-troly]` hoặc subsystem tương ứng ở đầu câu trả lời.
