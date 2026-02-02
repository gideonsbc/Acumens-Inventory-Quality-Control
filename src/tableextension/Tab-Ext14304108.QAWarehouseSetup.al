tableextension 14304108 QAWarehouseSetup extends "Warehouse Setup"
{
    fields
    {
        field(14304104; "QA. Batch Name"; Code[20])
        {
            Caption = 'QA. Batch Name';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("QA. Template Name"));
        }
        field(14304105; "QA. Warehouse Batch Name"; Code[20])
        {
            Caption = 'QA. Warehouse Batch Name';
            TableRelation = "Warehouse Journal Batch".Name where("Journal Template Name" = field("QA. Warehouse Template Name"));
        }
        field(14304106; "Split Lot Batch Name"; Code[20])
        {
            Caption = 'Split Lot Batch Name';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Split Lot Template Name"));
        }
        field(14304107; "Split Lot Warehouse Batch Name"; Code[20])
        {
            Caption = 'Split Lot Warehouse Batch Name';
            TableRelation = "Warehouse Journal Batch".Name where("Journal Template Name" = field("Split Lot Whse Template Name"));
        }
        field(14304108; "QA. Template Name"; Code[20])
        {
            Caption = 'QA. Template Name';
            TableRelation = "Item Journal Template".Name;
        }
        field(14304109; "QA. Warehouse Template Name"; Code[20])
        {
            Caption = 'QA. Warehouse Template Name';
            TableRelation = "Warehouse Journal Template".Name;
        }
        field(14304110; "Split Lot Template Name"; Code[20])
        {
            Caption = 'Split Lot Template Name';
            TableRelation = "Item Journal Template".Name;
        }
        field(14304111; "Split Lot Whse Template Name"; Code[20])
        {
            Caption = 'Split Lot Warehouse Template Name';
            TableRelation = "Warehouse Journal Template".Name;
        }
        field(14304112; "Allow DPP. Transfer"; Boolean)
        {
        }
        field(14304113; "Inv. Counts Restriction Code"; Code[40])
        {
            Caption = 'Inventory Counts Restriction Code';
            TableRelation = "Warehouse Restriction"."Code" where(Status = field("Inv. Counts Restriction Status"));
        }
        field(14304114; "Inv. Counts Restriction Status"; Code[10])
        {
            Caption = 'Inventory Counts Restriction Status';
            TableRelation = "Warehouse Restriction Status".Code;
        }
        field(14304115; "Allow Partial Release"; Boolean)
        {
        }
        field(14304116; "Create Rest. for Expired Lot"; Boolean)
        {
            Caption = 'Create Restrictions for Expired Lot.';
        }
        field(14304117; "Expired Lot Restriction Code"; Code[40])
        {
            Caption = 'Expired Lot Restriction Code';
            TableRelation = "Warehouse Restriction"."Code" where(Status = field("Expired Lot Restriction Status"));
        }
        field(14304118; "Expired Lot Restriction Status"; Code[10])
        {
            Caption = 'Expired Lot Restriction Status';
            TableRelation = "Warehouse Restriction Status".Code;
        }
    }
}
