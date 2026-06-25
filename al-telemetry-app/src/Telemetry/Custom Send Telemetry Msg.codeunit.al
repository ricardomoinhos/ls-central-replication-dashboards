codeunit 93501 "Custom Send Telemetry Msg" implements "LSC CAP ISendEvent"
{
    Access = Internal;

    procedure SendEvent(EventID: Enum "LSC CAP Telemetry Event"; Message: Text; CustomDimensions: Dictionary of [Text, Text]; Verbosity: Verbosity; Scope: TelemetryScope)
    begin
        Session.LogMessage(Format(EventID.AsInteger()), Message, Verbosity, DataClassification::SystemMetadata, Scope, CustomDimensions);

        /*
            VERY IMPORTANT NOTE:
            
            For the Session.LogMessage to do anything in this example app you need to add an applicationInsights resource in the app.json file of this example extension 
            or configure it within your environment connection string. 
            
            Without that, the LogMessage calls will not have any effect and you won't see any telemetry in your Application Insights instance.

        */
    end;
}