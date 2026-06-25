interface "LSC CAP ITelemetry Message"
{
    procedure GetDimensions(): Dictionary of [Text, Text];
    procedure GetHeader(var EventID: Enum "LSC CAP Telemetry Event"; var Message: Text);
    procedure AddHeader(EventID: Enum "LSC CAP Telemetry Event"; Message: Text);
    procedure AddHeader(EventID: Enum "LSC CAP Telemetry Event"; Message: Text; JsonCaption: Text);
    procedure AddSalesHeader(ReceiptNo: Text; StoreID: Text; TerminalID: Text; TransactionID: Text);
    procedure AddSalesHeader(ReceiptNo: Text; StoreID: Text; TerminalID: Text; TransactionID: Text; Additional: JsonObject);
    procedure Add(BlockedKeys: List of [Text]);
    procedure Add(Caption: Text; String: Text);
    procedure Add(Caption: Text; String: Text; SendEvent: Boolean);
    procedure Set(Caption: Text; String: Text);
    procedure AddAsJson(Caption: Text; JsonDimensions: Dictionary of [Text, Text]);
    procedure AddAsJson(Caption: Text; JsonDimensions: Dictionary of [Text, Text]; SendEvent: Boolean);
    procedure AddAsJson(Caption: Text; String: Text);
    procedure AddAsJson(Caption: Text; String: Text; SendEvent: Boolean)
    procedure SendEvent();
    procedure SendEvent(Verbosity: Verbosity);
    procedure SendEvent(Verbosity: Verbosity; Scope: TelemetryScope);
    procedure SendEvent(EventID: Enum "LSC CAP Telemetry Event"; Verbosity: Verbosity; Dimension1: Text; Value1: Text);
    procedure SendEvent(EventID: Enum "LSC CAP Telemetry Event"; Verbosity: Verbosity; Dimension1: Text; Value1: Text; Dimension2: Text; Value2: Text);
}