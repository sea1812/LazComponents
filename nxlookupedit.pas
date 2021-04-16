unit nxLookupEdit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, LCLType, Forms, Controls, Graphics, Dialogs, StdCtrls, DB, rxdbgrid;

type

  { TnxLookupEdit }

  TnxLookupEdit = class(TCustomEdit)
  private
    FDataset: TDataset;
    FDisplayField: string;
    FEmptyReturnCount: integer;
    FFilter: string;
    FGrid: TRxDBGrid;
    FGridFromRight: boolean;
    FGridPosition: TAlign;
    FOnChangeEx: TNotifyEvent;
    FOnKeyDownEx: TKeyEvent;
  protected
    procedure FOnChange(Sender:TObject);
    procedure FOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function  BuildFilter:string;
  public
    procedure Loaded;override;
    property EmptyReturnCount:integer read FEmptyReturnCount write FEmptyReturnCount;
    property AutoSelected;
  published
    property DisplayField:string read FDisplayField write FDisplayField;
    property Fillter:string read FFilter write FFilter;
    property Dataset:TDataset read FDataset write FDataset;
    property Grid:TRxDBGrid read FGrid write FGrid;
    property GridPosition:TAlign read FGridPosition write FGridPosition;
    property GridFromRight:boolean read FGridFromRight write FGridFromRight;
    property OnKeyDownEx:TKeyEvent read FOnKeyDownEx write FOnKeyDownEx;
    property OnChangeEx:TNotifyEvent read FOnChangeEx write FOnChangeEx;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property AutoSelect;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EchoMode;
    property Enabled;
    property Font;
    property HideSelection;
    property MaxLength;
    property NumbersOnly;
    property ParentBidiMode;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditingDone;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property OnUTF8KeyPress;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabStop;
    property TabOrder;
    property Text;
    property TextHint;
    property Visible;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Additional',[TnxLookupEdit]);
end;

{ TnxLookupEdit }


procedure TnxLookupEdit.FOnChange(Sender: TObject);
var
  mFilter:string;
begin
  if Self.Enabled=False then Exit;
  if Assigned(FDataset) then
  begin
    if Trim(FFilter)<>'' then
    begin
      if Trim(Self.Text)<>'' then
      begin
        mFilter:=Self.BuildFilter;
        FDataset.Filtered:=False;
        FDataset.Filter:=mFilter;
        FDataset.Filtered:=True;
        if Assigned(FGrid) then
        begin
          FGrid.BringToFront;
          FGrid.Visible:=True;
        end;
      end
      else
      begin
        if Pos(' ',Self.Text)=1 then
        begin
          if Assigned(FDataset) then
            FDataset.Filtered:=False;
          if Assigned(FGrid) then
            FGrid.Visible:=True;
        end
        else
        begin
          if Assigned(FGrid) then
            FGrid.Visible:=False;
        end;
      end;
    end;
  end;
  if Assigned(FOnChangeEx) then
    FOnChangeEx(Sender);
end;

procedure TnxLookupEdit.FOnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_Down) or (key=VK_Up) then
    if Assigned(FGrid) then
      if FGrid.Visible then
        FGrid.SetFocus;
  if key=VK_ESCAPE then
    if Assigned(FGrid) then
      FGrid.Visible:=False;
  if key=VK_RETURN then
  begin
    if Assigned(FDataset) then
    begin
      if Trim(FDisplayField)<>'' then
      begin
        if not FDataset.FieldByName(FDisplayField).IsNull then
        begin
          Self.Text:=FDataset.FieldByName(FDisplayField).Text;
          if Assigned(FGrid) then
          begin
            FGrid.Visible:=False;
          end;
        end
        else
        begin
          Self.Text:='';
          if Assigned(FGrid) then
          begin
            FGrid.Visible:=False;
          end;
        end;
      end;
    end;
    if Trim(Self.Text)='' then
    begin
      FEmptyReturnCount:=FEmptyReturnCount+1;
    end
    else
      FEmptyReturnCount:=0;
  end;
  if Assigned(FOnKeyDownEx) then
    FOnKeyDownEx(Sender, Key, Shift);
end;

function TnxLookupEdit.BuildFilter: string;
var
  m:string;
begin
  m:=FFilter;
  m:=StringReplace(m,'#text#',Trim(Self.Text),[rfReplaceAll]);
  Result:=m;
end;

procedure TnxLookupEdit.Loaded;
begin
  inherited Loaded;
  Self.OnChange:=@FOnChange;
  Self.OnKeyDown:=@FOnKeyDown;
  FGridPosition:=alBottom;
end;

end.
