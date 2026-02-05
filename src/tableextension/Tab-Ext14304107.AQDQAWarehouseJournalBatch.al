tableextension 14304107 "AQD QAWarehouseJournalBatch" extends "Warehouse Journal Batch"
{
    fields
    {
        field(14304104; "AQD Restrict Item"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Restrict Item';
        }
        field(14304105; "AQD Allow QA. Transaction"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow QA. Transaction';
        }
    }
}
