import QtQuick 2.12
import Qaterial 1.0 as Qaterial

Repeater
{
  id: root

  property int numberOfLabels: 4

  property int implicitWidth: 20
  property int implicitHeight: 100

  property int axisMaxY: 100
  property int axisMinY: 0

  property color color: Qaterial.Style.accentColor
  model: root.numberOfLabels +1
  Qaterial.Label
  {
    rightPadding: 10
    leftPadding: 10
    y: index*root.implicitHeight/root.numberOfLabels
    text: root.axisMaxY - index*(root.axisMaxY - root.axisMinY)/root.numberOfLabels
    color: Qt.lighter(root.color, 0.5)
  }
}




