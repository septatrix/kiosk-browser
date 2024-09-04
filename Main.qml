import QtQuick
import QtWebEngine

Window {
    id: window
    visible: true
    visibility: "FullScreen"

    WebEngineView {
        id: webView
        anchors.fill: parent
        url: "chrome://qt"

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
}
