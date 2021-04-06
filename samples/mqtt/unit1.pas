unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, nkMqtt;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    mqtt: TnkMqtt;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure mqttAfterPublish(AMessageID: integer; ATopic, AMessage: string;
      ASuccess: boolean);
    procedure mqttBeforePublish(var AMessageID: integer; var ATopic,
      AMessage: string);
    procedure mqttLog(AInfo: string);
    procedure mqttReceiveMessage(ATopic, AMessage: string);
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
  mqtt.Run;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  mqtt.Terminate:=True;
end;

procedure TForm1.mqttAfterPublish(AMessageID: integer; ATopic,
  AMessage: string; ASuccess: boolean);
begin
  Memo1.Lines.Add('Published');
end;

procedure TForm1.mqttBeforePublish(var AMessageID: integer; var ATopic,
  AMessage: string);
begin
  AMessageID:=0;
  ATopic:='testtopic';
  AMessage:='This is a message for testing';
end;

procedure TForm1.mqttLog(AInfo: string);
begin
  Memo1.Lines.Add(AInfo);
  Application.ProcessMessages;
end;

procedure TForm1.mqttReceiveMessage(ATopic, AMessage: string);
begin
  MEmo1.Lines.Add('收到主题'+ATopic+'消息：'+AMessage);
end;

end.

