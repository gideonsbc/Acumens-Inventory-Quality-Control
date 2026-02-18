table 14304104 "AQD Warehouse Restriction"
{
    Caption = 'Warehouse Restriction';
    LookupPageId = "AQD Warehouse Restrictions";
    DrillDownPageId = "AQD Warehouse Restrictions";
    DataClassification = CustomerContent;
    DataCaptionFields = Status, Description;

    fields
    {
        field(1; "Code"; Code[40])
        {
            Caption = 'Code';
        }
        field(2; Status; Code[20])
        {
            TableRelation = "AQD WarehouseRestrictionStatus".Code;
            Caption = 'Status';

            trigger OnValidate()
            var
                WarehouseRestrictionStatus: Record "AQD WarehouseRestrictionStatus";
                RestrictionUserSetup: Record "AQD Restriction User Setup";
            begin
                RestrictionUserSetup.Get(UserId);
                if RestrictionUserSetup."Restriction Status Filter" <> '' then if StrPos(RestrictionUserSetup."Restriction Status Filter", Status) = 0 then WarehouseRestrictionStatus.FieldError(Code, Status);
                WarehouseRestrictionStatus.SetFilter(Code, Status);
                WarehouseRestrictionStatus.FindSet();
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(Key1; Status, "Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        RestrictionUserSetup: Record "AQD Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        RestrictionUserSetup.TestField(Admin);
    end;

    trigger OnModify()
    var
        RestrictionUserSetup: Record "AQD Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        RestrictionUserSetup.TestField(Admin);
    end;

    trigger OnDelete()
    var
        RestrictionUserSetup: Record "AQD Restriction User Setup";
    begin
        if RestrictionUserSetup.Get(UserId) then
            RestrictionUserSetup.TestField(Admin);
    end;
}
