codeunit 14304107 "AQD Arc Appl System Constants"
{
    trigger OnRun()
    begin
    end;

    procedure AIQCMPApplicationVersion() ApplicationVersion: Text[248]
    begin
        ApplicationVersion := 'NA 27.0';
        OnAfterGetApplicationVersion(ApplicationVersion);
    end;

    procedure AIQCMPBuildDate(): Text[80]
    begin
        exit('04 Feb 2026');
    end;

    procedure AIQCMPCUVersion(): Text[80]
    begin
        exit('Cumulative Update 01');
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetApplicationVersion(var ApplicationVersion: Text[248])
    begin
    end;
}

