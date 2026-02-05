tableextension 14304109 "AQD QALocation" extends Location
{
    fields
    {
        field(14304104; "AQD QA. Zone"; Code[10])
        {
            TableRelation = Zone.Code where("Location Code" = field(Code), "AQD QA. Zone" = const(true));
            DataClassification = CustomerContent;
            Caption = 'QA. Zone';
            trigger OnValidate()
            var
                Zone: Record Zone;
            begin
                Zone.Get(Code, "AQD QA. Zone");
                Zone.Validate("AQD QA. Zone", true);
            end;
        }
        field(14304105; "AQD QA. Bin Restriction"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'QA. Bin Restriction';
        }
        field(14304106; "AQD Allow QA. Transfer"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow QA. Transfer';
        }
    }
}
