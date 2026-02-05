table 14304108 "AQD WarehouseRestrictionStatus"
{
    Caption = 'Warehouse Restriction Status';
    LookupPageId = "AQD WarehouseRestrictionStatus";
    DrillDownPageId = "AQD WarehouseRestrictionStatus";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Enable Scrap"; Boolean)
        {
            Caption = 'Enable Scrap';
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
