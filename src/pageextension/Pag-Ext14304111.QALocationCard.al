pageextension 14304111 QALocationCard extends "Location Card"
{
    layout
    {
        addafter("From-Production Bin Code")
        {
            field("QA. Zone"; Rec."QA. Zone")
            {
                ApplicationArea = All;
            }
            field("QA. Bin Restriction"; Rec."QA. Bin Restriction")
            {
                ApplicationArea = All;
            }
            field("Allow QA. Transfer"; Rec."Allow QA. Transfer")
            {
                ApplicationArea = All;
            }
        }
    }
}
