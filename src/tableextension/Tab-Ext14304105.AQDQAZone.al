tableextension 14304105 "AQD QAZone" extends Zone
{
    fields
    {
        field(14304104; "AQD QA. Zone"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'QA. Zone';
            trigger OnValidate()
            var
                Bin: Record Bin;
                BinContent: Record "Bin Content";
            begin
                Bin.SetRange("Location Code", "Location Code");
                Bin.SetRange("Zone Code", Code);
                Bin.ModifyAll("AQD QA. Bin", "AQD QA. Zone");
                BinContent.SetRange("Location Code", "Location Code");
                BinContent.SetRange("Zone Code", Code);
                BinContent.ModifyAll("AQD QA. Bin", "AQD QA. Zone");
            end;
        }
    }
}
