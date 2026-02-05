table 14304107 "AQD Item Restriction Entry"
{
    Caption = 'Item Restriction Entry';
    LookupPageId = "AQD Item Restriction Entries";
    DrillDownPageId = "AQD Item Restriction Entries";
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
        field(6; "Restriction Line No."; Integer)
        {
            Caption = 'Restriction Line No.';
        }
        field(7; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(8; "Restriction Status"; Code[10])
        {
            TableRelation = "AQD WarehouseRestrictionStatus".Code;
            Caption = 'Restriction Status';
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
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
            Caption = 'Transaction DateTime';
        }
        field(15; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(16; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(17; "Remaining Qty."; Decimal)
        {
            Caption = 'Remaining Qty.';
        }
        field(18; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(19; "Initial Entry"; Boolean)
        {
            Caption = 'Initial Entry';
        }
        field(20; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(21; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(22; "Initial Restriction ID"; Guid)
        {
            Caption = 'Initial Restriction ID';
        }
        field(23; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;
            Caption = 'Location Code';
        }
        field(24; "Release Bin Code"; Code[20])
        {
            TableRelation = Bin.Code where("Location Code" = field("Location Code"), "AQD QA. Bin" = const(false));
            Caption = 'Release Bin Code';
        }
        field(25; "QA. Bin Code"; Code[20])
        {
            TableRelation = Bin.Code where("Location Code" = field("Location Code"), "AQD QA. Bin" = const(true));
            Caption = 'QA. Bin Code';
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
