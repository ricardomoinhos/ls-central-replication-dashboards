enumextension 93500 "Replication Telemetry Event" extends "LSC CAP Telemetry Event"
{
    value(10012870; "POS - Sending transaction lifecycle")
    {
        Caption = 'POS - Sending transaction lifecycle';
        Implementation = "LSC CAP ISendEvent" = "Custom Send Telemetry Msg";
    }
}