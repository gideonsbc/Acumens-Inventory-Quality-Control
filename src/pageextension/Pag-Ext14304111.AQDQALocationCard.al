pageextension 14304111 "AQD QALocationCard" extends "Location Card"
{
    layout
    {
        addafter(Bins)
        {
            group("AQD Acumens Quality Control Management")
            {
                Caption = 'Acumens Quality Control Management';
                field("AQD QA. Zone"; Rec."AQD QA. Zone")
                {
                    ApplicationArea = All;
                    Caption = 'QA. Zone';
                    ToolTip = 'Specifies the value of the QA. Zone field.';
                }
                field("AQD QA. Bin Restriction"; Rec."AQD QA. Bin Restriction")
                {
                    ApplicationArea = All;
                    Caption = 'QA. Bin Restriction';
                    ToolTip = 'Specifies the value of the QA. Bin Restriction field.';
                }
                field("AQD Allow QA. Transfer"; Rec."AQD Allow QA. Transfer")
                {
                    ApplicationArea = All;
                    Caption = 'Allow QA. Transfer';
                    ToolTip = 'Specifies the value of the Allow QA. Transfer field.';
                }
            }
        }
    }
}
