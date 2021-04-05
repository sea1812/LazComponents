unit nkMemData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, typinfo, DB, DateUtils, LResources, Forms, Controls, Graphics, Dialogs, memds, IdHttp,
  idGlobal, fpjson;

type

  { TnkMemData }

  TnkMemData = class(TMemDataset)
  private
    FHttp:TIdHttp;
  protected

  public
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy;override;
    function InitStructFromJson(AJson:string):boolean;//从Json初始化表结构
    function InitStructFromUrl(AUrl:string):boolean;//从URL获取JSON初始化表结构
    function FillDataFromJson(AJson:string):boolean;//从Json填充数据
    function FillDataFromUrl(AUrl:string):boolean;//从URL获取Json填充数据
    function ExportStructToJson:string;//导出表结构到JSON
    function ExportDataToJson:string;//导出表数据到JSON
  published

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Data Access',[TnkMemData]);
end;

{ TnkMemData }

constructor TnkMemData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHttp:=TIdHttp.Create(Self);
  FHttp.HandleRedirects:=True;
  FHttp.ReadTimeout:=30000;
  FHttp.Request.UserAgent:='Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; Highland)';
end;

destructor TnkMemData.Destroy;
begin
  FHttp.Free;
  inherited Destroy;
end;

function TnkMemData.InitStructFromJson(AJson: string): boolean;
var
  mOldActive:boolean;
  jRecord: TJSONData;
  i: Integer;
  mFieldName:string;
  mFieldTypeStr:string;
  mFieldType:TFieldType;
  mFieldSize:integer;
  mFieldNo:integer;
begin
  if Trim(AJson)='' then
    Result:=False
  else
  begin
    Self.DisableControls;
    mOldActive:=Self.Active;
    Self.Active:=False;
    Self.FieldDefs.Clear;
    try
      jRecord:=GetJson(AJson,True);
      for i:=0 to jRecord.Count-1 do
      begin
        mFieldName:=TJsonObject(jRecord.Items[i]).FindPath('name').AsString;
        mFieldTypeStr:=TJsonObject(jRecord.Items[i]).FindPath('type').AsString;
        mFieldType:=TFieldType(GetEnumValue(TypeInfo(TFieldType), mFieldTypeStr));
        mFieldSize:=TJsonObject(jRecord.Items[i]).FindPath('size').AsInteger;
        mFieldNo:=TJsonObject(jRecord.Items[i]).FindPath('no').AsInteger;
        Self.FieldDefs.Add(mFieldName,mFieldType,mFieldSize,False,mFieldNo);
        Self.CreateTable;
      end;
      Result:=True;
    except
      Result:=False;
    end;
    Self.Active:=mOldActive;
    Self.EnableControls;
  end;
end;

function TnkMemData.InitStructFromUrl(AUrl: string): boolean;
var
  mS:string;
begin
  try
    mS:=FHttp.Get(AUrl);
    Result:=Self.InitStructFromJson(mS);
  except
    Result:=False;
  end;
end;

function TnkMemData.FillDataFromJson(AJson: string): boolean;
var
  jData : TJSONData;
  jRecord: TJSONData;
  i, j: Integer;
  mTmp:Tstrings;
  mStream:TMemoryStream;
begin
  if (Trim(AJson)='') or (Self.Active=False) then
    Result:=False
  else
  begin
    Self.DisableControls;
    try
      mtmp:=TStringList.Create;
      mTmp.Add(AJson);
      mStream:=TMemoryStream.Create;
      mTmp.SaveToStream(mStream);
      mStream.Seek(0, soBeginning);
      JData:=GetJson(mStream, True);
      mStream.Free;
      mTmp.Free;
      Self.Close;
      Self.Open;
      Self.First;
      while not Self.Eof do
      begin
        Self.Delete;
      end;
      for i := 0 to jData.Count - 1 do
      begin
        Self.Append;
        jRecord := jData.Items[i];
        for j := 0 to Self.FieldCount - 1 do
        begin
          case Self.Fields.Fields[j].DataType of
            ftString, ftMemo, ftInteger, ftFloat:
              Self.Fields[j].Text := jRecord.GetPath(Self.Fields[j].FieldName).AsString;
            ftDate, ftDatetime:
              Self.Fields[j].AsDateTime := UnixToDatetime(strtoint(jRecord.GetPath(Self.Fields[j].FieldName).AsString));
            ftBoolean:
              Self.Fields.Fields[j].AsBoolean:=(jRecord.GetPath(Self.Fields[j].FieldName).AsString='true');
          end;
        end;
        Self.Post;
      end;
      Result:=True;
    except
      Result:=False;
    end;
    Self.EnableControls;
  end;
end;

function TnkMemData.FillDataFromUrl(AUrl: string): boolean;
var
  mS:string;
begin
  try
    mS:=FHttp.Get(AUrl,IndyTextEncoding_UTF8);
    Result:=Self.FillDataFromJson(mS);
  except
    Result:=False;
  end;
end;

function TnkMemData.ExportStructToJson: string;
var
  i:integer;
  mFieldName:string;
  mFieldType:String;
  mFieldSize:string;
  mFieldNo:string;
begin
  Result:='[';
  Self.DisableControls;
  for i:=0 to Self.FieldDefs.Count-1 do
  begin
    mFieldName:=Self.FieldDefs.Items[i].Name;
    mFieldType:=GetEnumName(TypeInfo(TFieldType),Ord(Self.FieldDefs.Items[i].DataType));
    mFieldSize:=inttostr(Self.FieldDefs.Items[i].Size);
    mFieldNo:=inttostr(Self.FieldDefs.Items[i].FieldNo);
    Result:=Result+'{"name":"'+mFieldName+'","type":"'+mFieldType+'","size":'+mFieldSize+',"no":'+mFieldNo+'}';
    if i<Self.FieldDefs.Count-1 then
      Result:=Result+',';
  end;
  Self.EnableControls;
  Result:=Result+']';
end;

function TnkMemData.ExportDataToJson: string;
var
  i,j:integer;
  mValue:string;
  mRecord:string;
begin
  Result:='[';
  if not Self.Active then
    Exit;
  Self.DisableControls;
  Self.First;
  for j:=0 to Self.RecordCount-1 do
  begin
    mRecord:='{';
    for i:=0 to Self.Fields.Count-1 do
    begin
      case Self.Fields.Fields[i].DataType of
        ftString, ftMemo: mValue:=Self.Fields.Fields[i].AsString;
        ftDate, ftDatetime: mValue:=inttostr(DateTimeToUnix(Self.Fields.Fields[i].AsDateTime));
        ftBoolean: if Self.Fields.Fields[i].AsBoolean then mValue:='true' else mValue:='false';
        ftInteger: mValue:=inttostr(Self.Fields.Fields[i].AsInteger);
        ftFloat: mValue:=floattostr(Self.Fields.Fields[i].AsFloat);
      end;
      mRecord:=mRecord+'"'+Self.Fields.Fields[i].FieldName+'":"'+mValue+'"';
      if i < Self.Fields.Count-1 then
        mRecord:=mRecord+',';
    end;
    mRecord:=mRecord+'}';
    Result:=Result+mRecord;
    if i<Self.RecordCount-1 then
      Result:=Result+',';
    Self.Next;
  end;
  Self.EnableControls;
  Result:=Result+']';
end;

end.
