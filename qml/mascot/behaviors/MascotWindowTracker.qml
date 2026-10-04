import QtQuick

Item {
    id: trackerRoot
    property var targetWindow: null
    property var appController: null
    property var rig: null

    Timer {
        interval: 16; repeat: true; running: trackerRoot.appController !== null
        property real lastWinX: trackerRoot.targetWindow?.x ?? 0
        property real lastWinY: trackerRoot.targetWindow?.y ?? 0
        onTriggered: {
            var curX = trackerRoot.targetWindow?.x ?? 0; var curY = trackerRoot.targetWindow?.y ?? 0;
            var vx = (curX - lastWinX) * 2.0; var vy = (curY - lastWinY) * 2.0;
            if (Math.abs(vx) > 0.1 || Math.abs(vy) > 0.1) trackerRoot.appController.physics.applyWindowVelocity(vx, vy);
            lastWinX = curX; lastWinY = curY;
            trackerRoot.appController.physics.step(0.016);
        }
    }

    Timer {
        interval: 50; repeat: true
        running: trackerRoot.rig && trackerRoot.rig.dogState !== "sleeping" && trackerRoot.rig.dogState !== "lying" && trackerRoot.appController !== null
        onTriggered: {
            if (!trackerRoot.targetWindow || (trackerRoot.rig && trackerRoot.rig.isHovered)) return;
            var pos = trackerRoot.appController.getCursorPos();
            var winX = trackerRoot.targetWindow.x + 58; var winY = trackerRoot.targetWindow.y + 58;
            trackerRoot.rig.gazeX = Math.max(-2.5, Math.min(2.5, (pos.x - winX) / 280.0 * 2.5));
            trackerRoot.rig.gazeY = Math.max(-2.0, Math.min(2.0, (pos.y - winY) / 220.0 * 2.0));
            trackerRoot.rig.isTrackingMouse = true;
        }
    }
}
