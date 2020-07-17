import QtQuick 2.12
import Qaterial 1.0 as Qaterial

Repeater
{
  id: root

  property int numberOfLabels: 10

  implicitHeight: 40
  implicitWidth: 200

  property int axisMaxX: 100
  property int axisMinX: 0

  property color color: Qaterial.Style.accentColor
  model: root.numberOfLabels + 1
  Qaterial.Label
  {
    topPadding: 6
    bottomPadding: 6
    x: index*root.implicitWidth/root.numberOfLabels
    text: root.axisMinX + index*(root.axisMaxX - root.axisMinX)/root.numberOfLabels
    color: Qt.lighter(root.color, 0.5)
    Qaterial.DebugRectangle{ anchors.fill: parent}
  }
}
