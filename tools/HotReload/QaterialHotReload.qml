// Qt

import QtQml 2.14

import QtQuick 2.14
import QtQuick.Controls 2.14

import QtQuick.Dialogs 1.3 as QQ1D
import Qt.labs.settings 1.0 as QLab
import Qt.labs.platform 1.0

import Qaterial 1.0 as Qaterial
import SortFilterProxyModel 1.0 as SortFilterProxyModel

Qaterial.ApplicationWindow
{
  id: window

  property string currentFilePath
  property string currentFileUrl
  property string currentFileName: currentFilePath.substring(currentFilePath.lastIndexOf('/')+1)

  property string errorString

  property int theme: Qaterial.Style.theme

  width: 1280
  height: 600
  title: `Qaterial Hot Reload - ${currentFilePath}`

  minimumWidth: 200
  minimumHeight: 200

  function loadFileInLoader(source)
  {
    Qaterial.DialogManager.close()
    loader.create(source)
  }

  function reload()
  {
    loadFileInLoader(currentFileUrl)
  }

  function loadFile(path)
  {
    Qaterial.HotReload.unWatchFile(window.currentFilePath)
    currentFileUrl = path
    // remove prefixed "file:///"
    if(Qt.platform.os === "windows")
        path = path.replace(/^(file:\/{3})/,"");
    else
        path = path.replace(/^(file:\/{2})/,"");
    // unescape html codes like '%23' for '#'
    currentFilePath = decodeURIComponent(path);
    Qaterial.HotReload.watchFile(window.currentFilePath)

    loadFileInLoader(window.currentFileUrl)
  }

  QLab.Settings
  {
    property alias currentFilePath: window.currentFilePath
    property alias currentFileUrl: window.currentFileUrl

    property alias formatHorizontalAlignCenter: formatHorizontalAlignCenter.checked
    property alias formatVerticalAlignCenter: formatVerticalAlignCenter.checked
    property alias formatHorizontalAlignLeft: formatHorizontalAlignLeft.checked
    property alias formatHorizontalAlignRight: formatHorizontalAlignRight.checked
    property alias formatVerticalAlignBottom: formatVerticalAlignBottom.checked
    property alias formatVerticalAlignTop: formatVerticalAlignTop.checked
    property alias fullScreen: fullScreen.checked

    property alias theme: window.theme
  }

  Qaterial.WindowLayoutSave { name: "Reloader" }

  Shortcut
  {
      sequence: "F5"
      onActivated: () => window.reload()
  }

  Shortcut
  {
      sequence: "Ctrl+O"
      onActivated: () => fileDialog.open()
  }

  QQ1D.FileDialog
  {
      id: fileDialog
      title: "Please choose a file"
      onAccepted: () => window.loadFile(fileDialog.fileUrl.toString())
  }

  Connections
  {
    target: Qaterial.HotReload
    function onWatchedFileChanged() { window.reload() }
  }

  header: Qaterial.ToolBar
  {
    Row
    {
      Qaterial.SquareButton
      {
        ToolTip.visible: hovered
        ToolTip.text: "Open File to Hot Reload"
        icon.source: Qaterial.Icons.folderOutline
        useSecondaryColor: true

        onClicked: () => fileDialog.open()
      }
      Qaterial.SquareButton
      {
        ToolTip.visible: hovered
        ToolTip.text: "Reload (F5)"
        icon.source: Qaterial.Icons.sync
        useSecondaryColor: true

        onClicked: () => window.reload()
      }

      Qaterial.ToolSeparator {}

      Qaterial.ToolButton
      {
        id: formatHorizontalAlignCenter

        enabled: !fullScreen.checked && !formatHorizontalAlignLeft.checked && !formatHorizontalAlignRight.checked
        icon.source: Qaterial.Icons.formatHorizontalAlignCenter

        ToolTip.visible: hovered
        ToolTip.text: "Align Horizontal Center"

        onClicked: () => window.reload()
      }

      Qaterial.ToolButton
      {
        id: formatVerticalAlignCenter

        enabled: !fullScreen.checked && !formatVerticalAlignBottom.checked && !formatVerticalAlignTop.checked
        icon.source: Qaterial.Icons.formatVerticalAlignCenter

        ToolTip.visible: hovered
        ToolTip.text: "Align Vertical Center"

        onClicked: () => window.reload()
      }

      Qaterial.ToolSeparator {}

      Qaterial.ToolButton
      {
        id: formatHorizontalAlignLeft

        enabled: !fullScreen.checked && !formatHorizontalAlignCenter.checked
        icon.source: Qaterial.Icons.formatHorizontalAlignLeft

        ToolTip.visible: hovered
        ToolTip.text: "Align Left"

        onClicked: () => window.reload()
      }

      Qaterial.ToolButton
      {
        id: formatHorizontalAlignRight

        enabled: !fullScreen.checked && !formatHorizontalAlignCenter.checked
        icon.source: Qaterial.Icons.formatHorizontalAlignRight

        ToolTip.visible: hovered
        ToolTip.text: "Align Right"

        onClicked: () => window.reload()
      }

      Qaterial.ToolButton
      {
        id: formatVerticalAlignBottom

        enabled: !fullScreen.checked && !formatVerticalAlignCenter.checked
        icon.source: Qaterial.Icons.formatVerticalAlignBottom

        ToolTip.visible: hovered
        ToolTip.text: "Align Bottom"

        onClicked: () => window.reload()
      }

      Qaterial.ToolButton
      {
        id: formatVerticalAlignTop

        enabled: !fullScreen.checked && !formatVerticalAlignCenter.checked
        icon.source: Qaterial.Icons.formatVerticalAlignTop

        ToolTip.visible: hovered
        ToolTip.text: "Align Top"

        onClicked: () => window.reload()
      }

      Qaterial.ToolSeparator {}

      Qaterial.ToolButton
      {
        id: fullScreen

        enabled: !formatHorizontalAlignCenter.checked &&
                 !formatVerticalAlignCenter.checked &&
                 !formatHorizontalAlignLeft.checked &&
                 !formatHorizontalAlignRight.checked &&
                 !formatVerticalAlignBottom.checked &&
                 !formatVerticalAlignTop.checked
        icon.source: checked ? Qaterial.Icons.fullscreen : Qaterial.Icons.fullscreenExit

        ToolTip.visible: hovered
        ToolTip.text: checked ? "Fullscreen" : "Fullscreen Exit"

        onClicked: () => window.reload()
      }

      Qaterial.ToolSeparator {}

      Qaterial.SquareButton
      {
        readonly property bool lightTheme: window.theme === Qaterial.Style.Theme.Light
        icon.source: lightTheme ? Qaterial.Icons.weatherSunny : Qaterial.Icons.moonWaningCrescent
        useSecondaryColor: true
        ToolTip.visible: hovered
        ToolTip.text: lightTheme ? "Theme Light" : "Theme Dark"

        onClicked: function()
        {
          theme = lightTheme ? Qaterial.Style.Theme.Dark : Qaterial.Style.Theme.Light
          Qaterial.Style.theme = theme
        }
      }

      Qaterial.ToolSeparator {}

      Qaterial.SquareButton
      {
        icon.source: Qaterial.Icons.formatLetterCase

        onClicked: () => _typoMenu.open()

        TypoMenu
        {
          id: _typoMenu
          y: parent.height
        }

        ToolTip.visible: hovered
        ToolTip.text: "Typography"
      }

      Qaterial.SquareButton
      {
        contentItem: Item
        {
          Image
          {
            anchors.centerIn: parent
            source: 'qrc:Qaterial/HotReload/material-icons-light.svg'
            sourceSize.width: Qaterial.Style.toolButton.iconWidth
            sourceSize.height: Qaterial.Style.toolButton.iconWidth
          }
        }

        onClicked: () => _iconsMenu.open()

        IconsMenu
        {
          id: _iconsMenu
          y: parent.height
        }

        ToolTip.visible: hovered
        ToolTip.text: "Icons Explorer"
      }
    } // RowLayout
  } // ToolBar

  SplitView
  {
    anchors.fill: parent
    orientation: Qt.Vertical

    Item
    {
      id: loader
      width: parent.width
      SplitView.fillHeight: true
      property var loadedObject: null

      function create(url)
      {
        Qaterial.Logger.info(`Load from ${url}`)
        // Destroy previous item
        if(loadedObject)
        {
          loadedObject.destroy()
          loadedObject = null
        }

        Qaterial.HotReload.clearCache()
        let component = Qt.createComponent(url)

        if (component.status === Component.Ready)
        {
          loadedObject = component.createObject(loader)

          if(loadedObject.anchors)
          {
            if(fullScreen.checked)
              loadedObject.anchors.fill = loader
            if(formatHorizontalAlignCenter.checked)
              loadedObject.anchors.horizontalCenter = loader.horizontalCenter
            if(formatVerticalAlignCenter.checked)
              loadedObject.anchors.verticalCenter = loader.verticalCenter
            if(formatHorizontalAlignLeft.checked)
              loadedObject.anchors.left = loader.left
            if(formatHorizontalAlignRight.checked)
              loadedObject.anchors.right = loader.right
            if(formatVerticalAlignBottom.checked)
              loadedObject.anchors.bottom = loader.bottom
            if(formatVerticalAlignTop.checked)
              loadedObject.anchors.top = loader.top
          }

          window.errorString = ""
        }
        else
        {
          window.errorString = component.errorString()
          Qaterial.Logger.error(`Fail to load with error ${window.errorString}`)
        }
      }

      Component.onCompleted: function()
      {
        if(window.currentFileUrl)
        {
          loader.create(window.currentFileUrl)
          Qaterial.HotReload.watchFile(window.currentFilePath)
        }
      }

      Column
      {
        anchors.centerIn: parent
        spacing: 16
        visible: !window.currentFilePath
        Qaterial.Label
        {
          anchors.horizontalCenter: parent.horizontalCenter
          text: "Please Pick a qml file to get started"
        }
        Qaterial.RaisedButton
        {
          anchors.horizontalCenter: parent.horizontalCenter
          text: "Open File"
          icon.source: Qaterial.Icons.folderOutline

          onClicked: () => fileDialog.open()
        }
      }
    }

    StatusView
    {
      id: _statusView
      anchors.bottom: parent.bottom
      width: parent.width
      SplitView.minimumHeight: 40

      errorString: window.errorString
      file: window.currentFileName

      Connections
      {
        target: Qaterial.HotReload
        function onNewLog(msg)
        {
          const color = function()
          {
            if(msg.includes("debug"))
              return Qaterial.Style.blue
            if(msg.includes("info"))
              return Qaterial.Style.green
            if(msg.includes("warning"))
              return Qaterial.Style.orange
            if(msg.includes("error"))
              return Qaterial.Style.red
            return Qaterial.Style.primaryTextColor()
          }();

          _statusView.log(msg, color)
        }
      }

      function log(msg, color)
      {
        _statusView.append(`<font style='color:${color};'>${msg}</font>`)
      }
    } // StatusView
  } // SplitView

  Component.onCompleted: function()
  {
    Qaterial.Style.theme = window.theme
  }
} // ApplicationWindow