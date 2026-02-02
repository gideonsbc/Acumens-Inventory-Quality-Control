pageextension 14304113 QAItemJournalBatches extends "Item Journal Batches"
{
    layout
    {
        addafter("Reason Code")
        {
            field("Allow QA. Transaction"; Rec."Allow QA. Transaction")
            {
                ApplicationArea = All;
            }
        }
    }
}
