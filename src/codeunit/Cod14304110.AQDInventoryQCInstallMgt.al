codeunit 14304110 "AQD Inventory QC Install Mgt"
{
    Permissions = tabledata 2000000073 = rimd,
    tabledata 2000000178 = rimd;

    var

        Source: Option " ",Install,Upgrade,DefaultSetups;

    trigger OnRun()
    begin

        case Source of
            Source::Install:
                begin
                    //todo

                end;
            Source::Upgrade:
                begin
                    //todo

                end;
            Source::DefaultSetups:
                begin
                    //todo 
                end;
        end;
    end;

    procedure SetTriggerSourceCodeunit(Source_l: Option " ",Install,Upgrade,DefaultSetups)
    begin
        Source := Source_l;
    end;
}