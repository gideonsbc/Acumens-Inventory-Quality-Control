tableextension 14304114 "AQD QAItemJournalLine" extends "Item Journal Line"
{
    fields
    {
        modify("Bin Code")
        {
            trigger OnAfterValidate()
            begin
                if ("New Bin Code" <> '') and ("New Location Code" <> '') then Validate("New Bin Code");
            end;
        }
        modify("New Bin Code")
        {
            trigger OnBeforeValidate()
            var
                FLocation: Record Location;
                TLocation: Record Location;
                FromBin: Record Bin;
                ToBin: Record Bin;
                QABin: Record Bin;
                QAManagement: Codeunit "AQD QA Management";
                QASingleInstance: Codeunit "AQD QA Single Instance";
            begin
                FLocation.Get("Location Code");
                if not QASingleInstance.GetReclass() then
                    if TLocation.Get("New Location Code") then begin
                        FromBin.Get("Location Code", "Bin Code");
                        if ToBin.Get("New Location Code", "New Bin Code") then
                            if FLocation."AQD QA. Zone" = FromBin."Zone Code" then begin
                                if ToBin."Zone Code" <> FLocation."AQD QA. Zone" then begin
                                    "New Bin Code" := QAManagement.CreateQABin("New Location Code", ToBin.Code);
                                end;
                            end;
                    end;
            end;
        }
    }
}
