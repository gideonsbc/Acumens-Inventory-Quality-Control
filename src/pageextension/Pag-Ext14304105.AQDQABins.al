pageextension 14304105 "AQD QABins" extends "Bins"
{
    layout
    {
        addafter("Bin Type Code")
        {
            field("AQD Restrict Item"; Rec."AQD Restrict Item")
            {
                ApplicationArea = All;
                Caption = 'Restrict Item';
                ToolTip = 'Specifies the value of the Restrict Item field.';
            }
            field("AQD QA. Bin"; Rec."AQD QA. Bin")
            {
                ApplicationArea = All;
                Caption = 'QA. Bin';
                ToolTip = 'Specifies the value of the QA. Bin field.';
            }
        }
    }
}
