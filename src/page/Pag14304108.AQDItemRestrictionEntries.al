page 14304108 "AQD Item Restriction Entries"
{
    Caption = 'Item Restriction Entries';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "AQD Item Restriction Entry";
    DataCaptionExpression = Rec."Item No.";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Caption = 'GroupName';
                field("Initial Entry"; Rec."Initial Entry")
                {
                    ApplicationArea = All;
                    Caption = 'Initial Entry';
                    ToolTip = 'Specifies the value of the Initial Entry field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document Line No.';
                    ToolTip = 'Specifies the value of the Document Line No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Caption = 'Variant Code';
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Caption = 'Lot No.';
                    ToolTip = 'Specifies the value of the Lot No. field.';
                }
                field("Restriction Code"; Rec."Restriction Code")
                {
                    ApplicationArea = All;
                    Caption = 'Restriction Code';
                    ToolTip = 'Specifies the value of the Restriction Code field.';
                }
                field("Restriction Status"; Rec."Restriction Status")
                {
                    ApplicationArea = All;
                    Caption = 'Restriction Status';
                    ToolTip = 'Specifies the value of the Restriction Status field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Remaining Qty."; Rec."Remaining Qty.")
                {
                    ApplicationArea = All;
                    Caption = 'Remaining Qty.';
                    ToolTip = 'Specifies the value of the Remaining Qty. field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Cost';
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(CreatedBy; Rec.CreatedBy)
                {
                    ApplicationArea = All;
                    Caption = 'Created By';
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Transaction DateTime"; Rec."Transaction DateTime")
                {
                    ApplicationArea = All;
                    Caption = 'Transaction DateTime';
                    ToolTip = 'Specifies the value of the Transaction DateTime field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }
}
