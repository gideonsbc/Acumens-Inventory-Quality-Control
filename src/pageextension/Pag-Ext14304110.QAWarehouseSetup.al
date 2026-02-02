pageextension 14304110 QAWarehouseSetup extends "Warehouse Setup"
{
    layout
    {
        addafter(General)
        {
            group("QA. Managment")
            {
                field("Split Lot Template Name"; Rec."Split Lot Template Name")
                {
                    ApplicationArea = All;
                }
                field("Split Lot Batch Name"; Rec."Split Lot Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Split Lot Whse Template Name"; Rec."Split Lot Whse Template Name")
                {
                    ApplicationArea = All;
                }
                field("Split Lot Warehouse Batch Name"; Rec."Split Lot Warehouse Batch Name")
                {
                    ApplicationArea = All;
                }
                field("QA. Template Name"; Rec."QA. Template Name")
                {
                    ApplicationArea = All;
                }
                field("QA. Batch No."; Rec."QA. Batch Name")
                {
                    ApplicationArea = All;
                }
                field("QA. Warehouse Template Name"; Rec."QA. Warehouse Template Name")
                {
                    ApplicationArea = All;
                }
                field("QA. Warehouse Batch No."; Rec."QA. Warehouse Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Allow DPP. Transfer"; Rec."Allow DPP. Transfer")
                {
                    ApplicationArea = All;
                }
                field("Allow Partial Release"; Rec."Allow Partial Release")
                {
                    ApplicationArea = All;
                }
                field("Inv. Counts Restriction Status"; Rec."Inv. Counts Restriction Status")
                {
                    ApplicationArea = All;
                }
                field("Inv. Counts Restriction Code"; Rec."Inv. Counts Restriction Code")
                {
                    ApplicationArea = All;
                }
                field("Create Rest. for Expired Lot"; Rec."Create Rest. for Expired Lot")
                {
                    ApplicationArea = All;
                }
                field("Expired Lot Restriction Status"; Rec."Expired Lot Restriction Status")
                {
                    ApplicationArea = All;
                }
                field("Expired Lot Restriction Code"; Rec."Expired Lot Restriction Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
