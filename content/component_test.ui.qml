import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Page {
    id: change_language

    Button {
        id: map_2
        width: change_language.width * 0.45
        height: change_language.width * 0.25
        text: qsTr("ENGLISH")
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        font.pointSize: 25

        display: AbstractButton.TextOnly
    }

    Button {
        id: map_1

        width: change_language.width * 0.45
        height: change_language.width * 0.25
        text: qsTr("JAPANESE")
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        font.pointSize: 25
        display: AbstractButton.TextOnly
    }
}
