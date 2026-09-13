pragma ComponentBehavior: Bound

/*
 * SPDX-License-Identifier: GPL-2.0-or-later
 *
 * Force Quit — a KDE Plasma 6 applet.
 *
 * Click the panel icon, then click any window: it is killed immediately.
 * Uses KWin's own org.kde.KWin.killWindow() rather than xkill, so it also
 * works on Wayland-native windows (xkill only reaches XWayland clients).
 *
 * Layout follows the stock org.kde.plasma.showdesktop applet: the sizing
 * hints must live on the root PlasmoidItem, not on a compactRepresentation
 * component, or the item collapses to zero size in the panel.
 */

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation

    Plasmoid.icon: "process-stop"
    Plasmoid.title: i18n("Force Quit")
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    toolTipSubText: i18n("Click, then click the window you want to kill")

    Plasmoid.onActivated: root.killWindow()

    readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical

    // Track the panel's thickness and stay square, so the icon renders at the
    // same size wherever it sits — a fixed pixel size renders inconsistently
    // next to a margins separator, which changes the margins of its neighbours.
    Layout.minimumWidth: root.vertical ? 0 : root.height
    Layout.maximumWidth: root.vertical ? Number.POSITIVE_INFINITY : root.height

    Layout.minimumHeight: root.vertical ? root.width : 0
    Layout.maximumHeight: root.vertical ? root.width : Number.POSITIVE_INFINITY

    Plasma5Support.DataSource {
        id: executable

        engine: "executable"
        connectedSources: []

        onNewData: source => disconnectSource(source)

        function run(cmd) {
            disconnectSource(cmd) // in case it is still connected
            connectSource(cmd)
        }
    }

    // qdbus ships under a different name depending on the distro, so probe.
    readonly property string killCommand:
        "sh -c 'for q in qdbus6 qdbus-qt6 qdbus; do " +
        "command -v \"$q\" >/dev/null 2>&1 && " +
        "exec \"$q\" org.kde.KWin /KWin org.kde.KWin.killWindow; done; exit 1'"

    function killWindow() {
        executable.run(root.killCommand)
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        activeFocusOnTab: true
        acceptedButtons: Qt.LeftButton

        Accessible.name: Plasmoid.title
        Accessible.description: root.toolTipSubText
        Accessible.role: Accessible.Button
        Accessible.onPressAction: Plasmoid.activated()

        onClicked: Plasmoid.activated()

        Keys.onPressed: event => {
            switch (event.key) {
            case Qt.Key_Space:
            case Qt.Key_Enter:
            case Qt.Key_Return:
            case Qt.Key_Select:
                Plasmoid.activated();
                event.accepted = true;
                break;
            }
        }

        Kirigami.Icon {
            anchors.fill: parent
            source: Plasmoid.icon
            active: mouseArea.containsMouse || mouseArea.activeFocus
        }
    }
}
