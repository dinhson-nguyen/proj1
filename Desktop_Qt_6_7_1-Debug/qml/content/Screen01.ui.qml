

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 6.2

import backendqt 1.0

Page {
    id: page1
    visible: true
    // color: "#FAFAFA"
    property double batteryPercentage: 0
    property double batteryVoltage: 0
    property double batteryCurrent: 0
    property int popup_mode: 0
    property string control_mode: "RUNNING"
    property string mode_mode: "MANUAL"
    property string status_mode: "INITIATING"
    property string state_mute: "file:asset/sound.svg"
    property double vel_linear: 0
    property double vel_angular: 0
    property int volume_current: 80
    property int volume_: 80
    property string ip_agv: ""


    Popup {
        id: popup
        x: page1.width * 0.15
        y: page1.height * 0.2
        width: page1.width * 0.7
        height: page1.height * 0.6
        visible: false
        font.italic: true
        font.pointSize: 50
        font.family: "Ubuntu"
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: "#F0F8FF"
            radius: 20
            border.color: "#F0F8FF"
            border.width: 1
        }
        enter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 64
                }
                NumberAnimation {
                    properties: "scale"
                    from: 0.75
                    to: 1
                    duration: 64
                }
            }
        }
        exit: Transition {
            ParallelAnimation {
                NumberAnimation {
                    properties: "opacity"
                    from: 1
                    to: 0
                    duration: 64
                }
                NumberAnimation {
                    properties: "scale"
                    from: 1
                    to: 0.75
                    duration: 64
                }
            }
        }
        Text {
            id: status_popup
            text: qsTr("Loading...")
            height: popup.height * 1 / 3
            anchors.top: header_popup.bottom
            anchors.left: popup.left
            anchors.right: popup.right
            anchors.rightMargin: 50
            anchors.leftMargin: 50
            anchors.topMargin: 10
            font.pixelSize: 45 * popup.width / 884
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.italic: true
        }
        Text {
            id: header_popup
            text: qsTr("Message")
            height: popup.height * 1 / 3
            anchors.top: popup.top
            anchors.left: popup.left
            anchors.right: popup.right
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.topMargin: 10
            font.pixelSize: 45 * popup.width / 884
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.italic: true
        }
        Button {
            id: confirm_button_popup
            text: qsTr("Confirm")
            width: popup.width * 0.25
            anchors.top: status_popup.bottom
            anchors.bottom: parent.bottom
            anchors.right: close_button_popup.left
            anchors.rightMargin: 25
            anchors.leftMargin: 25
            anchors.topMargin: 10
            anchors.bottomMargin: 10

            font.pixelSize: 40 * popup.width / 884
            background: Rectangle {
                color: "white"
                radius: 15
                border.color: "blue"
                border.width: 2
            }

            onClicked: {
                if (popup_mode === 1) {
                  
                    if (mode_mode === "MANUAL") {
                        // mode_mode ="AUTO"
                        backend.requestMode("AUTO")
                    } else if (mode_mode === "AUTO") {
                        // mode_mode =  "MANUAL"
                        backend.requestMode("MANUAL")
                    }
                } else if (popup_mode === 0) {
                    confirm_button_popup.text = qsTr("Reset")
                    backend.resetError()
                } 
                    
                
                popup.close()
            }
        }
        Button {
            id: close_button_popup
            text: qsTr("Close")
            width: popup.width * 0.25
            anchors.top: status_popup.bottom
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.leftMargin: 25
            anchors.topMargin: 10
            anchors.bottomMargin: 10

            font.pixelSize: 40 * popup.width / 884
            background: Rectangle {
                color: "white"
                radius: 15
                border.color: "red"
                border.width: 2
            }
            onClicked: popup.close()
        }
    }

    Rectangle {
        id: header
        height: page1.height * 0.1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 50
        anchors.rightMargin: 50
        anchors.topMargin: 50
        color: "#18FFFF"
        radius: 25

        Text {
            id: status_header
            text: qsTr("Initializing")
            anchors.fill: parent
            font.pixelSize: 50
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.italic: true
        }
    }

    Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 50
        anchors.rightMargin: parent.width * 0.5
        anchors.topMargin: 50
        anchors.bottomMargin: parent.height * 0.2
        spacing: 50

        Row {
            id: control_row
            height: (column.height - 20) / 3
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 0
            spacing: 50

            Text {
                id: control_text
                width: parent.width / 3
                text: qsTr("CONTROL:")
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                font.pixelSize: 45 * column.width / 794
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.italic: true
                font.bold: true
            }

            Button {
                id: control_button
                text: qsTr(control_mode)
                anchors.left: control_text.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                highlighted: false
                font.bold: true
                font.pointSize: 50 * column.width / 754

                background: Rectangle {
                    color: "#2196F3"
                    radius: 30
                    border.color: control_button.background.color
                    border.width: 1
                }
                onClicked: {
                    if (control_mode === "RUNNING") {
                        backend.requestControl("STOP")
                    } else if (control_mode === "PAUSED") {
                        backend.requestControl("RUN")
                    }
                }
            }
        }

        Row {
            id: status_row
            height: (column.height - 20) / 3
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: control_row.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 10
            spacing: 50

            Text {
                id: status_text
                width: parent.width / 3
                text: qsTr("STATUS:")
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                font.pixelSize: 45 * column.width / 794
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.italic: true
                font.bold: true
            }

            Button {
                id: status_button
                text: qsTr(status_mode)
                anchors.left: status_text.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                highlighted: false
                font.bold: true
                font.pointSize: 50 * column.width / 754
                background: Rectangle {
                    color: "white"
                    radius: 30
                    border.color: status_button.background.color
                    border.width: 1
                }
                onClicked: {
                    popup_mode = 0
                    if (status_mode === "ERROR") {
                        status_popup.text = backend.robotError
                    } else
                        status_popup.text = backend.robotDetail

                    popup.open()
                    
                }
            }
        }

        Row {
            id: mode_row
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: status_row.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 10
            anchors.bottomMargin: 0
            spacing: 50

            Text {
                id: mode_text
                width: parent.width / 3
                text: qsTr("MODE:")
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                font.pixelSize: 45 * column.width / 794
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.italic: true
                font.bold: true
            }

            Button {
                id: mode_button
                text: qsTr(mode_mode)
                anchors.left: mode_text.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                font.bold: true
                font.pointSize: 50 * column.width / 754
                background: Rectangle {
                    color: "#46FF64"
                    radius: 30
                    border.color: mode_button.background.color
                    border.width: 1
                }
                onClicked: {
                    popup_mode = 1
                    if (mode_mode === "MANUAL") {
                        // mode_mode ="AUTO"
                        status_popup.text = qsTr("Change robot mode to AUTO")
                        mode_button.background.color = "#4CAF50"
                    } else if (mode_mode === "AUTO") {
                        // mode_mode =  "MANUAL"
                        status_popup.text = qsTr("Change robot mode to MANUAL")
                        mode_button.background.color = "#03A9F4"
                    } else
                        status_popup.text = qsTr("Data false")
                    popup.open()
                    
                }
            }
        }
    }

    Rectangle {
        id: footer
        color: "#FFEB3B"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: column.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 50
        anchors.rightMargin: 50
        anchors.topMargin: 50
        anchors.bottomMargin: 25

        Text {
            id: status_footer
            text: qsTr("Linear: ") + vel_linear.toFixed(2) + qsTr(
                      " Angular: ") + vel_angular.toFixed(2)
            anchors.fill: parent
            font.pixelSize: 50 * footer.width / 1588
            horizontalAlignment: Text.AlignRight
            font.italic: true
        }
        Text {
            id: agv_name
            text:  qsTr("AGV Name: ") + backend.getNameAGV()
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width / 2
            font.pixelSize: 50 * footer.width / 1588
            horizontalAlignment: Text.AlignRight
            font.italic: true
            MouseArea {
            anchors.fill: parent
            onClicked: {
                popup_mode = 3
                ip_agv = backend.getIP()
                status_popup.text = qsTr("IP local: ") + ip_agv + "\n" + qsTr("IP Server: ") + "\n" + backend.getIPServer()
                popup.open()
            }
        }
        }

        Connections {
            target: backend
            onVelChanged: {
                vel_linear = backend.getLinear
                vel_angular = backend.getAngular
            }
        }
    }

    Rectangle {
        id: batt_info
        color: "#ffffff"
        anchors.left: column.right
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: footer.top
        anchors.leftMargin: 50
        anchors.rightMargin: 50
        anchors.topMargin: 50
        anchors.bottomMargin: 50

        Row {
            id: row
            anchors.fill: parent

            Column {
                id: batt_number
                width: parent.width * 0.3
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                Text {
                    id: percent_text
                    height: parent.height * 0.25
                    text: batteryPercentage.toFixed(2) + qsTr(" %")
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: vol_text.top
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 10
                    font.pixelSize: 50 * row.width / 774
                    font.bold: true
                    font.italic: true
                }

                Text {
                    id: vol_text
                    height: parent.height * 0.25
                    text: batteryVoltage.toFixed(2) + qsTr(" V")
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: ampe_text.top
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 10
                    font.pixelSize: 50 * row.width / 774
                    font.italic: true
                    font.bold: true
                }

                Text {
                    id: ampe_text
                    height: parent.height * 0.25
                    text: batteryCurrent.toFixed(2) + qsTr(" A")
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 10
                    font.pixelSize: 50 * row.width / 774
                    font.italic: true
                    font.bold: true
                }
            }

            Rectangle {
                id: rectangle
                color: "#ffffff"
                anchors.left: parent.left
                anchors.right: batt_number.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0

                Rectangle {
                    id: pin_head
                    color: "#ffffff"
                    radius: 40 * pin_head.width / 167
                    border.color: "#84f5a2"
                    border.width: 30
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: pin.bottom
                    anchors.leftMargin: parent.width * 0.32
                    anchors.rightMargin: parent.width * 0.32
                    anchors.topMargin: parent.height * 0.03
                    anchors.bottomMargin: 0
                }

                Rectangle {
                    id: pin
                    color: "#ffffff"
                    radius: 50 * pin.width / 278
                    border.color: "#84f5a2"
                    border.width: 30
                    anchors.fill: parent
                    anchors.leftMargin: parent.width * 0.2
                    anchors.rightMargin: parent.width * 0.2
                    anchors.topMargin: parent.height * 0.1
                    anchors.bottomMargin: parent.height * 0.05

                    Column {
                        id: column1
                        x: 0
                        y: 29
                        opacity: 1
                        anchors.fill: parent
                        anchors.leftMargin: 30
                        anchors.rightMargin: 30
                        anchors.topMargin: 30
                        anchors.bottomMargin: 30
                        topPadding: 10
                        spacing: 0

                        Rectangle {
                            id: batt_20
                            height: (column1.height - 50) * 0.2
                            color: "#00ff18"
                            border.color: "#c18df984"
                            radius: 60
                            border.width: 10
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: batt_40.bottom
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            anchors.topMargin: 0
                            visible: batteryPercentage > 5
                        }

                        Rectangle {
                            id: batt_40
                            height: (column1.height - 50) * 0.2
                            color: "#00ff18"
                            border.color: "#c18df984"
                            radius: 60
                            border.width: 10
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: batt_60.bottom
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            anchors.topMargin: 0
                            visible: batteryPercentage > 20
                        }

                        Rectangle {
                            id: batt_60
                            height: (column1.height - 50) * 0.2
                            color: "#00ff18"
                            border.color: "#c18df984"
                            radius: 60
                            border.width: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            visible: batteryPercentage > 40
                        }

                        Rectangle {
                            id: batt_80
                            height: (column1.height - 50) * 0.2
                            color: "#00ff18"
                            border.color: "#c18df984"
                            radius: 60
                            border.width: 10
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: batt_60.top
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            anchors.bottomMargin: 0
                            visible: batteryPercentage > 60
                        }

                        Rectangle {
                            id: batt_100
                            height: (column1.height - 50) * 0.2
                            color: "#00ff18"
                            radius: 60
                            border.color: "#c18df984"
                            border.width: 10
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: batt_80.top
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            anchors.bottomMargin: 0
                            visible: batteryPercentage > 80
                        }
                    }
                }

                Image {
                    id: charge_icon
                    anchors.fill: parent
                    source: "file:asset/charge (1).svg"
                    rotation: -90
                    fillMode: Image.PreserveAspectFit
                    visible: batteryCurrent > 0.5
                }
            }
        }
    }
    Button {
        id: mute_button_main
        height: 180 * parent.height / 1080
        width: mute_button_main.height

        anchors.right: parent.right
        anchors.top: header.bottom

        // anchors.bottom: percent_text.top
        anchors.rightMargin: 75
        anchors.topMargin: 0
        // anchors.bottomMargin: 25
        font.family: "ubuntu"
        font.bold: true
        icon.color: "#448AFF"
        icon.height: 75
        icon.width: 75
        icon.source: state_mute
        display: AbstractButton.IconOnly

        background: Rectangle {
            color: "#F5F5F5"
            radius: 10
            border.color: "#FFFFFF"
            border.width: 5
        }
        onPressedChanged: {
            if (pressed) {
                background.color = "#B0BEC5"
            } else {
                background.color = "#F5F5F5"
            }
        }
        onClicked: {
            if (state_mute == "file:asset/sound.svg") {
                state_mute = "file:asset/mute.svg"
                backend.getVolume_on_off(0)
            } else {
                state_mute = "file:asset/sound.svg"
                backend.getVolume_on_off(1)
            }
        }
    }

    Connections {
        target: backend
        onBatteryPercentageChanged: {
            batteryPercentage = backend.batteryPercentage
            
        }
        onBatteryVoltageChanged: {
            batteryVoltage = backend.batteryVoltage
        }
        onBatteryCurrentChanged: {
            batteryCurrent = backend.batteryCurrent
        }
        onRobotDetailChanged: {
            if (status_mode === "ERROR") {
                status_header.text = backend.robotError
            } else {
                status_header.text = backend.robotDetail
            }
            
        }
        onRobotModeChanged: {
            mode_mode = backend.robotMode
            if (mode_mode === "MANUAL") {
                mode_button.background.color = "#03A9F4"
            } else if (mode_mode === "AUTO") {
                mode_button.background.color = "#4CAF50"
            } else
                mode_button.background.color = "#FF9800"
        }
        onRobotStatusChanged: {
            status_mode = backend.robotStatus

            if ((status_mode === "ERROR") || (status_mode === "EMG")) {
                status_button.background.color = "#F44336"
            } else if (status_mode === "WAITING_INIT_POSE") {
                status_button.background.color = "#FFFFFF"
            } else if (status_mode === "NORMAL") {
                status_button.background.color = "#4CAF50"
            } else if (status_mode === "WAITING") {
                status_button.background.color = "#FFEB3B"
            } else
                status_button.background.color = "#FF9800"
        }
        onGetControlChanged: {
            control_mode = backend.getControl
            if (mode_mode === "AUTO" && control_mode === "RUNNING" ) {
                if (status_mode === "WAITING") {
                    control_button.background.color = "#2196F3"
                }
                else {
                    control_button.background.color = "#4CAF50"
                }
            } else if (mode_mode === "MANUAL" && control_mode === "RUNNING") {
                control_button.background.color = "#2196F3"
            } else if (control_mode === "PAUSE") {
                control_button.background.color = "#FFEB3B"
            } else
                control_button.background.color = "#FFEB3B"
        }
    }
}
