table 14304107 "Item Restriction Entry"
{
    LookupPageId = "Item Restriction Entries";
    DrillDownPageId = "Item Restriction Entries";

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
        field(6; "Restriction Line No."; Integer)
        {
        }
        field(7; "Entry No."; Integer)
        {
        }
        field(8; "Restriction Status"; Code[10])
        {
            TableRelation = "Warehouse Restriction Status".Code;
        }
        field(9; Quantity; Decimal)
        {
        }
        field(10; "Qty. (Base)"; Decimal)
        {
            Caption = 'Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(11; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(12; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(13; CreatedBy; Code[50])
        {
            Caption = 'Created By';
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
            Editable = false;
        }
        field(14; "Transaction DateTime"; DateTime)
        {
        }
        field(15; "Document No."; Code[20])
        {
        }
        field(16; "Document Line No."; Integer)
        {
        }
        field(17; "Remaining Qty."; Decimal)
        {
        }
        field(18; "Posting Date"; Date)
        {
        }
        field(19; "Initial Entry"; Boolean)
        {
        }
        field(20; "Unit Cost"; Decimal)
        {
        }
        field(21; "Amount"; Decimal)
        {
        }
        field(22; "Initial Restriction ID"; Guid)
        {
        }
        field(23; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(24; "Release Bin Code"; Code[20])
        {
            TableRelation = Bin.Code where("Location Code" = field("Location Code"), "QA. Bin" = const(false));
        }
        field(25; "QA. Bin Code"; Code[20])
        {
            TableRelation = Bin.Code where("Location Code" = field("Location Code"), "QA. Bin" = const(true));
        }
    }
    keys
    {
        key(Key1; "Restriction ID", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Lot No.")
        {
        }
        key(Key3; "Transaction DateTime")
        {
        }
    }
}
