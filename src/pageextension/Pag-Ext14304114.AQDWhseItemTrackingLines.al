pageextension 14304114 "AQD WhseItemTrackingLines" extends "Whse. Item Tracking Lines"
{
    layout
    {
        addafter("Lot No.")
        {
            field("AQD Restricted"; Rec."AQD Restricted")
            {
                ApplicationArea = All;
                Caption = 'Restricted';
                ToolTip = 'Specifies the value of the Restricted field.';
            }
        }
    }
}
