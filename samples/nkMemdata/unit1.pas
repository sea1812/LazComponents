unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DBGrids, StdCtrls, nkMemData;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    mem: TnkMemData;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.frm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
  mem.Active:=False;
  mem.Active:=True;
  mem.Append;
  mem.FieldByName('uname').AsString:='张三丰';
  mem.FieldByName('uage').AsInteger:=1000;
  mem.FieldByName('ulogin').AsDateTime:=now();
  mem.FieldByName('uisman').AsBoolean:=True;
  mem.FieldByName('umoney').AsFloat:=9999.99;
  mem.Append;
  mem.First;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Text:=mem.ExportStructToJson;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if mem.Active then
    Memo1.Text:=mem.ExportDataToJson
  else
    ShowMessage('需要打开数据集。');
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  mJson:string;
begin
  mJson:='[{"name":"uname","type":"ftString","size":255,"no":1},{"name":"uage","type":"ftInteger","size":0,"no":2},{"name":"ulogin","type":"ftDate","size":0,"no":3},{"name":"uisman","type":"ftBoolean","size":0,"no":4},{"name":"umoney","type":"ftFloat","size":0,"no":5}]';
  if mem.InitStructFromJson(mJson) then
    mem.Active:=True
  else
    ShowMessage('Error');
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  mJson:string;
begin
  mem.Active:=True;
  mJson:='[{"uname":"张三丰","uage":"1000","ulogin":"1617580800","uisman":"true","umoney":"9999.99"},{"uname":"觉远","uage":"1020","ulogin":"1617580800","uisman":"true","umoney":"8888.99"}]';
  if not mem.FillDataFromJson(mJson) then
    ShowMessage('ERROR');
end;

end.

