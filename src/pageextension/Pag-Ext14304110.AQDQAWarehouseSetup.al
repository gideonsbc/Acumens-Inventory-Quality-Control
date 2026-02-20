pageextension 14304110 "AQD QAWarehouseSetup" extends "Warehouse Setup"
{
    layout
    {
        addafter(General)
        {
            group("AQD QA. Managment")
            {
                Caption = 'Acumens Quality Control Management';
                field("AQD Split Lot Template Name"; Rec."AQD Split Lot Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'Split Lot Template Name';
                    ToolTip = 'Specifies the value of the Split Lot Template Name field.';
                }
                field("AQD Split Lot Batch Name"; Rec."AQD Split Lot Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'Split Lot Batch Name';
                    ToolTip = 'Specifies the value of the Split Lot Batch Name field.';
                }
                field("AQD Split Lot Whse Template Name"; Rec."AQD Split Lot Whse Temp. Name")
                {
                    ApplicationArea = All;
                    Caption = 'Split Lot Warehouse Template Name';
                    ToolTip = 'Specifies the value of the Split Lot Warehouse Template Name field.';
                }
                field("AQD Split Lot Warehouse Batch Name"; Rec."AQD Split Lot Whse Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'Split Lot Warehouse Batch Name';
                    ToolTip = 'Specifies the value of the Split Lot Warehouse Batch Name field.';
                }
                field("AQD QA. Template Name"; Rec."AQD QA. Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'QA. Template Name';
                    ToolTip = 'Specifies the value of the QA. Template Name field.';
                }
                field("AQD QA. Batch No."; Rec."AQD QA. Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'QA. Batch Name';
                    ToolTip = 'Specifies the value of the QA. Batch Name field.';
                }
                field("AQD QA. Warehouse Template Name"; Rec."AQD QA. Whse Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'QA. Warehouse Template Name';
                    ToolTip = 'Specifies the value of the QA. Warehouse Template Name field.';
                }
                field("AQD QA. Warehouse Batch No."; Rec."AQD QA. Warehouse Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'QA. Warehouse Batch Name';
                    ToolTip = 'Specifies the value of the QA. Warehouse Batch Name field.';
                }
                field("AQD Allow DPP. Transfer"; Rec."AQD Allow DPP. Transfer")
                {
                    ApplicationArea = All;
                    Caption = 'Allow DPP. Transfer';
                    ToolTip = 'Specifies the value of the Allow DPP. Transfer field.';
                }
                field("AQD Allow Partial Release"; Rec."AQD Allow Partial Release")
                {
                    ApplicationArea = All;
                    Caption = 'Allow Partial Release';
                    ToolTip = 'Specifies the value of the Allow Partial Release field.';
                }
                field("AQD Inv. Counts Restriction Status"; Rec."AQD Inv. Counts Restr. Status")
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Counts Restriction Status';
                    ToolTip = 'Specifies the value of the Inventory Counts Restriction Status field.';
                }
                field("AQD Inv. Counts Restriction Code"; Rec."AQD Inv. Counts Restr. Code")
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Counts Restriction Code';
                    ToolTip = 'Specifies the value of the Inventory Counts Restriction Code field.';
                }
                field("AQD Create Rest. for Expired Lot"; Rec."AQD CreateRest. forExpired Lot")
                {
                    ApplicationArea = All;
                    Caption = 'Create Restrictions for Expired Lot.';
                    ToolTip = 'Specifies the value of the Create Restrictions for Expired Lot. field.';
                }
                field("AQD Expired Lot Restriction Status"; Rec."AQD Expired Lot Restr. Status")
                {
                    ApplicationArea = All;
                    Caption = 'Expired Lot Restriction Status';
                    ToolTip = 'Specifies the value of the Expired Lot Restriction Status field.';
                }
                field("AQD Expired Lot Restriction Code"; Rec."AQD Expired Lot Restr. Code")
                {
                    ApplicationArea = All;
                    Caption = 'Expired Lot Restriction Code';
                    ToolTip = 'Specifies the value of the Expired Lot Restriction Code field.';
                }
            }
        }
    }
}
