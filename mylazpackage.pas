{ This file was automatically created by Typhon IDE. Do not edit!
  This source is only used to compile and install the package.
 }

unit MyLazPackage;

{$warn 5023 off : no warning about unused units}
interface

uses
  nkTitleBar, nkResizer, nkMemData, MQTT, MQTTReadThread, nkMqtt, 
  TyphonPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('nkTitleBar', @nkTitleBar.Register);
  RegisterUnit('nkResizer', @nkResizer.Register);
  RegisterUnit('nkMemData', @nkMemData.Register);
  RegisterUnit('nkMqtt', @nkMqtt.Register);
end;

initialization
  RegisterPackage('MyLazPackage', @Register);
end.
