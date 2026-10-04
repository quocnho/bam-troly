import QtQuick

Timer {
    id: moverRoot
    interval: 16; repeat: true
    property var targetWindow: null
    property var appController: null
    property bool isMoving: false
    running: isMoving

    onRunningChanged: {
        if (!running && targetWindow && appController) {
            appController.savePosition(targetWindow.x, targetWindow.y);
        }
    }

    onTriggered: if (appController && targetWindow) {
        var c = appController.getCursorPos()
        var sW = Screen.desktopAvailableWidth > 0 ? Screen.desktopAvailableWidth : Screen.width
        var sH = Screen.desktopAvailableHeight > 0 ? Screen.desktopAvailableHeight : Screen.height
        // Con trỏ đặt ở trung tâm thân chú chó (50, 50)
        var nx = c.x - 50
        var ny = c.y - 50
        targetWindow.x = Math.max(0, Math.min(sW - targetWindow.width, nx))
        targetWindow.y = Math.max(0, Math.min(sH - targetWindow.height, ny))
    }
}
