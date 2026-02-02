table 14304106 "Item Restrictions"
{
    fields
    {
        field(1; "Restriction ID"; Guid)
        {
        }
        field(2; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(3; "Variant Code"; Code[10])
        {
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(4; "Lot No."; Code[50])
        {
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"));
        }
        field(5; "Restriction Code"; Code[40])
        {
            TableRelation = "Warehouse Restriction"."Code" where(Status = field("Restriction Status"));
        }
        field(6; "Line No."; Integer)
        {
        }
        field(7; "Restriction Status"; Code[10])
        {
            TableRelation = "Warehouse Restriction Status".Code;
        }
        field(8; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(9; "Remaining Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = sum("Item Restriction Entry".Quantity where("Restriction ID" = field("Restriction ID")));
            Editable = false;
        }
        field(10; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(11; "Release Bin Code"; Code[20])
        {
            TableRelation = Bin.Code where("Location Code" = field("Location Code"), "QA. Bin" = const(false));
        }
        field(12; "QA. Bin Code"; Code[20])
        {
            TableRelation = Bin.Code where("Location Code" = field("Location Code"), "QA. Bin" = const(true));
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
        }
        field(19; "Initial Entry"; Boolean)
        {
        }
        field(20; "Qty. QA. Warehouse Entry"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Entry".Quantity where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Location Code" = field("Location Code"), "Lot No." = field("Lot No."), "Bin Code" = field("QA. Bin Code"), "QA. Bin" = const(true)));
            Editable = false;
        }
        field(21; "Document No."; Code[20])
        {
        }
        field(22; "Parent Restriction ID"; Guid)
        {
        }
        field(23; "Enable Scrap"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Restriction Status"."Enable Scrap" where(Code = field("Restriction Status")));
            Editable = false;
        }
        field(24; "Last Transaction Date"; DateTime)
        {
            FieldClass = FlowField;
            CalcFormula = max("Item Restriction Entry".SystemCreatedAt where("Restriction ID" = field("Restriction ID")));
            Editable = false;
        }
        field(25; "Initial Restriction ID"; Guid)
        {
        }
        field(26; "Remaining Qty. (Base)"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = sum("Item Restriction Entry"."Qty. (Base)" where("Restriction ID" = field("Restriction ID")));
            Editable = false;
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
        ItemRestEntry: Record "Item Restriction Entry";
    begin
        ItemRestEntry.SetRange("Item No.", "Item No.");
        ItemRestEntry.SetRange("Variant Code", "Variant Code");
        ItemRestEntry.SetRange("Lot No.", "Lot No.");
        ItemRestEntry.SetRange("Restriction Code", "Restriction Code");
        ItemRestEntry.SetRange("Restriction Line No.", "Line No.");
        ItemRestEntry.DeleteAll(true);
    end;
}
