object Form1: TForm1
  Left = 695
  Height = 470
  Top = 231
  Width = 705
  Caption = 'Form1'
  ClientHeight = 470
  ClientWidth = 705
  DesignTimePPI = 120
  OnCreate = FormCreate
  LCLVersion = '6.3'
  object Panel1: TPanel
    Left = 0
    Height = 131
    Top = 0
    Width = 705
    Align = alTop
    ClientHeight = 131
    ClientWidth = 705
    TabOrder = 0
    object Button1: TButton
      Left = 17
      Height = 31
      Top = 15
      Width = 94
      Caption = 'Connect'
      OnClick = Button1Click
      TabOrder = 0
    end
    object Button2: TButton
      Left = 121
      Height = 31
      Top = 15
      Width = 94
      Caption = 'Sub'
      OnClick = Button2Click
      TabOrder = 1
    end
    object Button3: TButton
      Left = 224
      Height = 31
      Top = 15
      Width = 94
      Caption = 'Publish'
      OnClick = Button3Click
      TabOrder = 2
      Visible = False
    end
    object GroupBox1: TGroupBox
      Left = 20
      Height = 63
      Top = 55
      Width = 648
      Caption = 'Message'
      ClientHeight = 38
      ClientWidth = 644
      TabOrder = 3
      object Button4: TButton
        Left = 550
        Height = 38
        Top = 0
        Width = 94
        Align = alRight
        Caption = 'Send'
        OnClick = Button4Click
        TabOrder = 0
      end
      object Memo2: TMemo
        Left = 0
        Height = 38
        Top = 0
        Width = 550
        Align = alClient
        Lines.Strings = (
          'Memo2'
        )
        TabOrder = 1
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Height = 63
    Top = 407
    Width = 705
    Align = alBottom
    Caption = 'Panel2'
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 0
    Height = 276
    Top = 131
    Width = 705
    Align = alClient
    Lines.Strings = (
      'Memo1'
    )
    ScrollBars = ssAutoVertical
    TabOrder = 2
  end
  object Timer1: TTimer
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 405
    Top = 19
  end
end
