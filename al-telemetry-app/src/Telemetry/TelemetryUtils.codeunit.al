codeunit 93502 "LSC CAP Telemetry Utils"
{
    Access = Internal;

    internal procedure AddCommonDimensions(var TelemetryMsg: Codeunit "LSC CAP Telemetry Msg")
    begin
        TelemetryMsg.Add(UserIdLabel, Database.UserId());
        TelemetryMsg.Add(SessionIdLabel, Format(Database.SessionId()));
    end;

    internal procedure AddTransactionKey(var TelemetryMsg: Codeunit "LSC CAP Telemetry Msg"; StoreNo: Code[10]; POSTerminalNo: Code[10]; TransactionNo: Integer)
    begin
        TelemetryMsg.Add(TransactionKeyLabel, StrSubstNo(TransactionKeyValueLabel, StoreNo, POSTerminalNo, TransactionNo));
    end;

    internal procedure AddResult(var TelemetryMsg: Codeunit "LSC CAP Telemetry Msg"; ErrorOccurred: Boolean; ErrorText: Text)
    begin
        if not ErrorOccurred then
            TelemetryMsg.Add(ResultLabel, Format("LSC CAP Replic. Result"::Success))
        else begin
            TelemetryMsg.Add(ResultLabel, Format("LSC CAP Replic. Result"::Error));
            TelemetryMsg.Add(FailureReasonLabel, ErrorText);
        end;
    end;

    internal procedure AddStage(var TelemetryMsg: Codeunit "LSC CAP Telemetry Msg"; Stage: Enum "LSC CAP Replic. Stage")
    begin
        TelemetryMsg.Add(StageLabel, Format(Stage));
    end;

    var
        UserIdLabel: Label 'UserId', Locked = true;
        SessionIdLabel: Label 'SessionId', Locked = true;
        TransactionKeyLabel: Label 'TransactionKey', Locked = true;
        TransactionKeyValueLabel: Label 'S%1|T%2|X%3', Comment = '%1 is the store no., %2 is the terminal no., %3 is the transaction no.', Locked = true;
        StageLabel: Label 'Stage', Locked = true;
        ResultLabel: Label 'Result', Locked = true;
        FailureReasonLabel: Label 'FailureReason', Locked = true;

}