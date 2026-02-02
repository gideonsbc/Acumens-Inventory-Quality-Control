tableextension 14304104 QABin extends Bin
{
    fields
    {
        field(14304104; "Restrict Item"; Boolean)
        {
        }
        field(14304105; "QA. Bin"; Boolean)
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
