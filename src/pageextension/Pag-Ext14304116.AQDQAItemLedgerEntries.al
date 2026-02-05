pageextension 14304116 "AQD QAItemLedgerEntries" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Lot No.")
        {
            field("AQD Restriction Code"; Rec."AQD Restriction Code")
            {
                ApplicationArea = All;
                Visible = false;
                Caption = 'Restriction Code';
                ToolTip = 'Specifies the value of the Restriction Code field.';
            }
            field("AQD Restriction Status"; Rec."AQD Restriction Status")
            {
                ApplicationArea = All;
                Visible = false;
                Caption = 'Restriction Status';
                ToolTip = 'Specifies the value of the Restriction Status field.';
            }
        }
    }
}
