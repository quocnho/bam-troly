import QtQuick
import "../dialogs"

Item {
    id: chatPanelRoot
    property var appController: null
    property var hostWindow: null
    property bool isPinned: true
    signal pinToggled()

    width: 400; height: 580

    ChatWindow {
        id: chatView; anchors.fill: parent; targetWindow: hostWindow
        controller: appController; isPinned: chatPanelRoot.isPinned
        onPinClicked: chatPanelRoot.pinToggled()
        onMinimizeClicked: if (appController) appController.isExpanded = false
        onCloseClicked: confirmDialog.visible = true
    }

    ConfirmDialog {
        id: confirmDialog; visible: false; anchors.centerIn: parent
        controller: appController
        onConfirmed: (clearData) => {
            if (clearData) chatView.clearHistory();
            if (appController) appController.quitApp(); else Qt.quit();
        }
        onCancelled: confirmDialog.visible = false
    }

    function focusInput() { chatView.focusInput(); }
}
