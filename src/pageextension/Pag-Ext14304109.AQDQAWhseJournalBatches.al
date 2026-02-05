pageextension 14304109 "AQD QAWhseJournalBatches" extends "Whse. Journal Batches"
{
    layout
    {
        addafter("Location Code")
        {
            field("AQD Restrict Item"; Rec."AQD Restrict Item")
            {
                ApplicationArea = All;
                Caption = 'Restrict Item';
                ToolTip = 'Specifies the value of the Restrict Item field.';
            }
            field("AQD Allow QA. Transaction"; Rec."AQD Allow QA. Transaction")
            {
                ApplicationArea = All;
                Caption = 'Allow QA. Transaction';
                ToolTip = 'Specifies the value of the Allow QA. Transaction field.';
            }
        }
    }
}
