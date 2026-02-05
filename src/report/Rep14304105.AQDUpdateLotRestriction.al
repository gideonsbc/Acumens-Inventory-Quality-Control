report 14304105 "AQD Update Lot Restriction"
{
    Caption = 'Update Lot Restriction';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Lot No. Information"; "Lot No. Information")
        {
            trigger OnAfterGetRecord()
            var
                ItemRestEntry: Record "AQD Item Restriction Entry";
            begin
                ItemRestEntry.SetCurrentKey("Transaction DateTime");
                ItemRestEntry.SetRange("Item No.", "Item No.");
                ItemRestEntry.SetRange("Variant Code", "Variant Code");
                ItemRestEntry.SetRange("Lot No.", "Lot No.");
                if ItemRestEntry.FindLast() then begin
                    "AQD Restriction Status" := ItemRestEntry."Restriction Status";
                    "AQD Restriction Code" := ItemRestEntry."Restriction Code";
                    Modify();
                end;
            end;
        }
    }
}
