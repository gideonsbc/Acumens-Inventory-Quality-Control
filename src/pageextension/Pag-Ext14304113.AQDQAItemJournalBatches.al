pageextension 14304113 "AQD QAItemJournalBatches" extends "Item Journal Batches"
{
    layout
    {
        addafter("Reason Code")
        {
            field("AQD Allow QA. Transaction"; Rec."AQD Allow QA. Transaction")
            {
                ApplicationArea = All;
                Caption = 'Allow QA. Transaction';
                ToolTip = 'Specifies the value of the Allow QA. Transaction field.';
            }
        }
    }
}
