tableextension 14304106 QABinContent extends "Bin Content"
{
    fields
    {
        field(14304104; "QA. Bin"; Boolean)
        {
        }
    }
    trigger OnAfterInsert()
    var
        Zone: Record Zone;
    begin
        if Zone.Get("Location Code", "Zone Code") then "QA. Bin" := Zone."QA. Zone";
    end;
}
