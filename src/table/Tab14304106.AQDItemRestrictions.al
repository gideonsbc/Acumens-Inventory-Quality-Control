table 14304106 "AQD Item Restrictions"
{
    Caption = 'Item Restrictions';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Restriction ID"; Guid)
        {
            Caption = 'Restriction ID';
        }
        field(2; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
            Caption = 'Item No.';
        }
        field(3; "Variant Code"; Code[10])
        {
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
            Caption = 'Variant Code';
        }
        field(4; "Lot No."; Code[50])
        {
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"));
            Caption = 'Lot No.';
        }
        field(5; "Restriction Code"; Code[40])
        {
            TableRelation = "AQD Warehouse Restriction"."Code" where(Status = field("Restriction Status"));
            Caption = 'Restriction Code';
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(7; "Restriction Status"; Code[10])
        {
            TableRelation = "AQD WarehouseRestrictionStatus".Code;
            Caption = 'Restriction Status';
        }
        field(8; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Quantity';
        }
        field(9; "Remaining Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = sum("AQD Item Restriction Entry".Quantity where("Restriction ID" = field("Restriction ID")));
            Editable = false;
            Caption = 'Remaining Qty.';
        }
        field(10; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;
            Caption = 'Location Code';
        }
        field(11; "Release Bin Code"; Code[20])
        {
            TableRelation = Bin.Code where("Location Code" = field("Location Code"), "AQD QA. Bin" = const(false));
            Caption = 'Release Bin Code';
        }
        field(12; "QA. Bin Code"; Code[20])
        {
            TableRelation = Bin.Code where("Location Code" = field("Location Code"), "AQD QA. Bin" = const(true));
            Caption = 'QA. Bin Code';
        }
        field(13; "Qty. (Base)"; Decimal)
        {
            Caption = 'Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(14; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(15; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(16; "Qty. to Handle"; Decimal)
        {
            Caption = 'Qty. to Handle';
        }
        field(17; "Created By"; Code[50])
        {
            Caption = 'Created By';
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
            Editable = false;
        }
        field(18; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(19; "Initial Entry"; Boolean)
        {
            Caption = 'Initial Entry';
        }
        field(20; "Qty. QA. Warehouse Entry"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Entry".Quantity where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Location Code" = field("Location Code"), "Lot No." = field("Lot No."), "Bin Code" = field("QA. Bin Code"), "AQD QA. Bin" = const(true)));
            Editable = false;
            Caption = 'Qty. QA. Warehouse Entry';
        }
        field(21; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(22; "Parent Restriction ID"; Guid)
        {
            Caption = 'Parent Restriction ID';
        }
        field(23; "Enable Scrap"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("AQD WarehouseRestrictionStatus"."Enable Scrap" where(Code = field("Restriction Status")));
            Editable = false;
            Caption = 'Enable Scrap';
        }
        field(24; "Last Transaction Date"; DateTime)
        {
            FieldClass = FlowField;
            CalcFormula = max("AQD Item Restriction Entry".SystemCreatedAt where("Restriction ID" = field("Restriction ID")));
            Editable = false;
            Caption = 'Last Transaction Date';
        }
        field(25; "Initial Restriction ID"; Guid)
        {
            Caption = 'Initial Restriction ID';
        }
        field(26; "Remaining Qty. (Base)"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = sum("AQD Item Restriction Entry"."Qty. (Base)" where("Restriction ID" = field("Restriction ID")));
            Editable = false;
            Caption = 'Remaining Qty. (Base)';
        }
    }
    keys
    {
        key(Key1; "Restriction ID")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        ItemRestEntry: Record "AQD Item Restriction Entry";
    begin
        ItemRestEntry.SetRange("Item No.", "Item No.");
        ItemRestEntry.SetRange("Variant Code", "Variant Code");
        ItemRestEntry.SetRange("Lot No.", "Lot No.");
        ItemRestEntry.SetRange("Restriction Code", "Restriction Code");
        ItemRestEntry.SetRange("Restriction Line No.", "Line No.");
        ItemRestEntry.DeleteAll(true);
    end;
}
