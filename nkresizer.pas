unit nkResizer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TnkResizer }

  TnkResizer = class(TImage)
  private
    FTopForm:TForm;
    FResizing:boolean;
    FPos:TPoint;
  protected
    procedure Loaded;override;
    procedure _onMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure _onMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure _onMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
  public
    constructor Create(AOwner:TComponent);override;
  published

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Additional',[TnkResizer]);
end;

{ TnkResizer }

procedure TnkResizer.Loaded;
begin
  inherited Loaded;
  if Self.GetTopParent is TForm then
    FTopForm:=(Self.GetTopParent as TForm)
  else
    FTopForm:=nil;
end;

procedure TnkResizer._onMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FTopForm<>nil then
  begin
    if FTopForm.WindowState=wsNormal then
    begin
      if mbLeft = Button then
      begin
        FResizing:=True;
        FPos.x:=Mouse.CursorPos.x;
        FPos.y:=Mouse.CursorPos.y;
      end;
    end;
  end;
end;

procedure TnkResizer._onMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  m:TPoint;
begin
  if ssLeft in Shift then
  begin
    m.x:=Mouse.CursorPos.x;m.y:=Mouse.CursorPos.y;
    if(m.x<>FPos.x) or (m.y<>FPos.Y) then
    begin
      FTopForm.Width:=FTopForm.Width+(m.x-FPos.X);
      FTopForm.Height:=FTopForm.Height+(m.y-FPos.Y);
    end;
    FPos.x:=m.x;
    FPos.y:=m.y;
  end;
end;

procedure TnkResizer._onMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FResizing:=False;
end;

constructor TnkResizer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.OnMouseDown:=@_onMouseDown;
  Self.OnMouseMove:=@_onMouseMove;
  Self.OnMouseUp:=@_onMouseUp;
end;

end.
