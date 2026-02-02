table 14304104 "Warehouse Restriction"
{
    LookupPageId = "Warehouse Restrictions";
    DrillDownPageId = "Warehouse Restrictions";

    fields
    {
        field(1; "Code"; Code[40])
        {
        }
        field(2; Status; Code[20])
        {
            TableRelation = "Warehouse Restriction Status".Code;

            trigger OnValidate()
            var
                WarehouseRestrictionStatus: Record "Warehouse Restriction Status";
                RestrictionUserSetup: Record "Restriction User Setup";
            begin
                RestrictionUserSetup.Get(UserId);
                if RestrictionUserSetup."Restriction Status Filter" <> '' then if StrPos(RestrictionUserSetup."Restriction Status Filter", Status) = 0 then WarehouseRestrictionStatus.FieldError(Code, Status);
                WarehouseRestrictionStatus.SetFilter(Code, Status);
                WarehouseRestrictionStatus.FindSet();
            end;
        }
        field(3; "Description"; Text[100])
        {
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
        RestrictionUserSetup: Record "Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        RestrictionUserSetup.TestField(Admin);
    end;

    trigger OnModify()
    var
        RestrictionUserSetup: Record "Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        RestrictionUserSetup.TestField(Admin);
    end;

    trigger OnDelete()
    var
        RestrictionUserSetup: Record "Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        RestrictionUserSetup.TestField(Admin);
    end;
}
