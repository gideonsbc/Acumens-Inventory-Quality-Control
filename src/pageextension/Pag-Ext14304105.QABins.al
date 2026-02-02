pageextension 14304105 QABins extends "Bins"
{
    layout
    {
        addafter("Bin Type Code")
        {
            field("Restrict Item"; Rec."Restrict Item")
            {
                ApplicationArea = All;
            }
            field("QA. Bin"; Rec."QA. Bin")
            {
                ApplicationArea = All;
            }
        }
    }
}
