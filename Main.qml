import QtQuick
import QtWebEngine
import QtQuick.VirtualKeyboard

Window {
    id: window
    visible: true
    visibility: "FullScreen"

    WebEngineView {
        id: webView
        anchors.fill: parent
        url: "https://www.wikipedia.org"

        settings.playbackRequiresUserGesture: false

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
            reload();
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
