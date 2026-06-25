codeunit 93510 "LSC CAP Telemetry Msg" implements "LSC CAP ITelemetry Message", "LSC CAP ITelemetryMsgController"
{
    var
        _CustomDimensions: Dictionary of [Text, Text];
        _JsonDimensions: Dictionary of [Text, Text];
        _EventID: Enum "LSC CAP Telemetry Event";
        _Message: Text;
        _JsonCaption: Text;
        _BlockedKeys: List of [Text];

    /// <summary>
    /// Returns the CustomDimension dictionary for the telemetry message.
    /// Should be used if this codeunit has been used to create the custom dimensions
    /// </summary>
    /// <returns></returns>
    procedure GetDimensions(): Dictionary of [Text, Text]
    begin
        Controller().AddJsonDimensionToCustomDimension();
        exit(_CustomDimensions);
    end;

    procedure GetHeader(var EventID: Enum "LSC CAP Telemetry Event"; var Message: Text)
    begin
        EventID := this._EventID;
        Message := this._Message;
    end;

    /// <summary>
    /// If this function is used then SendEvent() function can be used to send the event. The enum and message information will be included
    /// </summary>
    procedure AddHeader(EventID: Enum "LSC CAP Telemetry Event"; Message: Text)
    begin
        this._EventID := EventID;
        this._Message := Message = '' ? Format(EventID) : Message;
    end;

    /// <summary>
    /// If this function is used then SendEvent() function can be used to send the event. The enum and message information will be included
    /// </summary>
    procedure AddHeader(EventID: Enum "LSC CAP Telemetry Event"; Message: Text; JsonCaption: Text)
    begin
        AddHeader(EventID, Message);
        this._JsonCaption := JsonCaption = '' ? Format(EventID) : JsonCaption;
    end;

    procedure AddSalesHeader(ReceiptNo: Text; StoreID: Text; TerminalID: Text; TransactionID: Text)
    var
        js: JsonObject;
    begin
        AddSalesHeader(ReceiptNo, StoreID, TerminalID, TransactionID, js);
    end;

    /// <summary>
    /// Adds the sales header information to the custom dimensions.
    /// </summary>
    procedure AddSalesHeader(ReceiptNo: Text; StoreID: Text; TerminalID: Text; TransactionID: Text; AdditionalInfo: JsonObject);
    var
        jsAsText: Text;
    begin
        Add('ReceiptNo', ReceiptNo);
        Add('StoreID', StoreID);
        Add('TerminalID', TerminalID);
        Add('TransactionID', TransactionID);

        AdditionalInfo.WriteTo(jsAsText);
        if jsAsText <> '' then
            Add('SalesHeader', jsAsText);
    end;

    procedure Add(BlockedKeys: List of [Text])
    begin
        _BlockedKeys.AddRange(BlockedKeys);
    end;

    /// <summary>
    /// Adds a value to the custom dimension
    /// </summary>
    procedure Add(Caption: Text; String: Text)
    begin
        Add(Caption, String, false);
    end;

    /// <summary>
    /// If the Caption already exists the value is replaced with the new string value
    /// </summary>
    procedure Set(Caption: Text; String: Text)
    begin
        AddToCustomDimension(_CustomDimensions, Caption, String, true);
    end;

    internal procedure AddToCustomDimension(Dimensions: Dictionary of [Text, Text]; Caption: Text; Value: Text)
    begin
        AddToCustomDimension(Dimensions, Caption, Value, false);
    end;

    /// <summary>
    /// Safely adds a dimension while checking the blocked PII list.
    /// </summary>
    internal procedure AddToCustomDimension(Dimensions: Dictionary of [Text, Text]; Caption: Text; Value: Text; OverrideExisting: Boolean)
    begin
        if _BlockedKeys.Contains(Caption) then begin
            Value := '[REDACTED]';
        end;

        if OverrideExisting then begin
            Dimensions.Set(Caption, Value);
            exit;
        end;

        if Dimensions.ContainsKey(Caption) then
            Caption := StrSubstNo('%1(%2)', Caption, Format(Dimensions.Count));
        Dimensions.Add(Caption, Value);
    end;

    /// <summary>
    /// Adds a value to the custom dimension and then sends the event if SendEvent is true and if EventID has already been set
    /// </summary>
    procedure Add(Caption: Text; String: Text; SendEvent: Boolean)
    begin
        AddToCustomDimension(_CustomDimensions, Caption, String);

        if _EventID = "LSC CAP Telemetry Event"::None then
            exit;

        if SendEvent then
            SendEvent();
    end;

    procedure AddAsJson(Caption: Text; String: Text)
    begin
        AddAsJson(Caption, String, false);
    end;

    procedure AddAsJson(Caption: Text; String: Text; SendEvent: Boolean)
    begin
        AddToCustomDimension(_JsonDimensions, Caption, String);

        if SendEvent then
            SendEvent();
    end;

    /// <summary>
    /// Turns the values in the JsonDimensions dictionary to a json object and adds it to the CustomDimension
    /// </summary>
    procedure AddAsJson(Caption: Text; JsonDimensions: Dictionary of [Text, Text])
    begin
        AddAsJson(Caption, JsonDimensions, false);
    end;

    /// <summary>
    /// Turns the values in the JsonDimensions dictionary to a json object and adds it to the CustomDimension
    /// If SendEvent is true then the event will be sent
    /// </summary>
    procedure AddAsJson(Caption: Text; JsonDimensions: Dictionary of [Text, Text]; SendEvent: Boolean)
    var
        js: JsonObject;
        Keys: List of [Text];
        aKey: Text;
        jsAsText: Text;
    begin
        if (JsonDimensions.Count() = 0) then
            exit;

        Keys := JsonDimensions.Keys();
        foreach aKey in Keys do
            js.Add(aKey, JsonDimensions.Get(aKey));

        js.WriteTo(jsAsText);
        Add(Caption, jsAsText, SendEvent);
    end;

    /// <summary>
    /// Send the event with Verbosity::Normal
    /// </summary>
    procedure SendEvent()
    begin
        SendEvent(Verbosity::Normal);
    end;

    procedure SendEvent(EventID: Enum "LSC CAP Telemetry Event"; Verbosity: Verbosity; Dimension1: Text; Value1: Text)
    begin
        SendEvent(EventID, Verbosity, Dimension1, Value1, '', '');
    end;

    procedure SendEvent(EventID: Enum "LSC CAP Telemetry Event"; Verbosity: Verbosity; Dimension1: Text; Value1: Text; Dimension2: Text; Value2: Text)
    begin
        this._EventID := EventID;
        Add(Dimension1, Value1);
        Add(Dimension2, Value2);
        SendEvent(Verbosity);
    end;

    procedure SendEvent(Verbosity: Verbosity)
    begin
        Controller().SendEvent(this._EventID, this._Message, GetDimensions(), Verbosity, TelemetryScope::ExtensionPublisher);
    end;

    procedure SendEvent(Verbosity: Verbosity; Scope: TelemetryScope)
    begin
        Controller().SendEvent(this._EventID, this._Message, GetDimensions(), Verbosity, Scope);
    end;

    #region "LSCTM ITelemetryMsgController" implementation

    internal procedure SendEvent(EventID: Enum "LSC CAP Telemetry Event"; Message: Text; CustomDimensions: Dictionary of [Text, Text]; Verbosity: Verbosity; Scope: TelemetryScope)
    var
        ISendEvent: Interface "LSC CAP ISendEvent";
    begin
        ISendEvent := EventID;
        ISendEvent.SendEvent(EventID, Message = '' ? Format(EventID) : Message, CustomDimensions, Verbosity, Scope);
    end;

    internal procedure AddJsonDimensionToCustomDimension()
    begin
        if _JsonDimensions.Count = 0 then
            exit;

        AddAsJson(_JsonCaption = '' ? 'Json' : _JsonCaption, _JsonDimensions);
        Clear(_JsonDimensions);
    end;

    #endregion

    #region Accessors for ITelemetryMsgController

    var
        _controller: Interface "LSC CAP ITelemetryMsgController";
        _controllerImplemented: Boolean;

    internal procedure Implement(Dependency: Interface "LSC CAP ITelemetryMsgController")
    begin
        _controller := Dependency;
        _controllerImplemented := true;
    end;

    internal procedure Controller(): Interface "LSC CAP ITelemetryMsgController"
    begin
        if not _controllerImplemented then
            Implement(this);

        exit(_controller);
    end;

    #endregion
}