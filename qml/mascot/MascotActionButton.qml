import QtQuick

Rectangle {
    id: btnRoot
    width: 28; height: 28; radius: 14
    color: mouseArea.containsMouse ? (isDanger ? "#E04040" : (isActive ? "#4D96FF" : "#3F4452"))
                                  : (isActive ? "#3B82F6" : "#242730")
    border.color: isActive ? "#60A5FA" : (mouseArea.containsMouse ? "#6B7280" : "#374151")
    border.width: 1

    property string iconText: ""
    property string toolTipText: ""
    property bool isActive: false
    property bool isDanger: false
    signal clicked()

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
    scale: mouseArea.pressed ? 0.9 : (mouseArea.containsMouse ? 1.08 : 1.0)

    Text {
        anchors.centerIn: parent
        text: btnRoot.iconText
        font.pixelSize: 13
        color: "#F9FAFB"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: btnRoot.clicked()
    }
}
