tableextension 14304105 QAZone extends Zone
{
    fields
    {
        field(14304104; "QA. Zone"; Boolean)
        {
            trigger OnValidate()
            var
                Bin: Record Bin;
                BinContent: Record "Bin Content";
            begin
                Bin.SetRange("Location Code", "Location Code");
                Bin.SetRange("Zone Code", Code);
                Bin.ModifyAll("QA. Bin", "QA. Zone");
                BinContent.SetRange("Location Code", "Location Code");
                BinContent.SetRange("Zone Code", Code);
                BinContent.ModifyAll("QA. Bin", "QA. Zone");
            end;
        }
    }
}
