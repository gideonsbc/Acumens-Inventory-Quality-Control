pageextension 14304114 WhseItemTrackingLines extends "Whse. Item Tracking Lines"
{
    layout
    {
        addafter("Lot No.")
        {
            field(Restricted; Rec.Restricted)
            {
                ApplicationArea = All;
            }
        }
    }
}
