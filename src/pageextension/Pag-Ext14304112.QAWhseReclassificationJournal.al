pageextension 14304112 QAWhseReclassificationJournal extends "Whse. Reclassification Journal"
{
    layout
    {
        modify("To Bin Code")
        {
            Visible = not QARestriction;
        }
        addafter("To Bin Code")
        {
            field("QA. To Bin Code"; Rec."QA. To Bin Code")
            {
                ApplicationArea = All;
                Visible = QARestriction;
            }
        }
    }
    trigger OnOpenPage()
    var
        QASingleInstance: Codeunit "QA Single Instance";
    begin
        QARestriction := QASingleInstance.GetShowQABin();
    end;

    var
        QARestriction: Boolean;
}
