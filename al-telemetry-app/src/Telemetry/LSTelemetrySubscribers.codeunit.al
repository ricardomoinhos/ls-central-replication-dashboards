codeunit 93500 "LSC Telemetry Subscribers"
{

    #region Sending transactions using Storage Queue

    [EventSubscriber(ObjectType::Table, Database::"LSC Trans. Server Work Table", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEvent_TransServerWorkTable(var Rec: Record "LSC Trans. Server Work Table"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
            exit;

        // TODO: Evaluate if it is fine to subscribe to the OnAfterInsert or if an event should be added to CreateTSRetryEntry procedure in "LSC POS Trans. Server Utility" codeunit

        // TODO: Check if all the tables should be logged.

        TelemetryMsg.AddHeader("LSC CAP Telemetry Event"::"POS - Sending transaction lifecycle", 'OnAfterInsertEvent_TransServerWorkTable');

        TelemetryUtils.AddCommonDimensions(TelemetryMsg);
        TelemetryUtils.AddTransactionKey(TelemetryMsg, Rec."Store No.", Rec."POS Terminal No.", Rec."Transaction No.");
        TelemetryUtils.AddResult(TelemetryMsg, false, '');
        TelemetryUtils.AddStage(TelemetryMsg, "LSC CAP Replic. Stage"::Posted);

        TelemetryMsg.Add(TableNoLabel, Format(Rec.Table));
        TelemetryMsg.Add(Key1Label, Rec.Key1);
        TelemetryMsg.Add(Key2Label, Rec.Key2);
        TelemetryMsg.Add(StoreNoLabel, Rec."Store No.");
        TelemetryMsg.Add(POSTerminalNoLabel, Rec."POS Terminal No.");
        TelemetryMsg.Add(TransactionNoLabel, Format(Rec."Transaction No."));
        TelemetryMsg.SendEvent(Verbosity::Normal, TelemetryScope::All);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Trans. Server Utility", OnBeforeUpdateTSWTErrorMessage, '', false, false)]
    local procedure "LSC POS Trans. Server Utility_OnBeforeUpdateTSWTErrorMessage"(TableNo: Integer; Key1: Text[250]; Key2: Text[50]; StoreNo: Code[10]; POSTerminalNo: Code[10]; TransactionNo: Integer; var ErrorText: Text[1024])
    begin
        TelemetryMsg.AddHeader("LSC CAP Telemetry Event"::"POS - Sending transaction lifecycle", 'OnBeforeUpdateTSWTErrorMessage');

        TelemetryUtils.AddCommonDimensions(TelemetryMsg);
        TelemetryUtils.AddTransactionKey(TelemetryMsg, StoreNo, POSTerminalNo, TransactionNo);
        TelemetryUtils.AddResult(TelemetryMsg, ErrorText <> '', ErrorText);
        TelemetryUtils.AddStage(TelemetryMsg, "LSC CAP Replic. Stage"::Enqueued);

        TelemetryMsg.Add(TableNoLabel, Format(TableNo));
        TelemetryMsg.Add(Key1Label, Key1);
        TelemetryMsg.Add(Key2Label, Key2);
        TelemetryMsg.Add(StoreNoLabel, StoreNo);
        TelemetryMsg.Add(POSTerminalNoLabel, POSTerminalNo);
        TelemetryMsg.Add(TransactionNoLabel, Format(TransactionNo));

        TelemetryMsg.SendEvent(Verbosity::Normal, TelemetryScope::All);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Web Replic. Client Handler", OnBeforeSendTransByExternalStorageMessage, '', false, false)]
    local procedure "LSC Web Replic. Client Handler_OnBeforeSendTransByExternalStorageMessage"(PacketPrefix: Text; PacketMessage: Text; var PacketDataBuffer: Record "LSC Packet Data Buffer")
    begin
        TelemetryMsg.AddHeader("LSC CAP Telemetry Event"::"POS - Sending transaction lifecycle", 'OnBeforeSendTransByExternalStorageMessage');

        TelemetryUtils.AddCommonDimensions(TelemetryMsg);
        TelemetryMsg.Add(PacketPrefixLabel, PacketPrefix);
        TelemetryMsg.Add(PacketMessageLabel, PacketMessage);
        TelemetryMsg.SendEvent(Verbosity::Normal, TelemetryScope::All);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Web Replic. Client Handler", OnAfterSendTransByExternalStorageMessage, '', false, false)]
    local procedure "LSC Web Replic. Client Handler_OnAfterSendTransByExternalStorageMessage"(PacketPrefix: Text; PacketMessage: Text; var PacketDataBuffer: Record "LSC Packet Data Buffer")
    begin
        TelemetryMsg.AddHeader("LSC CAP Telemetry Event"::"POS - Sending transaction lifecycle", 'OnAfterSendTransByExternalStorageMessage');

        TelemetryUtils.AddCommonDimensions(TelemetryMsg);
        TelemetryUtils.AddResult(TelemetryMsg, false, '');
        TelemetryUtils.AddStage(TelemetryMsg, "LSC CAP Replic. Stage"::Enqueued);

        TelemetryMsg.Add(PacketPrefixLabel, PacketPrefix);
        TelemetryMsg.Add(PacketMessageLabel, PacketMessage);
        TelemetryMsg.SendEvent(Verbosity::Normal, TelemetryScope::All);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC Web Repl. Functions", OnUploadTransPacketCalled, '', false, false)]
    local procedure "LSC Web Repl. Functions_OnUploadTransPacketCalled"(var MessageLog: Record "LSC Trans External Message Log"; var UploadTransPacketResult: Boolean; var ErrorText: Text)
    begin
        TelemetryMsg.AddHeader("LSC CAP Telemetry Event"::"POS - Sending transaction lifecycle", 'OnUploadTransPacketCalled');

        TelemetryUtils.AddCommonDimensions(TelemetryMsg);
        TelemetryUtils.AddTransactionKey(TelemetryMsg, MessageLog."Store No.", MessageLog."POS Terminal No.", MessageLog."Transaction No.");
        TelemetryUtils.AddResult(TelemetryMsg, ErrorText <> '', ErrorText);
        TelemetryUtils.AddStage(TelemetryMsg, "LSC CAP Replic. Stage"::Applied);

        TelemetryMsg.Add(StoreNoLabel, MessageLog."Store No.");
        TelemetryMsg.Add(POSTerminalNoLabel, MessageLog."POS Terminal No.");
        TelemetryMsg.Add(TransactionNoLabel, Format(MessageLog."Transaction No."));

        TelemetryMsg.SendEvent(Verbosity::Normal, TelemetryScope::All);
    end;

    #endregion

    var
        TelemetryUtils: Codeunit "LSC CAP Telemetry Utils";
        TelemetryMsg: Codeunit "LSC CAP Telemetry Msg";
        TableNoLabel: Label 'TableNo', Locked = true;
        Key1Label: Label 'Key1', Locked = true;
        Key2Label: Label 'Key2', Locked = true;
        StoreNoLabel: Label 'StoreNo', Locked = true;
        POSTerminalNoLabel: Label 'POSTerminalNo', Locked = true;
        TransactionNoLabel: Label 'TransactionNo', Locked = true;
        PacketPrefixLabel: Label 'PacketPrefix', Locked = true;
        PacketMessageLabel: Label 'PacketMessage', Locked = true;
}
