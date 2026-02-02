table 14304105 "Warehouse Item Restriction"
{
    fields
    {
        field(1; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(3; "Restriction Status"; Code[10])
        {
            TableRelation = "Warehouse Restriction Status".Code;

            trigger OnValidate()
            var
                WarehouseRestrictionStatus: Record "Warehouse Restriction Status";
                RestrictionUserSetup: Record "Restriction User Setup";
            begin
                RestrictionUserSetup.Get(UserId);
                if RestrictionUserSetup."Restriction Status Filter" <> '' then if StrPos(RestrictionUserSetup."Restriction Status Filter", "Restriction Status") = 0 then WarehouseRestrictionStatus.FieldError(Code, "Restriction Status");
                WarehouseRestrictionStatus.SetFilter(Code, "Restriction Status");
                WarehouseRestrictionStatus.FindSet();
            end;
        }
        field(2; "Restriction Code"; Code[40])
        {
            TableRelation = "Warehouse Restriction"."Code" where(Status = field("Restriction Status"));
        }
        field(4; Type; Enum "Restriction Type")
        {
        }
    }
    keys
    {
        key(Key1; "Item No.", "Restriction Code", Type)
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
