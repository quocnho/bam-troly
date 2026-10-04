import QtQuick

Item {
    id: barRoot
    width: 32; height: col.height
    opacity: isVisible ? 1.0 : 0.0
    visible: opacity > 0.001
    z: 100

    property bool isVisible: false
    property bool isDragArmed: false
    signal triggerDrag()
    signal triggerSettings()
    signal triggerExit()

    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

    Column {
        id: col
        spacing: 5
        anchors.centerIn: parent

        MascotActionButton {
            iconText: "✋"
            isActive: barRoot.isDragArmed
            toolTipText: "Kéo thả vị trí"
            onClicked: barRoot.triggerDrag()
        }

        MascotActionButton {
            iconText: "⚙️"
            toolTipText: "Thiết lập / Cài đặt"
            onClicked: barRoot.triggerSettings()
        }

        MascotActionButton {
            iconText: "⏻"
            isDanger: true
            toolTipText: "Tắt ứng dụng"
            onClicked: barRoot.triggerExit()
        }
    }
}
