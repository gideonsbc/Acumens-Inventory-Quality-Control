pageextension 14304109 QAWhseJournalBatches extends "Whse. Journal Batches"
{
    layout
    {
        addafter("Location Code")
        {
            field("Restrict Item"; Rec."Restrict Item")
            {
                ApplicationArea = All;
            }
            field("Allow QA. Transaction"; Rec."Allow QA. Transaction")
            {
                ApplicationArea = All;
            }
        }
    }
}
