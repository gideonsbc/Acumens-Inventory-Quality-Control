pageextension 14304116 QAItemLedgerEntries extends "Item Ledger Entries"
{
    layout
    {
        addafter("Lot No.")
        {
            field("Restriction Code"; Rec."Restriction Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Restriction Status"; Rec."Restriction Status")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}
