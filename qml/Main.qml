import QtQuick
import "mascot"
import "mascot/behaviors"
import "chat"

Window {
    id: assistantWindow
    property var appController: null; property bool isPinned: true
    property bool initialized: false; property bool isMovingDog: false
    readonly property bool isExpanded: !!(appController && appController.isExpanded)

    visible: true; color: "transparent"
    width: isExpanded ? 400 : 126; height: isExpanded ? 706 : 116
    flags: isPinned ? (Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint)
                    : (Qt.Tool | Qt.FramelessWindowHint)

    Timer { id: savePosTimer; interval: 400; repeat: false; onTriggered: if (appController && initialized && !isMovingDog) appController.savePosition(x, y + (isExpanded ? 590 : 0)) }
    onXChanged: if (initialized && !isMovingDog) savePosTimer.restart()
    onYChanged: if (initialized && !isMovingDog) savePosTimer.restart()

    onIsExpandedChanged: {
        if (!initialized) return
        var sW = Screen.desktopAvailableWidth > 0 ? Screen.desktopAvailableWidth : Screen.width
        var sH = Screen.desktopAvailableHeight > 0 ? Screen.desktopAvailableHeight : Screen.height
        if (isExpanded) {
            y = Math.max(12, y - 590); x = Math.max(12, Math.min(sW - 412, x - 274))
            Qt.callLater(chatPanel.focusInput)
        } else { y = Math.min(sH - 128, y + 590); x = Math.min(sW - 138, x + 274); }
    }

    function updateWindowPos() {
        var sW = Screen.desktopAvailableWidth > 0 ? Screen.desktopAvailableWidth : Screen.width
        var sH = Screen.desktopAvailableHeight > 0 ? Screen.desktopAvailableHeight : Screen.height
        var defX = sW - 150; var defY = sH - 140
        if (appController) {
            var p = appController.getSavedPosition(defX, defY)
            x = (p.x <= 10 || p.x > sW - 126) ? defX : p.x
            y = (p.y <= 10 || p.y > sH - 116) ? defY : p.y
        } else { x = defX; y = defY; }
        initialized = true
    }
    Component.onCompleted: { updateWindowPos(); dogHost.wakeUp(); }

    ChatPanel {
        id: chatPanel; anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
        visible: assistantWindow.isExpanded; appController: assistantWindow.appController
        hostWindow: assistantWindow; isPinned: assistantWindow.isPinned
        onPinToggled: assistantWindow.isPinned = !assistantWindow.isPinned
    }

    Item {
        id: mascotAnchorArea; width: 126; height: 116
        anchors.bottom: parent.bottom; anchors.right: parent.right
        HoverHandler {
            onHoveredChanged: if (hovered) { hideTimer.stop(); actionBar.isVisible = true; } else hideTimer.restart()
        }
        Timer { id: hideTimer; interval: 450; repeat: false; onTriggered: actionBar.isVisible = false }

        DogMascotHost {
            id: dogHost; width: 116; height: 116; targetWindow: assistantWindow
            appController: assistantWindow.appController
            onClicked: if (assistantWindow.isMovingDog) assistantWindow.isMovingDog = false;
                       else if (appController) appController.isExpanded = !appController.isExpanded
        }

        MascotActionBar {
            id: actionBar; x: 96; anchors.verticalCenter: dogHost.verticalCenter
            isDragArmed: assistantWindow.isMovingDog
            onTriggerDrag: assistantWindow.isMovingDog = !assistantWindow.isMovingDog
            onTriggerSettings: if (appController) appController.isExpanded = !appController.isExpanded
            onTriggerExit: if (appController) appController.quitApp(); else Qt.quit()
        }
    }

    MascotFollowMover {
        targetWindow: assistantWindow; appController: assistantWindow.appController
        isMoving: assistantWindow.isMovingDog
    }
}
