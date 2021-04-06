unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, MQTT;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    Client:TMQTTClient;
    procedure OnConnAck(Sender: TObject; ReturnCode: integer);
    procedure OnPingResp(Sender: TObject);
    procedure OnPublish(Sender: TObject; topic, payload: ansistring; retain: boolean);
    procedure OnSubAck(Sender: TObject; MessageID: integer; GrantedQoS: integer);
    procedure OnUnsubAck(Sender: TObject; MessageID: integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.frm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Client:=TMQTTClient.Create('192.168.0.95',1883);
  Client.OnConnAck:=@OnConnAck;
  Client.OnPingResp:=@OnPingResp;
  Client.OnPublish:=@OnPublish;
  Client.OnSubAck:=@OnSubAck;
  Client.OnUnSubAck:=@OnUnsubAck;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Client.Connect;
  Sleep(1000);
  Button2Click(nil);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Client.isConnected then
    Client.Subscribe('testtopic/#');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if Client.isConnected then
    Client.Publish('testtopic','This is a message');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if Client.isConnected then
    Client.Publish('testtopic', Trim(Memo2.Text));
end;

procedure TForm1.OnConnAck(Sender: TObject; ReturnCode: integer);
begin
  Memo1.Lines.Add('ConnACK: '+inttostr(ReturnCode));
end;

procedure TForm1.OnPingResp(Sender: TObject);
begin
  Memo1.Lines.Add('PingResp !');
end;

procedure TForm1.OnPublish(Sender: TObject; topic, payload: ansistring;
  retain: boolean);
begin
  Memo1.Lines.Add('Publish: topic='+topic+' payload='+payload);
end;

procedure TForm1.OnSubAck(Sender: TObject; MessageID: integer;
  GrantedQoS: integer);
begin
  Memo1.Lines.Add('SubAck: MessageId='+inttostr(MessageId)+' QoS='+inttostr(GrantedQoS));
end;

procedure TForm1.OnUnsubAck(Sender: TObject; MessageID: integer);
begin
  Memo1.Lines.Add('UbSubAck:'+inttostr(MessageID));
end;

end.

