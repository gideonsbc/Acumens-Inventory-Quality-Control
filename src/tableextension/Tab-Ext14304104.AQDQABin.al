tableextension 14304104 "AQD QABin" extends Bin
{
    fields
    {
        field(14304104; "AQD Restrict Item"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Restrict Item';
        }
        field(14304105; "AQD QA. Bin"; Boolean)
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
