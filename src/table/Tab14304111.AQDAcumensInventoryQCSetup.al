table 14304111 "AQD Acumens Inventory QC Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Acumens Inventory Quality Control Setup';

    fields
    {
        field(1; "AQD Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "AQD Enabled"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'SBC';
            Caption = 'Enabled';
        }
        field(3; "AQD Log To History"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Log To History';
        }
        field(4; "AQD Setup Deleted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Setup Deleted By';
        }
        field(5; "AQD Setup Initialized By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Setup Initialized By';
        }
        field(6; "AQD Test Mode"; Boolean)
        {
            Caption = 'Test Mode';
            DataClassification = CustomerContent;
        }
        field(7; "AQD QA. Batch Name"; Code[20])
        {
            Caption = 'QA. Batch Name';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("AQD QA. Template Name"));
            DataClassification = CustomerContent;
        }
        field(8; "AQD QA. Warehouse Batch Name"; Code[20])
        {
            Caption = 'QA. Warehouse Batch Name';
            TableRelation = "Warehouse Journal Batch".Name where("Journal Template Name" = field("AQD QA. Whse Template Name"));
            DataClassification = CustomerContent;
        }
        field(9; "AQD Split Lot Batch Name"; Code[20])
        {
            Caption = 'Split Lot Batch Name';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("AQD Split Lot Template Name"));
            DataClassification = CustomerContent;
        }
        field(10; "AQD Split Lot Whse Batch Name"; Code[20])
        {
            Caption = 'Split Lot Warehouse Batch Name';
            TableRelation = "Warehouse Journal Batch".Name where("Journal Template Name" = field("AQD Split Lot Whse Temp. Name"));
            DataClassification = CustomerContent;
        }
        field(11; "AQD QA. Template Name"; Code[20])
        {
            Caption = 'QA. Template Name';
            TableRelation = "Item Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(12; "AQD QA. Whse Template Name"; Code[20])
        {
            Caption = 'QA. Warehouse Template Name';
            TableRelation = "Warehouse Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(13; "AQD Split Lot Template Name"; Code[20])
        {
            Caption = 'Split Lot Template Name';
            TableRelation = "Item Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(14; "AQD Split Lot Whse Temp. Name"; Code[20])
        {
            Caption = 'Split Lot Warehouse Template Name';
            TableRelation = "Warehouse Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(15; "AQD Allow DPP. Transfer"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow DPP. Transfer';
        }
        field(16; "AQD Inv. Counts Restr. Code"; Code[40])
        {
            Caption = 'Inventory Counts Restriction Code';
            TableRelation = "AQD Warehouse Restriction"."Code" where(Status = field("AQD Inv. Counts Restr. Status"));
            DataClassification = CustomerContent;
        }
        field(17; "AQD Inv. Counts Restr. Status"; Code[10])
        {
            Caption = 'Inventory Counts Restriction Status';
            TableRelation = "AQD WarehouseRestrictionStatus".Code;
            DataClassification = CustomerContent;
        }
        field(18; "AQD Allow Partial Release"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Partial Release';
        }
        field(19; "AQD CreateRest. forExpired Lot"; Boolean)
        {
            Caption = 'Create Restrictions for Expired Lot.';
            DataClassification = CustomerContent;
        }
        field(20; "AQD Expired Lot Restr. Code"; Code[40])
        {
            Caption = 'Expired Lot Restriction Code';
            TableRelation = "AQD Warehouse Restriction"."Code" where(Status = field("AQD Expired Lot Restr. Status"));
            DataClassification = CustomerContent;
        }
        field(21; "AQD Expired Lot Restr. Status"; Code[10])
        {
            Caption = 'Expired Lot Restriction Status';
            TableRelation = "AQD WarehouseRestrictionStatus".Code;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "AQD Primary Key")
        {
        }
    }
}

