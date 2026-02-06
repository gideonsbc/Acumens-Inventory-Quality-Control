tableextension 14304108 "AQD QAWarehouseSetup" extends "Warehouse Setup"
{
    fields
    {
        field(14304104; "AQD QA. Batch Name"; Code[20])
        {
            Caption = 'QA. Batch Name';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("AQD QA. Template Name"));
            DataClassification = CustomerContent;
        }
        field(14304105; "AQD QA. Warehouse Batch Name"; Code[20])
        {
            Caption = 'QA. Warehouse Batch Name';
            TableRelation = "Warehouse Journal Batch".Name where("Journal Template Name" = field("AQD QA. Whse Template Name"));
            DataClassification = CustomerContent;
        }
        field(14304106; "AQD Split Lot Batch Name"; Code[20])
        {
            Caption = 'Split Lot Batch Name';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("AQD Split Lot Template Name"));
            DataClassification = CustomerContent;
        }
        field(14304107; "AQD Split Lot Whse Batch Name"; Code[20])
        {
            Caption = 'Split Lot Warehouse Batch Name';
            TableRelation = "Warehouse Journal Batch".Name where("Journal Template Name" = field("AQD Split Lot Whse Temp. Name"));
            DataClassification = CustomerContent;
        }
        field(14304108; "AQD QA. Template Name"; Code[20])
        {
            Caption = 'QA. Template Name';
            TableRelation = "Item Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(14304109; "AQD QA. Whse Template Name"; Code[20])
        {
            Caption = 'QA. Warehouse Template Name';
            TableRelation = "Warehouse Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(14304110; "AQD Split Lot Template Name"; Code[20])
        {
            Caption = 'Split Lot Template Name';
            TableRelation = "Item Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(14304111; "AQD Split Lot Whse Temp. Name"; Code[20])
        {
            Caption = 'Split Lot Warehouse Template Name';
            TableRelation = "Warehouse Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(14304112; "AQD Allow DPP. Transfer"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow DPP. Transfer';
        }
        field(14304113; "AQD Inv. Counts Restr. Code"; Code[40])
        {
            Caption = 'Inventory Counts Restriction Code';
            TableRelation = "AQD Warehouse Restriction"."Code" where(Status = field("AQD Inv. Counts Restr. Status"));
            DataClassification = CustomerContent;
        }
        field(14304114; "AQD Inv. Counts Restr. Status"; Code[10])
        {
            Caption = 'Inventory Counts Restriction Status';
            TableRelation = "AQD WarehouseRestrictionStatus".Code;
            DataClassification = CustomerContent;
        }
        field(14304115; "AQD Allow Partial Release"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Partial Release';
        }
        field(14304116; "AQD CreateRest. forExpired Lot"; Boolean)
        {
            Caption = 'Create Restrictions for Expired Lot.';
            DataClassification = CustomerContent;
        }
        field(14304117; "AQD Expired Lot Restr. Code"; Code[40])
        {
            Caption = 'Expired Lot Restriction Code';
            TableRelation = "AQD Warehouse Restriction"."Code" where(Status = field("AQD Expired Lot Restr. Status"));
            DataClassification = CustomerContent;
        }
        field(14304118; "AQD Expired Lot Restr. Status"; Code[10])
        {
            Caption = 'Expired Lot Restriction Status';
            TableRelation = "AQD WarehouseRestrictionStatus".Code;
            DataClassification = CustomerContent;
        }
    }
}
