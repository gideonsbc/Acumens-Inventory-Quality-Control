codeunit 14304106 "AQD QA Single Instance"
{
    SingleInstance = true;

    procedure UnBlockLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50])
    var
        LotInfo: Record "Lot No. Information";
    begin
        if LotInfo.Get(ItemNo, VariantCode, LotNo) then begin
            if not TempLotInfo.Get(ItemNo, VariantCode, LotNo) then begin
                TempLotInfo.Init();
                TempLotInfo."Item No." := ItemNo;
                TempLotInfo."Variant Code" := VariantCode;
                TempLotInfo."Lot No." := LotNo;
                TempLotInfo.Insert();
            end;
            LotInfo.Blocked := false;
            LotInfo.Modify();
        end;
    end;

    procedure ResetLotInfo()
    var
        LotInfo: Record "Lot No. Information";
    begin
        if TempLotInfo.FindSet() then
            repeat
                if LotInfo.Get(TempLotInfo."Item No.", TempLotInfo."Variant Code", TempLotInfo."Lot No.") then begin
                    LotInfo.Blocked := true;
                    LotInfo.Modify();
                end;
            until TempLotInfo.Next() = 0;
        TempLotInfo.DeleteAll();
    end;

    procedure SetQABin(_QABin: Boolean)
    begin
        QABin := _QABin;
    end;

    procedure GetQABin(): Boolean
    begin
        exit(QABin);
    end;

    procedure SetQARestriction(_QARestriction: Boolean)
    begin
        QARestriction := _QARestriction;
    end;

    procedure GetQARestriction(): Boolean
    begin
        exit(QARestriction);
    end;

    procedure SetShowQABin(JnlTemplateName: Code[10]; JnlBatchName: Code[10]; LocationCode: Code[10])
    var
        Location: Record Location;
        WhsJnlBatch: Record "Warehouse Journal Batch";
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        if Location.Get(LocationCode) then begin
            ShowQABin := Location."AQD QA. Bin Restriction";
        end;
        if WhsJnlBatch.Get(JnlTemplateName, JnlBatchName, Location.Code) then if WhsJnlBatch."AQD Allow QA. Transaction" then ShowQABin := false;
    end;

    procedure GetShowQABin(): Boolean
    begin
        exit(ShowQABin);
    end;

    procedure SetReclass(_SetReclass: Boolean)
    begin
        Reclass := _SetReclass;
    end;

    procedure GetReclass(): Boolean
    begin
        exit(Reclass);
    end;

    procedure IsInventoryQualityControlEnabled(): Boolean
    begin
        AcumensInventoryQCSetup.Reset();

        AQDInventoryQCAccessMgt.AccessManager('AQCM01', true, false);

        if not AcumensInventoryQCSetup.Get() then
            exit(false)
        else begin
            exit(AcumensInventoryQCSetup."AQD Enabled");
        end;
    end;

    var
        TempLotInfo: Record "Lot No. Information" temporary;
        ShowQABin: Boolean;
        QARestriction: Boolean;
        Reclass: Boolean;
        QABin: Boolean;
        JnlLineNo: Integer;
        AcumensInventoryQCSetup: Record "AQD Acumens Inventory QC Setup";
        AQDInventoryQCAccessMgt: Codeunit "AQD Inventory QC Access Mgt.";
}
