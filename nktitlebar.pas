unit nkTitleBar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TnkTitleBar }

  TnkTitleBar = class(TPanel)
  private
    FImage:TImage;
    FTopForm:TForm;
    FMoving:boolean;
    FXPos:integer;
    FYPos:integer;
    function GetPicture: TPicture;
    procedure SetPicture(AValue: TPicture);
  protected
    procedure _onMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure _onMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure _onMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure Loaded;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    property Picture:TPicture read GetPicture write SetPicture;
  end;

procedure Register;

implementation

procedure Register;
begin
  {$I nktitlebar_icon.ctrs}
  RegisterComponents('Additional',[TnkTitleBar]);
end;

{ TnkTitleBar }

function TnkTitleBar.GetPicture: TPicture;
begin
  Result:=FImage.Picture;
end;

procedure TnkTitleBar.SetPicture(AValue: TPicture);
begin
  FImage.Picture.Assign(AValue);
end;

procedure TnkTitleBar._onMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FTopForm<>nil then
  begin
    if FTopForm.WindowState=wsNormal then
    begin
      if mbLeft = Button then
      begin
        FMoving:=True;
        FXPos:=X;
        FYPos:=Y;
      end;
    end;
  end;
end;

procedure TnkTitleBar._onMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FTopForm<>nil then
  begin
    if FTopForm.WindowState=wsNormal then
    begin
      if (ssLeft in Shift) and (FMoving=True) then
      begin
        FTopForm.Top:=FTopForm.Top+Y-Self.FYPos;
        FTopForm.Left:=FTopForm.Left+X-Self.FXPos;
        if FTopForm.Top<0 then
          FTopForm.Top:=0;
      end;
    end;
  end;
end;

procedure TnkTitleBar._onMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Self.FMoving:=False;
end;

procedure TnkTitleBar.Loaded;
begin
  inherited Loaded;
  if Self.GetTopParent is TForm then
    FTopForm:=(Self.GetTopParent as TForm)
  else
    FTopForm:=nil;
end;

constructor TnkTitleBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.Align:=alTop;
  Self.Width:=100;
  Self.Height:=27;
  Self.BevelOuter:=bvNone;
  FImage:=TImage.Create(Self);
  FImage.Parent:=Self;
  FImage.Align:=alClient;
  FImage.OnMouseDown:=@_onMouseDown;
  FImage.OnMouseMove:=@_onMouseMove;
  FImage.OnMouseUp:=@_onMouseUp;
end;

destructor TnkTitleBar.Destroy;
begin
  FImage.Free;
  inherited Destroy;
end;

end.
