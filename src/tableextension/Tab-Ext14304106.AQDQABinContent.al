tableextension 14304106 "AQD QABinContent" extends "Bin Content"
{
    fields
    {
        field(14304104; "AQD QA. Bin"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'QA. Bin';
        }
    }
    trigger OnAfterInsert()
    var
        Zone: Record Zone;
    begin
        if Zone.Get("Location Code", "Zone Code") then "AQD QA. Bin" := Zone."AQD QA. Zone";
    end;
}
