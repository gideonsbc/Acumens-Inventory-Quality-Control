pageextension 14304115 "AQD QAItemTrackingLines" extends "Item Tracking Lines"
{
    layout
    {
        addafter("Lot No.")
        {
            field("AQD Blocked"; Rec."AQD Blocked")
            {
                ApplicationArea = All;
                Caption = 'Blocked';
                ToolTip = 'Specifies the value of the Blocked field.';
            }
            field("AQD Restriction Status"; Rec."AQD Restriction Status")
            {
                ApplicationArea = All;
                Caption = 'Restriction Status';
                ToolTip = 'Specifies the value of the Restriction Status field.';
            }
            field("AQD Restriction Code"; Rec."AQD Restriction Code")
            {
                ApplicationArea = All;
                Caption = 'Restriction Code';
                ToolTip = 'Specifies the value of the Restriction Code field.';
            }
        }
    }
}
