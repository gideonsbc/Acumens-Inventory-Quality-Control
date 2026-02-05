pageextension 14304112 "AQD AQDQAWhseRe. classJournal" extends "Whse. Reclassification Journal"
{
    layout
    {
        modify("To Bin Code")
        {
            Visible = not QARestriction;
        }
        addafter("To Bin Code")
        {
            field("AQD QA. To Bin Code"; Rec."AQD QA. To Bin Code")
            {
                ApplicationArea = All;
                Visible = QARestriction;
                Caption = 'QA. To Bin Code';
                ToolTip = 'Specifies the value of the QA. To Bin Code field.';
            }
        }
    }
    trigger OnOpenPage()
    var
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        QARestriction := QASingleInstance.GetShowQABin();
    end;

    var
        QARestriction: Boolean;
}
