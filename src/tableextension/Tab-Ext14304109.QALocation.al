tableextension 14304109 QALocation extends Location
{
    fields
    {
        field(14304104; "QA. Zone"; Code[10])
        {
            TableRelation = Zone.Code where("Location Code" = field(Code), "QA. Zone" = const(true));

            trigger OnValidate()
            var
                Zone: Record Zone;
            begin
                Zone.Get(Code, "QA. Zone");
                Zone.Validate("QA. Zone", true);
            end;
        }
        field(14304105; "QA. Bin Restriction"; Boolean)
        {
        }
        field(14304106; "Allow QA. Transfer"; Boolean)
        {
        }
    }
}
