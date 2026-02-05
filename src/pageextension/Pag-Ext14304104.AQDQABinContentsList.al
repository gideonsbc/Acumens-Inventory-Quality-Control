pageextension 14304104 "AQD QABinContentsList" extends "Bin Contents List"
{
    layout
    {
        addafter(Default)
        {
            field("AQD QA. Bin"; Rec."AQD QA. Bin")
            {
                ApplicationArea = All;
                Caption = 'QA. Bin';
                ToolTip = 'Specifies the value of the QA. Bin field.';
            }
        }
    }
}
