table 14304108 "Warehouse Restriction Status"
{
    LookupPageId = "Warehouse Restriction Status";
    DrillDownPageId = "Warehouse Restriction Status";

    fields
    {
        field(1; Code; Code[20])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Enable Scrap"; Boolean)
        {
        }
    }
    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
}
