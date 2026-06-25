codeunit 93511 "LSC CAP ISend Event None" implements "LSC CAP ISendEvent"
{
    Access = Internal;

    procedure SendEvent(EventID: Enum "LSC CAP Telemetry Event"; Message: Text; CustomDimensions: Dictionary of [Text, Text]; Verbosity: Verbosity; Scope: TelemetryScope)
    begin
    end;
}