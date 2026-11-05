import QtQuick
import QtWebEngine
import QtQuick.VirtualKeyboard

// The context properties kioskUrl and kioskFullscreen
// are provided by main.cpp.
Window {
    id: window
    visible: true
    visibility: kioskFullscreen ? Window.FullScreen : Window.Windowed

    WebEngineView {
        id: webView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        // Make room for the keyboard
        // so that the browser scrolls the focused input into view.
        height: inputPanel.active ? window.height - inputPanel.height : window.height
        url: kioskUrl

        settings.playbackRequiresUserGesture: false
        settings.focusOnNavigationEnabled: false

        // Resizing alone does not scroll the focused input above the keyboard.
        onHeightChanged: {
            if (inputPanel.active) {
                webView.runJavaScript(
                    "document.activeElement && document.activeElement.scrollIntoView({block: 'center'})")
            }
        }

        // No browser context menu in a kiosk.
        onContextMenuRequested: function(request) {
            request.accepted = true
        }

        // Keep everything in this view, no additional windows.
        onNewWindowRequested: function(request) {
            request.openIn(webView)
        }

        onRenderProcessTerminated: function(terminationStatus, exitCode) {
            var status = "";
            switch (terminationStatus) {
            case WebEngineView.NormalTerminationStatus:
                status = "normal exit";
                break;
            case WebEngineView.AbnormalTerminationStatus:
                status = "abnormal exit";
                break;
            case WebEngineView.CrashedTerminationStatus:
                status = "crashed";
                break;
            case WebEngineView.KilledTerminationStatus:
                status = "killed";
                break;
            }

            console.error(`Console: Render process exited with code ${exitCode} (${status})`);
            reload()
        }
    }

    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: window.height
        width: window.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: window.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
