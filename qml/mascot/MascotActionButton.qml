import QtQuick

Rectangle {
    id: btnRoot
    width: 26; height: 26; radius: 13
    color: mouseArea.containsMouse ? (isDanger ? "#DC2626" : (isActive ? "#3B82F6" : "#374151"))
                                  : (isActive ? "#2563EB" : "#1F2937")
    border.color: isActive ? "#60A5FA" : (mouseArea.containsMouse ? "#9CA3AF" : "#4B5563")
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
        acceptedButtons: Qt.LeftButton
        propagateComposedEvents: false
        preventStealing: true
        onClicked: (mouse) => { mouse.accepted = true; btnRoot.clicked(); }
    }
}
