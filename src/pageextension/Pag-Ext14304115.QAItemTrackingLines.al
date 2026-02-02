pageextension 14304115 QAItemTrackingLines extends "Item Tracking Lines"
{
    layout
    {
        addafter("Lot No.")
        {
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
            }
            field("Restriction Status"; Rec."Restriction Status")
            {
                ApplicationArea = All;
            }
            field("Restriction Code"; Rec."Restriction Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
