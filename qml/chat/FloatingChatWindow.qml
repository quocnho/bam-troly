import QtQuick
import "../chat"
import "../dialogs"

Window {
    id: chatWinRoot
    property var appController: null
    property var dogWindow: null
    property bool isPinned: true
    signal pinToggled()

    width: 400; height: 580; color: "transparent"
    flags: isPinned ? (Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint)
                    : (Qt.Window | Qt.FramelessWindowHint)

    function realignToDog() {
        if (!dogWindow) return;
        var sW = Screen.desktopAvailableWidth > 0 ? Screen.desktopAvailableWidth : Screen.width;
        var sH = Screen.desktopAvailableHeight > 0 ? Screen.desktopAvailableHeight : Screen.height;
        // Chú chó (rộng 116) nằm ở góc dưới bên phải cửa sổ chính
        var targetX = dogWindow.x + 116 - width;
        // Cửa sổ chính nằm ở trên đầu chú chó
        var targetY = dogWindow.y - height - 8;
        if (targetY < 12) targetY = Math.min(sH - height - 12, dogWindow.y + dogWindow.height + 8);
        x = Math.max(12, Math.min(sW - width - 12, targetX));
        y = Math.max(12, Math.min(sH - height - 12, targetY));
    }

    onVisibleChanged: if (visible) realignToDog()

    ChatWindow {
        id: chatView; anchors.fill: parent; targetWindow: chatWinRoot
        controller: appController; isPinned: chatWinRoot.isPinned
        onPinClicked: chatWinRoot.pinToggled()
        onMinimizeClicked: if (appController) appController.isExpanded = false
        onCloseClicked: confirmDialog.visible = true
    }

    ConfirmDialog {
        id: confirmDialog; visible: false; anchors.centerIn: parent
        controller: appController
        onConfirmed: (clearData) => { if (clearData) chatView.clearHistory(); Qt.quit(); }
        onCancelled: confirmDialog.visible = false
    }

    function focusInput() { chatView.focusInput(); }
}
