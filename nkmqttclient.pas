unit nkMQTTClient;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, MQTT, MQTTReadThread;

type

  { TnkMQTTClient }

  TnkMQTTClient = class(TComponent)
  private
    FClient:TMQTTClient;
    FClientId: string;
    FPingInterval: integer;
    FPort: integer;
    FServer: string;
    function GetConnAckEvent: TConnAckEvent;
    function GetPingRespEvent: TPingRespEvent;
    function GetPublishEvent: TPublishEvent;
    function GetSubAckEvent: TSubAckEvent;
    function GetUnSubAckEvent: TUnSubAckEvent;
    procedure SetConnAckEvent(AValue: TConnAckEvent);
    procedure SetPingRespEvent(AValue: TPingRespEvent);
    procedure SetPublishEvent(AValue: TPublishEvent);
    procedure SetSubAckEvent(AValue: TSubAckEvent);
    procedure SetUnSubAckEvent(AValue: TUnSubAckEvent);
  protected

  public
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy;override;
    procedure Init;
    function isConnected: boolean;
    procedure Connect;
    function Disconnect: boolean;
    procedure ForceDisconnect;
    function Publish(Topic: ansistring; sPayload: ansistring): boolean; overload;
    function Publish(Topic: ansistring; sPayload: ansistring;Retain: boolean): boolean; overload;
    function Subscribe(Topic: ansistring): integer;
    function Unsubscribe(Topic: ansistring): integer;
    function PingReq: boolean;
    function getMessage: TMQTTMessage;
    function getMessageAck: TMQTTMessageAck;
  published
    property Server:string read FServer write FServer;
    property Port:integer read FPort write FPort;
    property PingInterval:integer read FPingInterval write FPingInterval;
    property ClientId:string read FClientId write FClientId;
    property OnConnAck: TConnAckEvent read GetConnAckEvent write SetConnAckEvent;
    property OnPublish: TPublishEvent read GetPublishEvent write SetPublishEvent;
    property OnPingResp: TPingRespEvent read GetPingRespEvent write SetPingRespEvent;
    property OnSubAck: TSubAckEvent read GetSubAckEvent write SetSubAckEvent;
    property OnUnSubAck: TUnSubAckEvent read GetUnSubAckEvent write SetUnSubAckEvent;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Additional',[TnkMQTTClient]);
end;

{ TnkMQTTClient }

function TnkMQTTClient.GetConnAckEvent: TConnAckEvent;
begin
  Result:=FClient.OnConnAck;
end;

function TnkMQTTClient.GetPingRespEvent: TPingRespEvent;
begin
  Result:=FClient.OnPingResp;
end;

function TnkMQTTClient.GetPublishEvent: TPublishEvent;
begin
  Result:=FClient.OnPublish;
end;

function TnkMQTTClient.GetSubAckEvent: TSubAckEvent;
begin
  Result:=FClient.OnSubAck;
end;

function TnkMQTTClient.GetUnSubAckEvent: TUnSubAckEvent;
begin
  Result:=FClient.OnUnSubAck;
end;

procedure TnkMQTTClient.SetConnAckEvent(AValue: TConnAckEvent);
begin
  FClient.OnConnAck:=AValue;

end;

procedure TnkMQTTClient.SetPingRespEvent(AValue: TPingRespEvent);
begin
  FClient.OnPingResp:=AValue;
end;

procedure TnkMQTTClient.SetPublishEvent(AValue: TPublishEvent);
begin
  FClient.OnPublish:=AValue;
end;

procedure TnkMQTTClient.SetSubAckEvent(AValue: TSubAckEvent);
begin
  FClient.OnSubAck:=AValue;
end;

procedure TnkMQTTClient.SetUnSubAckEvent(AValue: TUnSubAckEvent);
begin
  FClient.OnUnSubAck:=AValue;
end;

constructor TnkMQTTClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPort:=1883;
end;

destructor TnkMQTTClient.Destroy;
begin
  inherited Destroy;
end;

procedure TnkMQTTClient.Init;
begin
  FClient:=TMQTTClient.Create(FServer,FPort);
  if Trim(FClientID)<>'' then
    FClient.ClientID:=FClientID;
end;

function TnkMQTTClient.isConnected: boolean;
begin
  Result:=FClient.isConnected;
end;

procedure TnkMQTTClient.Connect;
begin
  FClient.Connect;
end;

function TnkMQTTClient.Disconnect: boolean;
begin
  Result:=FClient.Disconnect;
end;

procedure TnkMQTTClient.ForceDisconnect;
begin
  FClient.ForceDisconnect;
end;

function TnkMQTTClient.Publish(Topic: ansistring; sPayload: ansistring
  ): boolean;
begin
  Result:=FClient.Publish(Topic, sPayload);
end;

function TnkMQTTClient.Publish(Topic: ansistring; sPayload: ansistring;
  Retain: boolean): boolean;
begin
  Result:=Fclient.Publish(Topic, sPayload, Retain);
end;

function TnkMQTTClient.Subscribe(Topic: ansistring): integer;
begin
  Result:=FClient.Subscribe(Topic);
end;

function TnkMQTTClient.Unsubscribe(Topic: ansistring): integer;
begin
  Result:=FClient.Unsubscribe(Topic);
end;

function TnkMQTTClient.PingReq: boolean;
begin
  Result:=FClient.PingReq;
end;

function TnkMQTTClient.getMessage: TMQTTMessage;
begin
  Result:=(FClient.getMessage as MQTT.TMQTTMessage);
end;

function TnkMQTTClient.getMessageAck: TMQTTMessageAck;
begin
  Result:=FClient.getMessageAck;
end;

end.
