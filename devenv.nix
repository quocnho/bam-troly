{ pkgs, ... }:

{
  languages.cplusplus.enable = true;

  packages = with pkgs; [
    # Build toolchain C++20 & Ninja
    cmake
    ninja
    pkg-config
    gcc14
    gdb

    # Qt6 Framework & Wayland/X11
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    qt6.qttools

    # Inference & Database
    llama-cpp
    sqlite
  ];

  env = {
    QT_QPA_PLATFORM = "wayland;xcb";
  };

  scripts.troly.exec = ''
    CMD="''${1:-help}"
    shift || true

    case "$CMD" in
      build)
        echo "🔨 Đang biên dịch bam-troly..."
        cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
        cmake --build build
        ;;
      run)
        if [ ! -f "build/bam-troly" ]; then
          echo "🔨 Chưa có bản build, đang biên dịch tự động..."
          cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
          cmake --build build
        fi
        echo "🚀 Khởi chạy bam-troly..."
        ./build/bam-troly "$@"
        ;;
      clean)
        echo "🧹 Đang dọn dẹp thư mục build..."
        rm -rf build
        echo "✔ Đã dọn dẹp hoàn tất."
        ;;
      help|*)
        echo "Cách sử dụng: troly [lệnh]"
        echo "  troly build   - Biên dịch ứng dụng (CMake + Ninja)"
        echo "  troly run     - Khởi chạy ứng dụng (tự build nếu chưa có)"
        echo "  troly clean   - Dọn dẹp thư mục build"
        ;;
    esac
  '';
}
