enum 93510 "LSC CAP Telemetry Event" implements "LSC CAP ISendEvent"
{
    Extensible = true;

    /*
        NO ENUM VALUES SHOULD BE ADDED TO THIS ENUM
        ALL ENUM VALUES SHOULD BE ADDED IN ENUM EXTENSIONS

        See: enumextension 10000704 "LSC Trans.Util Telemetry Event"
             enumextension 10000703 "LSC Card Telemetry Event" 

        See: codeunit 10000958 "LSC Card Telemetry Json Msg" for an example of how to extend the telemetry functionality for specific functionality

        All enums must now implement "LSCTM ISendEvent" interface. Which will call the actual Telemetry message. 
        This is required so that each app is sending the telemetry messages through to the correct telemetry repository that is defined in it's app.json file.

        This means that the enum id is the telemetry event id, the enum name is used when referenced in code, and the enum caption is used for the event message.

        Please note:
            * Please be careful what information you put in the telemetry events
            * Make sure that no personal identifiable data is ever sent with telemetry events
            * Make sure you don't flood the system with telemetry events, be careful how you use the events
            * Do not use the same event all over the place, make sure you use the correct event for the correct purpose
            * Make sure you use the correct verbosity level for the event. If you are not sure, use Verbosity::Normal        

        NO ENUM VALUES SHOULD BE ADDED TO THIS ENUM
        ALL ENUM VALUES SHOULD BE ADDED IN ENUM EXTENSIONS

    */

    value(0; None)
    {
        Caption = 'None';
        Implementation = "LSC CAP ISendEvent" = "LSC CAP ISend Event None";
    }
}