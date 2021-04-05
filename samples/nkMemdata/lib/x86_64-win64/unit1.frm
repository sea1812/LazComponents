object Form1: TForm1
  Left = 868
  Height = 451
  Top = 208
  Width = 562
  Caption = 'Form1'
  ClientHeight = 451
  ClientWidth = 562
  DesignTimePPI = 120
  LCLVersion = '6.3'
  object Panel1: TPanel
    Left = 0
    Height = 132
    Top = 0
    Width = 562
    Align = alTop
    ClientHeight = 132
    ClientWidth = 562
    TabOrder = 0
    object Button1: TButton
      Left = 11
      Height = 31
      Top = 18
      Width = 94
      Caption = '打开数据集'
      OnClick = Button1Click
      TabOrder = 0
    end
    object Button2: TButton
      Left = 112
      Height = 31
      Top = 18
      Width = 94
      Caption = '导出结构'
      OnClick = Button2Click
      TabOrder = 1
    end
    object Button3: TButton
      Left = 216
      Height = 31
      Top = 18
      Width = 94
      Caption = '导出数据'
      OnClick = Button3Click
      TabOrder = 2
    end
    object Button4: TButton
      Left = 324
      Height = 31
      Top = 18
      Width = 94
      Caption = '导入结构'
      OnClick = Button4Click
      TabOrder = 3
    end
    object Button5: TButton
      Left = 432
      Height = 31
      Top = 18
      Width = 94
      Caption = '导入数据'
      OnClick = Button5Click
      TabOrder = 4
    end
    object Label1: TLabel
      Left = 15
      Height = 20
      Top = 64
      Width = 90
      Caption = '网络结构地址'
      ParentColor = False
    end
    object Label2: TLabel
      Left = 15
      Height = 20
      Top = 98
      Width = 90
      Caption = '网络数据地址'
      ParentColor = False
    end
    object Edit1: TEdit
      Left = 112
      Height = 28
      Top = 61
      Width = 306
      TabOrder = 5
      Text = 'http://127.0.0.1/laztest/struct.php'
    end
    object Edit2: TEdit
      Left = 112
      Height = 28
      Top = 96
      Width = 306
      TabOrder = 6
      Text = 'http://127.0.0.1/laztest/data.php'
    end
    object Button6: TButton
      Left = 432
      Height = 31
      Top = 60
      Width = 94
      Caption = '导入网络结构'
      OnClick = Button6Click
      TabOrder = 7
    end
    object Button7: TButton
      Left = 432
      Height = 31
      Top = 94
      Width = 94
      Caption = '导入网络数据'
      OnClick = Button7Click
      TabOrder = 8
    end
  end
  object Panel2: TPanel
    Left = 290
    Height = 319
    Top = 132
    Width = 272
    Align = alRight
    Caption = 'Panel2'
    ClientHeight = 319
    ClientWidth = 272
    TabOrder = 1
    object Memo1: TMemo
      Left = 1
      Height = 317
      Top = 1
      Width = 270
      Align = alClient
      Lines.Strings = (
        'Memo1'
      )
      TabOrder = 0
    end
  end
  object Splitter1: TSplitter
    Left = 284
    Height = 319
    Top = 132
    Width = 6
    Align = alRight
    ResizeAnchor = akRight
  end
  object DBGrid1: TDBGrid
    Left = 0
    Height = 319
    Top = 132
    Width = 284
    Align = alClient
    AutoEdit = False
    Color = clWindow
    Columns = <>
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgAutoSizeColumns, dgDisableDelete, dgDisableInsert, dgDblClickAutoSize]
    TabOrder = 3
  end
  object DataSource1: TDataSource
    DataSet = mem
    Left = 113
    Top = 168
  end
  object mem: TnkMemData
    FieldDefs = <    
      item
        Name = 'uname'
        DataType = ftString
        Size = 255
      end    
      item
        Name = 'uage'
        DataType = ftInteger
      end    
      item
        Name = 'ulogin'
        DataType = ftDate
      end    
      item
        Name = 'uisman'
        DataType = ftBoolean
      end    
      item
        Name = 'umoney'
        DataType = ftFloat
        Precision = 10
      end>
    Left = 207
    Top = 166
  end
end
