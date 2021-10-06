unit nxPopupNotice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls;

type
  //弹出通知窗口控件

  { TnxPopupNotice }

  TnxPopupNotice = class(TComponent)
  private
    FFormHeight: integer;
    FFormWidth: integer;
    FList:TList;
  public
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy;override;
    procedure CreateForm(ATtile,AMessage:string);
  published
    property FormWidth:integer read FFormWidth write FFormWidth;
    property FormHeight:integer read FFormHeight write FFormHeight;
  end;

procedure Register;

implementation

procedure Register;
begin
  //RegisterComponents('Additional',[TnxPopupNotice]);
end;

{ TnxPopupNotice }

procedure TnxPopupNotice.CreateForm(ATtile,AMessage:string);
var
  mForm:TForm;
  mTitle:TLabel;
begin
  //创建窗体
  mForm:=TForm.Create(nil);
  mForm.Width:=FFormWidth;
  mForm.Height:=FFormHeight;
  mForm.BorderStyle:=bsNone;
  //创建标题对象
  mTitle:=TLabel.Create(mForm);
  mTitle.Parent:=mForm;
  mTitle.Top:=20;
  mTitle.Left:=20;
  //创建消息对象
end;

constructor TnxPopupNotice.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FList:=TList.Create;
  FFormWidth:=400;
  FFormHeight:=300;
end;

destructor TnxPopupNotice.Destroy;
begin
  FList.Clear;
  FList.Free;
  inherited Destroy;
end;

end.
