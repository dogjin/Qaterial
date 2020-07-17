import QtQuick 2.12
import Qaterial 1.0 as Qaterial

Item
{
  id: root

  implicitWidth: widthGrid + 10
  implicitHeight: heightGrid + 10

  property int widthGrid: 400
  property int heightGrid: 200

  property color axisColor: Qaterial.Style.foregroundColor

  property int axisMaxX: 100
  property int axisMaxY: 100
  property int axisMinX: 0
  property int axisMinY: 0

  property int partitionX: 4
  property int partitionY: 4

  property bool activeLabel: true

  Column
  {
    id: _column
    Repeater
    {
      id: _repeater
      model: root.partitionY
      Row
      {
        id: _row
        height: root.heightGrid / root.partitionY
        Rectangle
        {
          id: _axisY
          color: Qt.lighter(axisColor, 0.5)
          width: root.widthGrid
          height: 1
        }

        Qaterial.Label
        {
          visible: root.activeLabel
          rightPadding: 10
          leftPadding: 10
          y: -height/2
          text: root.axisMaxY - index*(root.axisMaxY - root.axisMinY)/root.partitionY
          color: Qt.lighter(root.axisColor, 0.5)
        }
      } // Row
    } // Repeater
  } // Column

  Rectangle
  {
    id: _axisX
    color: axisColor
    width: parent.width
    y: parent.heightGrid
    height: 1

    //Qaterial.DebugRectangle {anchors.fill : parent}

    Repeater
    {
      model: root.partitionX ? root.partitionX +1 : root.partitionX
      delegate: Rectangle
      {
        width: 1
        height: 4
        x: index*(root.width/root.partitionX)
        color: Qaterial.Style.foregroundColor
      }
    } // Repeater
  } // Rectangle
} // Canvas
