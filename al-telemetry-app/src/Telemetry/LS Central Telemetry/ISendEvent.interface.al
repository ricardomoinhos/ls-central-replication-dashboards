interface "LSC CAP ISendEvent"
{
    procedure SendEvent(EventID: Enum "LSC CAP Telemetry Event"; Message: Text; CustomDimensions: Dictionary of [Text, Text]; Verbosity: Verbosity; Scope: TelemetryScope);
}