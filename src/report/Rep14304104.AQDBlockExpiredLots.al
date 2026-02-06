report 14304104 "AQD Block Expired Lots"
{
    Caption = 'Block Expired Lots';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "Inventory Posting Group";

            dataitem("Lot No. Information"; "Lot No. Information")
            {
                DataItemLink = "Item No." = field("No.");

                trigger OnAfterGetRecord()
                var
                    WhseSetup: Record "Warehouse Setup";
                    Location: Record Location;
                begin
                    WhseSetup.Get();
                    if LocationFilter <> '' then Location.SetFilter(Code, LocationFilter);
                    if Location.FindSet() then
                        repeat
                            SetRange("Location Filter", Location.Code);
                            SetFilter("Date Filter", '>%1&<=%2', 0D, Today);
                            CalcFields("Expired Inventory");
                            if "Expired Inventory" > 0 then begin
                                if not Blocked then begin
                                    Blocked := true;
                                    Modify();
                                end;
                                if Location."AQD QA. Zone" <> '' then if WhseSetup."AQD CreateRest. forExpired Lot" then RestrictLot(Location.Code, "Lot No. Information", WhseSetup."AQD Expired Lot Restr. Code", WhseSetup."AQD Expired Lot Restr. Status");
                            end;
                        until Location.Next() = 0;
                end;
            }
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Filter)
                {
                    Caption = 'Filter';

                    field(LocationFilter; LocationFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Location Filter';
                        TableRelation = Location;
                        ToolTip = 'Specifies the value of the Location Filter field.';
                    }
                }
            }
        }
    }
    procedure RestrictLot(LCode: Code[20]; var LotNo: Record "Lot No. Information"; RestrictionCode: Code[20]; RestrictionStatus: Code[20])
    var
        BinContent: Record "Bin Content";
        Location: Record Location;
        Bin: Record Bin;
        QAManagment: Codeunit "AQD QA Management";
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        ClearLastError();
        Clear(QAManagment);
        Location.Get(LCode);
        QASingleInstance.SetQABin(true);
        BinContent.SetAutoCalcFields("Quantity (Base)", Quantity);
        BinContent.SetRange("Location Code", LCode);
        BinContent.SetFilter("Zone Code", '<>%1', Location."AQD QA. Zone");
        BinContent.SetRange("AQD QA. Bin", false);
        BinContent.SetRange("Item No.", LotNo."Item No.");
        BinContent.SetRange("Variant Code", LotNo."Variant Code");
        BinContent.SetRange("Lot No. Filter", LotNo."Lot No.");
        BinContent.SetFilter("Quantity (Base)", '<> 0');
        if BinContent.FindSet() then
            repeat
                Bin.Get(Location.Code, BinContent."Bin Code");
                if not Bin."AQD QA. Bin" then
                    if not QAManagment.RestrictItem(LotNo, BinContent.Quantity, BinContent."Quantity (Base)", RestrictionCode, RestrictionStatus, LCode, BinContent."Bin Code", BinContent."Unit of Measure Code") then begin
                        QASingleInstance.SetQARestriction(false);
                        //Message(GetLastErrorText());
                    end;
            until BinContent.Next() = 0;
        QASingleInstance.SetQARestriction(false);
    end;

    var
        LocationFilter: Text;
}
