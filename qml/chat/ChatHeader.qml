import QtQuick
import "../common"

Rectangle {
    id: headerRoot
    property var controller: null
    property var targetWindow: null
    property bool isPinned: true
    signal closeClicked(); signal minimizeClicked(); signal pinClicked()

    readonly property bool isDark: !controller || controller.isDarkTheme
    height: 38; color: isDark ? "#252528" : "#ebebf0"; radius: 14
    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 12; color: headerRoot.isDark ? "#252528" : "#ebebf0" }
    DragHandler { target: null; onActiveChanged: if (active && headerRoot.targetWindow) headerRoot.targetWindow.startSystemMove() }

    Row {
        anchors.left: parent.left; anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter; spacing: 7

        // Nút Ghim (Pin) nhỏ gọn: đứng thẳng + sáng rực khi ghim, nghiêng -35 độ + mờ khi bỏ ghim
        Rectangle {
            width: 24; height: 24; radius: 6
            color: pinMouse.containsMouse ? "#3a3a3e" : (headerRoot.isPinned ? "#2d3d52" : "transparent")
            border.color: headerRoot.isPinned ? "#4a90e2" : "transparent"; border.width: 1
            Text {
                anchors.centerIn: parent; text: "📌"; font.pixelSize: 12
                rotation: headerRoot.isPinned ? 0 : -35
                opacity: headerRoot.isPinned ? 1.0 : 0.45
                Behavior on rotation { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }
                Behavior on opacity { NumberAnimation { duration: 180 } }
            }
            MouseArea { id: pinMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: headerRoot.pinClicked() }
        }

        // Nút chuyển đổi Dark / Light theme cho hệ thống desktop BamOS
        Rectangle {
            width: 24; height: 24; radius: 6
            color: themeMouse.containsMouse ? "#3a3a3e" : "transparent"
            Text {
                anchors.centerIn: parent
                text: (controller && controller.isDarkTheme) ? "🌙" : "☀️"
                font.pixelSize: 12
                opacity: themeMouse.containsMouse ? 1.0 : 0.75
            }
            MouseArea {
                id: themeMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                onClicked: if (controller) controller.toggleDesktopTheme()
            }
        }

        StatusIndicator {
            anchors.verticalCenter: parent.verticalCenter
            status: (controller && controller.isGenerating) ? "streaming" : "idle"
        }

        Text { text: "Cửa sổ chính"; color: headerRoot.isDark ? "#f0f0f2" : "#1a1a1c"; font.bold: true; font.pixelSize: 12 }
    }

    Row {
        anchors.right: parent.right; anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter; spacing: 4

        Rectangle {
            width: 24; height: 24; radius: 6
            color: minM.containsMouse ? (headerRoot.isDark ? "#3a3a3e" : "#d8d8de") : "transparent"
            Text { anchors.centerIn: parent; text: "−"; color: headerRoot.isDark ? "#b0b0b5" : "#55555c"; font.pixelSize: 15; font.bold: true }
            MouseArea { id: minM; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: headerRoot.minimizeClicked() }
        }

        Rectangle {
            width: 24; height: 24; radius: 6
            color: closeM.containsMouse ? "#c0392b" : "transparent"
            Text { anchors.centerIn: parent; text: "✕"; color: closeM.containsMouse ? "#ffffff" : (headerRoot.isDark ? "#b0b0b5" : "#55555c"); font.pixelSize: 11 }
            MouseArea { id: closeM; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: headerRoot.closeClicked() }
        }
    }
}
