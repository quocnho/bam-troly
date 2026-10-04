import QtQuick
import "mascot"
import "mascot/behaviors"
import "chat"
import "common"

Window {
    id: dogWindow
    property var appController: null
    property bool isPinned: true
    property bool syncingWinPos: false
    property bool initialized: false
    property bool isMovingDog: false

    visible: true; width: 160; height: 116; color: "transparent"
    flags: isPinned ? (Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint)
                    : (Qt.Window | Qt.FramelessWindowHint)

    Timer { id: savePosTimer; interval: 350; repeat: false; onTriggered: if (appController) appController.savePosition(dogWindow.x, dogWindow.y) }
    onXChanged: { if (initialized) savePosTimer.restart(); if (chatWin && chatWin.visible && !syncingWinPos) chatWin.realignToDog(); }
    onYChanged: { if (initialized) savePosTimer.restart(); if (chatWin && chatWin.visible && !syncingWinPos) chatWin.realignToDog(); }

    MascotFollowMover {
        targetWindow: dogWindow; appController: dogWindow.appController
        isMoving: dogWindow.isMovingDog
    }

    Timer { id: hideBarTimer; interval: 600; repeat: false; onTriggered: actionBar.isVisible = false }

    function updateDogPos() {
        var sW = Screen.desktopAvailableWidth > 0 ? Screen.desktopAvailableWidth : Screen.width;
        var sH = Screen.desktopAvailableHeight > 0 ? Screen.desktopAvailableHeight : Screen.height;
        var defX = sW - width - 24; var defY = sH - height - 24;
        if (appController) {
            var p = appController.getSavedPosition(defX, defY);
            x = Math.max(0, Math.min(sW - width, p.x)); y = Math.max(0, Math.min(sH - height, p.y));
        } else { x = defX; y = defY; }
        initialized = true;
    }
    Component.onCompleted: { updateDogPos(); mascotDog.wakeUp(); }
    Screen.onWidthChanged: updateDogPos(); Screen.onHeightChanged: updateDogPos()

    DogMascotHost {
        id: mascotDog; width: 116; height: 116; targetWindow: dogWindow
        appController: dogWindow.appController
        onHoverEntered: { hideBarTimer.stop(); actionBar.isVisible = true }
        onHoverExited: hideBarTimer.restart()
        onDogStateChanged: if ((dogState === "lying" || dogState === "sleeping") &&
                               appController && appController.isExpanded) appController.isExpanded = false
        onClicked: {
            if (dogWindow.isMovingDog) { dogWindow.isMovingDog = false; return; }
            if (appController) {
                appController.isExpanded = !appController.isExpanded
                if (appController.isExpanded) Qt.callLater(chatWin.focusInput)
            }
        }
    }

    MascotActionBar {
        id: actionBar; anchors.left: mascotDog.right; anchors.leftMargin: 4
        anchors.verticalCenter: mascotDog.verticalCenter; isDragArmed: dogWindow.isMovingDog
        onHoverEntered: hideBarTimer.stop(); onHoverExited: hideBarTimer.restart()
        onTriggerDrag: dogWindow.isMovingDog = !dogWindow.isMovingDog
        onTriggerSettings: if (appController) {
            appController.isExpanded = !appController.isExpanded
            if (appController.isExpanded) Qt.callLater(chatWin.focusInput)
        }
        onTriggerExit: Qt.quit()
    }

    FloatingChatWindow {
        id: chatWin; visible: !!(appController && appController.isExpanded)
        appController: dogWindow.appController; dogWindow: dogWindow
        isPinned: dogWindow.isPinned; onPinToggled: dogWindow.isPinned = !dogWindow.isPinned
    }
}
