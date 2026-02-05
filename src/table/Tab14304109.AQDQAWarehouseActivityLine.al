table 14304109 "AQD QA-Warehouse Activity Line"
{
    Caption = 'Warehouse Activity Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Activity Type"; Enum "Warehouse Activity Type")
        {
            Caption = 'Activity Type';
            Editable = false;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(4; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
        }
        field(5; "Source Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Source Line No.';
            Editable = false;
        }
        field(6; "Source Document"; Enum "Warehouse Activity Source Document")
        {
            BlankZero = true;
            Caption = 'Source Document';
            Editable = false;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location;
        }
        field(8; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(9; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            Editable = false;
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(10; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(11; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(13; "Qty. (Base)"; Decimal)
        {
            Caption = 'Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(14; "Qty. to Handle"; Decimal)
        {
            Caption = 'Qty. to Handle';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(15; "Qty. to Handle (Base)"; Decimal)
        {
            Caption = 'Qty. to Handle (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(17; "Bin Code"; Code[20])
        {
            AccessByPermission = TableData "Warehouse Source Filter" = R;
            Caption = 'Bin Code';
            TableRelation = Bin.Code;
        }
        field(16; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            ExtendedDatatype = Barcode;
        }
        field(18; "Action Type"; Enum "Warehouse Action Type")
        {
            Caption = 'Action Type';
            Editable = false;
        }
        field(19; "Whse. Document Type"; Enum "Warehouse Activity Document Type")
        {
            Caption = 'Whse. Document Type';
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Activity Type", "No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
