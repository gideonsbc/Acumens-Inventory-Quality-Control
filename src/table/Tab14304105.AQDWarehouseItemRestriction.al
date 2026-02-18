table 14304105 "AQD Warehouse Item Restriction"
{
    Caption = 'Warehouse Item Restriction';
    DataClassification = CustomerContent;
    DataCaptionFields = "Type";
    fields
    {
        field(1; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
            Caption = 'Item No.';
        }
        field(3; "Restriction Status"; Code[10])
        {
            TableRelation = "AQD WarehouseRestrictionStatus".Code;
            Caption = 'Restriction Status';

            trigger OnValidate()
            var
                WarehouseRestrictionStatus: Record "AQD WarehouseRestrictionStatus";
                RestrictionUserSetup: Record "AQD Restriction User Setup";
            begin
                RestrictionUserSetup.Get(UserId);
                if RestrictionUserSetup."Restriction Status Filter" <> '' then if StrPos(RestrictionUserSetup."Restriction Status Filter", "Restriction Status") = 0 then WarehouseRestrictionStatus.FieldError(Code, "Restriction Status");
                WarehouseRestrictionStatus.SetFilter(Code, "Restriction Status");
                WarehouseRestrictionStatus.FindSet();
            end;
        }
        field(2; "Restriction Code"; Code[40])
        {
            TableRelation = "AQD Warehouse Restriction"."Code" where(Status = field("Restriction Status"));
            Caption = 'Restriction Code';
        }
        field(4; Type; Enum "AQD Restriction Type")
        {
            Caption = 'Type';
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
        RestrictionUserSetup.Get(UserId);
        RestrictionUserSetup.TestField(Admin);
    end;
}
