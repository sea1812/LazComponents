unit nkDBGrid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, StdCtrls, Forms, Controls, Graphics, Dialogs, rxdbgrid, LCLtype;

type

  { TnkDBGrid }

  TnkDBGrid = class(TRxDBGrid)
  private
    FDisplayField: string;
    FLookupEdit: TCustomEdit;
    FOnDblClickEx: TNotifyEvent;
    FOnKeyDownEx: TKeyEvent;
  protected
    procedure FOnKeyDwon(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FOnDblClick(Sender:TObject);
  public
    procedure Loaded;override;
    procedure ResetPosition;
  published
    property DisplayField:string read FDisplayField write FDisplayField;
    property LookupEdit:TCustomEdit read FLookupEdit write FLookupEdit;
    property OnDblClickEx:TNotifyEvent read FOnDblClickEx write FOnDblClickEx;
    property OnKeyDownEx:TKeyEvent read FOnKeyDownEx write FOnKeyDownEx;
  end;

procedure Register;

implementation

uses
  nxLookupEdit;

procedure Register;
begin
  RegisterComponents('Additional',[TnkDBGrid]);
end;

{ TnkDBGrid }

procedure TnkDBGrid.FOnKeyDwon(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not Assigned(Self.DataSource) then
    Exit;
  if not Assigned(Self.DataSource.DataSet) then
    Exit;
  if Key=VK_ESCAPE then
  begin
    Self.Visible:=False;
  end;
  if key=VK_RETURN then
  begin
    if Assigned(FLookupEdit) then
    begin
      if Trim(FDisplayField)<>'' then
      begin
        if not Self.DataSource.DataSet.FieldByName(FDisplayField).IsNull then
        begin
          FLookupEdit.Text:=Self.DataSource.DataSet.FieldByName(FDisplayField).Text;
          FLookupEdit.SetFocus;
        end;
      end;
    end;
    Self.Visible:=False;
  end;
  if Assigned(FOnKeyDownEx) then
    FOnKeyDownEx(Sender, Key, Shift);
  if Assigned(FLookupEdit) then
  begin
    if FLookupEdit is TnxLookupEdit then
    begin
      if Assigned((FLookupEdit as TnxLookupEdit).OnKeyDownEx) then
        (FLookupEdit as TnxLookupEdit).OnKeyDownEx(nil,Key,Shift);
    end;
  end;

end;

procedure TnkDBGrid.FOnDblClick(Sender: TObject);
var mkey:word;
begin
  if Assigned(FLookupEdit) then
  begin
    if Trim(FDisplayField)<>'' then
    begin
      if not Self.DataSource.DataSet.FieldByName(FDisplayField).IsNull then
      begin
        FLookupEdit.Text:=Self.DataSource.DataSet.FieldByName(FDisplayField).Text;
        FLookupEdit.SetFocus;
      end;
    end;
  end;
  Self.Visible:=False;
  if Assigned(FOnDblClickEx) then
    FOnDblClickEx(Sender);
  if Assigned(FLookupEdit) then
  begin
    if FLookupEdit is TnxLookupEdit then
    begin
      if Assigned((FLookupEdit as TnxLookupEdit).OnKeyDownEx) then
      begin
        mkey:=VK_RETURN;
        (FLookupEdit as TnxLookupEdit).OnKeyDownEx(nil,mkey,[]);
      end;
    end;
  end;
end;

procedure TnkDBGrid.Loaded;
begin
  inherited Loaded;
  Self.OnKeyDown:=@FOnKeyDwon;
  Self.OnDblClick:=@FOnDblClick;
end;

procedure TnkDBGrid.ResetPosition;
begin
  //计算Grid的位置
  if Assigned(FLookupEdit) then
  begin
    if FLookupEdit is TnxLookupEdit then
    begin
      case (FLookupEdit as TnxLookupEdit).GridPosition of
        alTop,alLeft:
          begin
            self.Top:=FLookupEdit.Top+FLookupEdit.Height;
            if (FLookupEdit as TnxLookupEdit).GridFromRight then
              self.Left:=FLookupEdit.Left-(Self.Width-FLookupEdit.Width)
            else
              self.Left:=FLookupEdit.Left;
          end;
        alBottom,alRight:
          begin
            self.Top:=FLookupEdit.Top+FLookupEdit.Height;
            if (FLookupEdit as TnxLookupEdit).GridFromRight then
              self.Left:=FLookupEdit.Left-(Self.Width-FLookupEdit.Width)
            else
              self.Left:=FLookupEdit.Left;
          end;
      end;
    end;
  end;
end;

end.
