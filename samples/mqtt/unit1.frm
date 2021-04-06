object Form1: TForm1
  Left = 850
  Height = 300
  Top = 287
  Width = 400
  Caption = 'Form1'
  ClientHeight = 300
  ClientWidth = 400
  DesignTimePPI = 120
  OnCloseQuery = FormCloseQuery
  LCLVersion = '6.3'
  object Memo1: TMemo
    Left = 0
    Height = 237
    Top = 63
    Width = 400
    Align = alClient
    Lines.Strings = (
      'Memo1'
    )
    ScrollBars = ssAutoVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Height = 63
    Top = 0
    Width = 400
    Align = alTop
    Caption = 'Panel1'
    ClientHeight = 63
    ClientWidth = 400
    TabOrder = 1
    object Button1: TButton
      Left = 18
      Height = 31
      Top = 18
      Width = 94
      Caption = 'Button1'
      OnClick = Button1Click
      TabOrder = 0
    end
  end
  object mqtt: TnkMqtt
    PubTimerInterval = 100
    PingTimerInterval = 100
    Server = '192.168.0.95'
    Port = 1883
    Topics.Strings = (
      'testtopic/#'
    )
    OnLog = mqttLog
    OnBeforePublish = mqttBeforePublish
    OnAfterPublish = mqttAfterPublish
    OnReceiveMessage = mqttReceiveMessage
    Left = 81
    Top = 141
  end
end
