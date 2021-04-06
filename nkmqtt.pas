unit nkMqtt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, MQTT;

type

  //运行状态
  TnkMQTTStates = (nkmCONNECT,nkmWAIT_CONNECT,nkmRUNNING,nkmFAILING);

  //Log事件
  TnkMQTTOnLogEvent = procedure (AInfo:string) of object;
  //发布前事件
  TnkMQTTOnBeforePublishEvent = procedure (var AMessageID:integer;var ATopic, AMessage:string) of object;
  //发布后事件
  TnkMQTTOnAfterPublishEvent = procedure (AMessageID:integer;ATopic, AMessage:string;ASuccess:boolean) of object;
  //读取消息事件
  TnkMQTTOnReceiveMessageEvent = procedure (ATopic, AMessage:string) of object;
  //主对象

  { TnkMqtt }

  TnkMqtt = class(TComponent)
  private
    FClient:                 TMQTTClient;
    FHost: string;
    FOnAfterPublish: TnkMQTTOnAfterPublishEvent;
    FOnBeforePublish: TnkMQTTOnBeforePublishEvent;
    FOnLog: TnkMQTTOnLogEvent;
    //FOnPublish: TnkMQTTOnPublishEvent;
    FOnReceiveMessage: TnkMQTTOnReceiveMessageEvent;
    FPingTimerInterval: integer;
    FPort: integer;
    FPubTimerInterval: integer;
    FServer: string;
    FState:                  TnkMQTTStates;
    FPingCounter:            integer;
    FPingTimer:              integer;
    FPubTimer:               integer;
    FConnectTimer:           integer;
    FTopics:                 TStrings;
    function GetTopics: TStrings;
    procedure SetTopics(AValue: TStrings);
  protected

  public
    Terminate:boolean;
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy;override;
    procedure Run;//执行消息循环
  published
    property PubTimerInterval:integer read FPubTimerInterval write FPubTimerInterval;//发布定时间隔
    property PingTimerInterval:integer read FPingTimerInterval write FPingTimerInterval;//Ping定时间隔
    property Server:string read FServer write FHost;//服务器地址
    property Port:integer read FPort write FPort;//服务器端口
    property Topics:TStrings read GetTopics write SetTopics;//订阅主题列表
    property OnLog:TnkMQTTOnLogEvent read FOnLog write FOnLog; //Log事件
    property OnBeforePublish:TnkMQTTOnBeforePublishEvent read FOnBeforePublish write FOnBeforePublish;//发布消息事件
    property OnAfterPublish:TnkMQTTOnAfterPublishEvent read FOnAfterPublish write FOnAfterPublish;//发布成功事件
    property OnReceiveMessage:TnkMQTTOnReceiveMessageEvent read FOnReceiveMessage write FOnReceiveMessage;//收到消息
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Additional',[TnkMqtt]);
end;

{ TnkMqtt }

function TnkMqtt.GetTopics: TStrings;
begin
  Result:=FTopics;
end;

procedure TnkMqtt.SetTopics(AValue: TStrings);
begin
  FTopics.Assign(AValue);
end;

constructor TnkMqtt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPort:=1883;
  FPubTimerInterval := 100;//10秒
  FPingTimerInterval := 100;
  Ftopics:=TStringList.Create;
end;

destructor TnkMqtt.Destroy;
begin
  FTopics.Free;
  inherited Destroy;
end;

procedure TnkMqtt.Run;
var
  mMessageID:integer;
  mTopic,mMessage:string;
  msg : TMQTTMessage;
  ack : TMQTTMessageAck;
  i:integer;
begin
  if Assigned(FOnLog) then
    FOnLog('initing');
  FClient := TMQTTClient.Create(FServer, FPort);
  while not Self.Terminate do
  begin
    FState:=nkmCONNECT;
    case FState of
      nkmCONNECT :
        begin
          // Connect to MQTT server
          FPingCounter := 0;
          FPingTimer := 0;
          FPubTimer := 0;
          FConnectTimer := 0;
          FClient.Connect;
          FState := nkmWAIT_CONNECT;
        end;
      nkmWAIT_CONNECT :
        begin
          // Can only move to RUNNING state on recieving ConnAck
          FConnectTimer := FConnectTimer + 1;
          if FConnectTimer > 300 then
          begin
            if Assigned(FOnLog) then
              FOnlog('Error: ConnAck time out.');
            FState := nkmFAILING;
          end;
        end;
      nkmRUNNING :
        begin
          // Publish stuff
          if FPubTimer mod FPubTimerInterval = 0 then
          begin
            //发布消息
            if Assigned(FOnBeforePublish) then
            begin
              FOnBeforePublish(mMessageID,mTopic,mMessage);
              if not FClient.Publish(mTopic, mMessage) then
              begin
                if Assigned(FOnLog) then
                  FOnLog('Error: Publish Failed.');
                FState := nkmFAILING;
                if Assigned(FOnAfterPublish) then
                  FOnAfterPublish(mMessageID,mTopic,mMessage,False);
              end
              else
              begin
                FOnAfterPublish(mMessageID,mTopic,mMessage,True);
              end;
            end;
          end;
          FPubTimer := FPubTimer + 1;

          // Ping the MQTT server occasionally
          if (FPingTimer mod 100) = 0 then
          begin
            // Time to PING !
            if not FClient.PingReq then
            begin
              if Assigned(FOnLog) then
                FOnLog('Error: PingReq Failed.');
              FState := nkmFAILING;
            end;
            FPingCounter := FPingCounter + 1;
            // Check that pings are being answered
            if FPingCounter > 3 then
            begin
              if Assigned(FOnLog) then
                FOnLog('Error: Ping timeout.');
              FState := nkmFAILING;
            end;
          end;
          FPingTimer := FPingTimer + 1;
        end;
    end;
    // Read incomming MQTT messages.
    repeat
      msg := FClient.getMessage;
      if Assigned(msg) then
      begin
        if Assigned(FOnReceiveMessage) then
          FOnReceiveMessage(msg.Topic, msg.PayLoad);
        if Assigned(FOnLog) then
          FOnLog('Got message from ' + msg.topic);
        // Important to free messages here.
        msg.free;
      end;
    until not Assigned(msg);
    // Read incomming MQTT message acknowledgments
    repeat
      ack := FClient.getMessageAck;
      if Assigned(ack) then
      begin
        case ack.messageType of
          CONNACK :
            begin
              if ack.returnCode = 0 then
              begin
                // Make subscriptions
                if Trim(FTopics.Text)<>'' then
                begin
                  for i:=0 to FTopics.Count-1 do
                  begin
                    if Trim(FTopics.Strings[i])<>'' then
                      FClient.Subscribe(FTopics.Strings[i]);
                  end;
                end;
                // Enter the running state
                FState := nkmRUNNING;
              end
              else
                FState := nkmFAILING;
              end;
          PINGRESP :
            begin
              if Assigned(FOnLog) then
                FOnLog('PING! PONG!');
              // Reset ping counter to indicate all is OK.
              FPingCounter := 0;
            end;
          SUBACK :
            begin
              if Assigned(FOnLog) then
                FOnLog('SUBACK: '+inttostr(ack.messageId)+', '+inttostr(ack.qos));
            end;
          UNSUBACK :
            begin
              if Assigned(FOnLog) then
                FOnLog('UNSUBACK: '+inttostr(ack.messageId));
            end;
          end;
        end;
      // Important to free messages here.
      ack.free;
    until not Assigned(ack);
    // Main application loop must call this else we leak threads!
    CheckSynchronize;
    // Yawn.
    sleep(100);
  end;
  FClient.ForceDisconnect;
  FreeAndNil(FClient);
end;

end.
