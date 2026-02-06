codeunit 14304105 "AQD QA Event Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforeCheckLotNoInfoNotBlocked, '', false, false)]
    local procedure OnBeforeCheckLotNoInfoNotBlocked(var ItemJnlLine2: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
        if (ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::"Negative Adjmt.") or (ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::"Positive Adjmt.") then IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Batch", OnBeforeCode, '', false, false)]
    local procedure OnBeforeCodeWhseJnlRegBatch(var WarehouseJournalLine: Record "Warehouse Journal Line")
    var
        WhseSetup: Record "Warehouse Setup";
        ItemRestrictions: Record "AQD Item Restrictions";
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
        Location: Record Location;
        Bin: Record Bin;
        QABin: Record Bin;
        QAManagement: Codeunit "AQD QA Management";
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        if WarehouseJournalLine.IsTemporary then exit;
        WhseSetup.Get;
        if not QASingleInstance.GetQABin() then
            if not WhseSetup."AQD Allow Partial Release" then begin
                WarehouseJournalLine.SetRange("Journal Template Name", WarehouseJournalLine."Journal Template Name");
                WarehouseJournalLine.SetRange("Journal Batch Name", WarehouseJournalLine."Journal Batch Name");
                if WarehouseJournalLine.FindSet() then
                    repeat
                        IF (WarehouseJournalLine."Entry Type" = WarehouseJournalLine."Entry Type"::Movement) AND (WarehouseJournalLine."Journal Batch Name" = WhseSetup."AQD QA. Warehouse Batch Name") and (WarehouseJournalLine."Journal Template Name" = WhseSetup."AQD QA. Whse Template Name") then exit;
                        WhseItemTrackingLine.SetRange("Source Batch Name", WarehouseJournalLine."Journal Template Name");
                        WhseItemTrackingLine.SetRange("Source ID", WarehouseJournalLine."Journal Batch Name");
                        WhseItemTrackingLine.SetRange("Location Code", WarehouseJournalLine."Location Code");
                        WhseItemTrackingLine.SetRange("Source Ref. No.", WarehouseJournalLine."Line No.");
                        WhseItemTrackingLine.SetRange("Item No.", WarehouseJournalLine."Item No.");
                        WhseItemTrackingLine.SetRange("Variant Code", WarehouseJournalLine."Variant Code");
                        if WhseItemTrackingLine.FindSet() or (WarehouseJournalLine."Lot No." <> '') then begin
                            ItemRestrictions.SetRange("Item No.", WarehouseJournalLine."Item No.");
                            ItemRestrictions.SetRange("Variant Code", WarehouseJournalLine."Variant Code");
                            if WarehouseJournalLine."Lot No." <> '' then
                                ItemRestrictions.SetRange("Lot No.", WarehouseJournalLine."Lot No.")
                            else
                                ItemRestrictions.SetRange("Lot No.", WhseItemTrackingLine."Lot No.");
                            ItemRestrictions.SetRange("Location Code", WarehouseJournalLine."Location Code");
                            ItemRestrictions.SetRange(Open, true);
                            ItemRestrictions.SetRange("Initial Entry", false);
                            if ItemRestrictions.FindFirst() then begin
                                Location.Get(WarehouseJournalLine."Location Code");
                                Bin.Get(WarehouseJournalLine."Location Code", WarehouseJournalLine."From Bin Code");
                                if not Bin."AQD Restrict Item" then begin
                                    if Location."Adjustment Bin Code" <> WarehouseJournalLine."From Bin Code" then
                                        if QABin.Get(WarehouseJournalLine."Location Code", WarehouseJournalLine."From Bin Code" + '-Q') then begin
                                            WarehouseJournalLine."From Zone Code" := Location."AQD QA. Zone";
                                            WarehouseJournalLine."From Bin Code" += '-Q';
                                            WarehouseJournalLine.Modify();
                                        end;
                                    if Location."Adjustment Bin Code" <> WarehouseJournalLine."To Bin Code" then
                                        if WarehouseJournalLine."To Zone Code" <> Location."AQD QA. Zone" then begin
                                            WarehouseJournalLine."To Zone Code" := Location."AQD QA. Zone";
                                            WarehouseJournalLine."To Bin Code" := QAManagement.CreateQABin(WarehouseJournalLine."Location Code", WarehouseJournalLine."To Bin Code");
                                            WarehouseJournalLine.Modify();
                                        end;
                                end;
                            end;
                        end;
                    until WarehouseJournalLine.Next() = 0;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Batch", 'OnBeforeUpdateDeleteLines', '', false, false)]
    local procedure OnAfterItemJnlPostLine(var WarehouseJournalLine: Record "Warehouse Journal Line")
    var
        WarehouseEntry: Record "Warehouse Entry";
        WhsJnlBatch: Record "Warehouse Journal Batch";
        WhseJrnlLine: Record "Warehouse Journal Line";
        FromBin: Record Bin;
        QAManagment: Codeunit "AQD QA Management";
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        WhseJrnlLine.SetRange("Journal Template Name", WarehouseJournalLine."Journal Template Name");
        WhseJrnlLine.SetRange("Journal Batch Name", WarehouseJournalLine."Journal Batch Name");
        if WhseJrnlLine.FindSet() then
            repeat
                if WhsJnlBatch.Get(WhseJrnlLine."Journal Template Name", WhseJrnlLine."Journal Batch Name", WhseJrnlLine."Location Code") then
                    if WhsJnlBatch."AQD Restrict Item" then
                        if WhseJrnlLine."To Bin Code" <> WhseJrnlLine."From Bin Code" then begin
                            FromBin.Get(WhseJrnlLine."Location Code", WhseJrnlLine."From Bin Code");
                            if FromBin."AQD Restrict Item" then begin
                                WarehouseEntry.SetRange("Journal Template Name", WhseJrnlLine."Journal Template Name");
                                WarehouseEntry.SetRange("Journal Batch Name", WhseJrnlLine."Journal Batch Name");
                                WarehouseEntry.SetRange("Whse. Document No.", WhseJrnlLine."Whse. Document No.");
                                if WhseJrnlLine.Count > 1 then WarehouseEntry.SetRange("Whse. Document Line No.", WhseJrnlLine."Line No.");
                                WarehouseEntry.SetFilter(Quantity, '>0');
                                if WarehouseEntry.FindFirst() then begin
                                    ClearLastError();
                                    QASingleInstance.SetQABin(true);
                                    repeat
                                        if not QAManagment.RegisterJnlActivity(WhseJrnlLine, WarehouseEntry) then begin
                                            QASingleInstance.SetQABin(false);
                                            Error(GetLastErrorText());
                                        end;
                                    until WarehouseEntry.Next() = 0;
                                    QASingleInstance.SetQABin(false);
                                end;
                            end;
                        end;
            until WhseJrnlLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", OnAfterRegisterWhseActivity, '', false, false)]
    local procedure OnBeforeWhseActivLineDelete(var WarehouseActivityHeader: Record "Warehouse Activity Header")
    var
        QAManagment: Codeunit "AQD QA Management";
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        if WarehouseActivityHeader.IsTemporary then exit;
        if WarehouseActivityHeader.Type in [WarehouseActivityHeader.Type::"Invt. Put-away", WarehouseActivityHeader.Type::"Put-away"] then begin
            ClearCollectedErrors();
            QASingleInstance.SetQABin(true);
            if not QAManagment.RegisterActivity(WarehouseActivityHeader) then begin
                QASingleInstance.SetQABin(false);
                Error(GetLastErrorCode);
            end;
            QASingleInstance.SetQABin(false);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCode(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        QAWarehouseActivityLine: Record "AQD QA-Warehouse Activity Line";
        Location: Record Location;
    begin
        if WarehouseActivityLine.IsTemporary then exit;
        QAWarehouseActivityLine.DeleteAll();
        if Location.Get(WarehouseActivityLine."Location Code") then
            if Location."AQD QA. Zone" <> '' then
                if WarehouseActivityLine.FindSet() then
                    repeat
                        QAWarehouseActivityLine.Init();
                        QAWarehouseActivityLine.TransferFields(WarehouseActivityLine);
                        if QAWarehouseActivityLine.Insert() then;
                    until WarehouseActivityLine.Next() = 0
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", 'OnBinLookUpOnAfterSetFilters', '', false, false)]
    local procedure OnBinLookUpOnAfterSetFilters(var Bin: Record Bin)
    var
        Location: Record Location;
        LocationCode: Code[20];
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        if Bin."Location Code" = '' then
            LocationCode := Bin.GetFilter("Location Code")
        else
            LocationCode := Bin."Location Code";
        if Location.Get(LocationCode) then if Location."AQD QA. Bin Restriction" then if QASingleInstance.GetShowQABin() then Bin.SetRange("AQD QA. Bin", false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", 'OnBeforeBinContentLookUp', '', false, false)]
    local procedure OnBeforeBinContentLookUp(LocationCode: Code[10]; ItemNo: Code[20]; VariantCode: Code[10]; ZoneCode: Code[10]; WhseItemTrackingSetup: Record "Item Tracking Setup"; CurrBinCode: Code[20]; var BinCode: Code[20]; var IsHandled: Boolean)
    var
        Location: Record Location;
        Item: Record Item;
        BinContent: Record "Bin Content";
        ItemTrackingCode: Record "Item Tracking Code";
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        if Location.Get(LocationCode) then
            if Location."AQD QA. Bin Restriction" then begin
                IsHandled := true;
                Item.Get(ItemNo);
                BinContent.SetCurrentKey("Location Code", "Item No.", "Variant Code");
                BinContent.SetRange("Location Code", LocationCode);
                BinContent.SetRange("Item No.", ItemNo);
                BinContent.SetRange("Variant Code", VariantCode);
                if QASingleInstance.GetShowQABin() then BinContent.SetRange("AQD QA. Bin", false);
                WhseItemTrackingSetup.CopyTrackingFromItemTrackingCodeWarehouseTracking(ItemTrackingCode);
                BinContent.SetTrackingFilterFromItemTrackingSetupIfNotBlankIfRequired(WhseItemTrackingSetup);
                if ZoneCode <> '' then BinContent.SetRange("Zone Code", ZoneCode);
                BinContent.SetRange("Bin Code", CurrBinCode);
                if BinContent.FindFirst() then;
                BinContent.SetRange("Bin Code");
                if PAGE.RunModal(0, BinContent) = ACTION::LookupOK then BinCode := BinContent."Bin Code";
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", OnBeforeCheckItemJnlLineLocation, '', false, false)]
    local procedure OnBeforeCheckItemJnlLineLocation(var ItemJournalLine: Record "Item Journal Line"; var xItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    var
        Location: Record Location;
        WarehouseSetup: Record "Warehouse Setup";
    begin
        WarehouseSetup.Get();
        if not WarehouseSetup."AQD Allow DPP. Transfer" then exit;
        if ItemJournalLine."Entry Type" in [ItemJournalLine."Entry Type"::"Negative Adjmt.", ItemJournalLine."Entry Type"::"Positive Adjmt.", ItemJournalLine."Entry Type"::Sale, ItemJournalLine."Entry Type"::Purchase] then exit;
        if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Transfer then begin
            if (ItemJournalLine."New Location Code" <> ItemJournalLine."Location Code") and ((ItemJournalLine."Location Code" <> xItemJournalLine."Location Code") or (ItemJournalLine."New Location Code" <> xItemJournalLine."New Location Code")) then begin
                Location.Get(ItemJournalLine."Location Code");
                Location.Get(ItemJournalLine."New Location Code");
            end;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", OnBeforeCheckItemJnlLineFieldChange, '', false, false)]
    local procedure OnBeforeCheckItemJnlLineFieldChange(var ItemJournalLine: Record "Item Journal Line"; var xItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    var
        Location: Record Location;
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComponent: Record "Prod. Order Component";
        WarehouseSetup: Record "Warehouse Setup";
        BinIsEligible: Boolean;
    begin
        WarehouseSetup.Get();
        if not WarehouseSetup."AQD Allow DPP. Transfer" then exit;
        if ItemJournalLine."Entry Type" in [ItemJournalLine."Entry Type"::"Negative Adjmt.", ItemJournalLine."Entry Type"::"Positive Adjmt.", ItemJournalLine."Entry Type"::Sale, ItemJournalLine."Entry Type"::Purchase] then begin
            exit;
        end;
        if ItemJournalLine."Location Code" = '' then exit;
        Location.Get(ItemJournalLine."Location Code");
        if ItemJournalLine."Order Type" = ItemJournalLine."Order Type"::Production then begin
            if (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Output) then if ProdOrderLine.Get(ProdOrderLine.Status::Released, ItemJournalLine."Order No.", ItemJournalLine."Order Line No.") then BinIsEligible := (ItemJournalLine."Location Code" = ProdOrderLine."Location Code") and (ItemJournalLine."Bin Code" = ProdOrderLine."Bin Code");
            if (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Consumption) then if ProdOrderComponent.Get(ProdOrderComponent.Status::Released, ItemJournalLine."Order No.", ItemJournalLine."Order Line No.", ItemJournalLine."Prod. Order Comp. Line No.") then BinIsEligible := (ItemJournalLine."Location Code" = ProdOrderComponent."Location Code") and (ItemJournalLine."Bin Code" = ProdOrderComponent."Bin Code");
        end;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", OnCodeBeforeInitWhseEntryFromBinCode, '', false, false)]
    local procedure OnCodeBeforeInitWhseEntryFromBinCode(WarehouseJournalLine: Record "Warehouse Journal Line")
    var
        WhsJnlBatch: Record "Warehouse Journal Batch";
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        if WhsJnlBatch.Get(WarehouseJournalLine."Journal Template Name", WarehouseJournalLine."Journal Batch Name", WarehouseJournalLine."Location Code") then QASingleInstance.SetQARestriction(WhsJnlBatch."AQD Allow QA. Transaction");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", OnAfterSplitWhseJnlLine, '', false, false)]
    local procedure OnAfterSplitWhseJnlLine(var TempWhseJnlLine: Record "Warehouse Journal Line" temporary; var TempWhseJnlLine2: Record "Warehouse Journal Line" temporary)
    begin
        TempWhseJnlLine2.ModifyAll("Whse. Document Line No.", TempWhseJnlLine."Line No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", OnBeforeInsertTransRcptLine, '', false, false)]
    local procedure OnBeforeInsertTransRcptLine(TransLine: Record "Transfer Line"; var TransRcptLine: Record "Transfer Receipt Line")
    begin
        if TransLine."AQD Restriction Code" <> '' then begin
            TransRcptLine."AQD Restriction Code" := TransLine."AQD Restriction Code";
            TransRcptLine."AQD Restriction Status" := TransLine."AQD Restriction Status";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", OnCodeOnAfterGetLastEntryNo, '', false, false)]
    local procedure OnCodeOnAfterGetLastEntryNo(var WhseJnlLine: Record "Warehouse Journal Line")
    var
        TransferLine: Record "Transfer Line";
        FromLocation: Record Location;
        ToLocation: Record Location;
        ItemRest: Record "AQD Item Restrictions";
        QAManagement: Codeunit "AQD QA Management";
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        if (WhseJnlLine."Source Type" = Database::"Transfer Line") and (WhseJnlLine."Source Subtype" = 0) then begin
            TransferLine.Get(WhseJnlLine."Source No.", WhseJnlLine."Source Line No.");
            if FromLocation.Get(WhseJnlLine."Location Code") then
                if FromLocation."AQD QA. Zone" = WhseJnlLine."From Zone Code" then
                    if ToLocation.Get(TransferLine."Transfer-to Code") then
                        if ToLocation."AQD QA. Zone" <> '' then begin
                            QASingleInstance.SetQARestriction(true);
                            ItemRest.SetRange("Location Code", WhseJnlLine."Location Code");
                            ItemRest.SetRange("Item No.", WhseJnlLine."Item No.");
                            ItemRest.SetRange("Variant Code", WhseJnlLine."Variant Code");
                            ItemRest.SetRange("Lot No.", WhseJnlLine."Lot No.");
                            ItemRest.SetRange("QA. Bin Code", WhseJnlLine."From Bin Code");
                            ItemRest.SetRange(Open, true);
                            if ItemRest.FindFirst() then begin
                                TransferLine."AQD Restriction Code" := ItemRest."Restriction Code";
                                TransferLine."AQD Restriction Status" := ItemRest."Restriction Status";
                                TransferLine.Modify();
                                ItemRest."Qty. to Handle" := WhseJnlLine.Quantity;
                                QAManagement.ReleaseRestriction(ItemRest, WhseJnlLine."Whse. Document No.", WhseJnlLine."Whse. Document Line No.");
                            end;
                        end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", OnAfterCode, '', false, false)]
    local procedure OnAfterCodeWhsJnlREgLine(var WarehouseJournalLine: Record "Warehouse Journal Line")
    var
        TransferLine: Record "Transfer Line";
        FromLocation: Record Location;
        ToLocation: Record Location;
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        if (WarehouseJournalLine."Source Type" = Database::"Transfer Line") and (WarehouseJournalLine."Source Subtype" = 0) then begin
            if TransferLine.Get(WarehouseJournalLine."Source No.", WarehouseJournalLine."Source Line No.") then begin
                if ToLocation.Get(TransferLine."Transfer-to Code") then if FromLocation.Get(WarehouseJournalLine."Location Code") then if FromLocation."AQD QA. Zone" = WarehouseJournalLine."From Zone Code" then if ToLocation."AQD QA. Zone" <> '' then QASingleInstance.SetQARestriction(false);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", OnAfterCheckWhseActivLine, '', false, false)]
    local procedure OnAfterCheckWhseActivLine(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        TransferLine: Record "Transfer Line";
        ToLocation: Record Location;
        LotInfo: Record "Lot No. Information";
        FromLocation: Record Location;
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        if LotInfo.Get(WarehouseActivityLine."Item No.", WarehouseActivityLine."Variant Code", WarehouseActivityLine."Lot No.") then
            if LotInfo.Blocked then
                if WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::Pick then
                    if WarehouseActivityLine."Action Type" = WarehouseActivityLine."Action Type"::Take then
                        if (WarehouseActivityLine."Source Type" = Database::"Transfer Line") and (WarehouseActivityLine."Source Subtype" = 0) then begin
                            if TransferLine.Get(WarehouseActivityLine."Source No.", WarehouseActivityLine."Source Line No.") then begin
                                ToLocation.Get(TransferLine."Transfer-to Code");
                                if FromLocation.Get(WarehouseActivityLine."Location Code") then if FromLocation."AQD QA. Zone" = WarehouseActivityLine."Zone Code" then if ToLocation."AQD QA. Zone" <> '' then QASingleInstance.UnBlockLot(WarehouseActivityLine."Item No.", WarehouseActivityLine."Variant Code", WarehouseActivityLine."Lot No.");
                            end;
                        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", OnCodeOnBeforeCommit, '', false, false)]
    local procedure OnCodeOnBeforeCommit()
    var
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        QASingleInstance.ResetLotInfo();
    end;

    [EventSubscriber(ObjectType::Table, DataBase::"Warehouse Entry", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertWhseEntry(var Rec: Record "Warehouse Entry")
    var
        QAManagment: Codeunit "AQD QA Management";
    begin
        if Rec.IsTemporary then exit;
        QAManagment.WhsEntryRestriction(Rec);
    end;

    [EventSubscriber(ObjectType::Table, DataBase::"Warehouse Journal Line", 'OnBeforeCheckTemplateName', '', false, false)]
    local procedure OnBeforeCheckTemplateName(var JnlTemplateName: Code[10]; var JnlBatchName: Code[10]; var LocationCode: Code[10])
    var
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        QASingleInstance.SetShowQABin(JnlTemplateName, JnlBatchName, LocationCode);
    end;

    [EventSubscriber(ObjectType::Table, DataBase::"Warehouse Entry", OnBeforeInsertEvent, '', false, false)]
    local procedure OnBeforeInsertEvent(var Rec: Record "Warehouse Entry")
    var
        WarehouseSetup: Record "Warehouse Setup";
        ItemJournalLine: Record "Item Journal Line";
        ItemJnlBatch: Record "Item Journal Batch";
        WhseJournalLine: Record "Warehouse Journal Line";
        WhseJnlBatch: Record "Warehouse Journal Batch";
        FLocation: Record Location;
        TLocation: Record Location;
        WEntry: Record "Warehouse Entry";
        FBin: Record Bin;
        TBin: Record Bin;
        BinContent: Record "Bin Content";
        WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line";
        QAManagment: Codeunit "AQD QA Management";
        QASingleInstance: Codeunit "AQD QA Single Instance";
        QAToQAError: Label 'Only Qa. to QA Location is allowed';
    begin
        if Rec.IsTemporary then exit;
        if QASingleInstance.GetReclass() then exit;
        if not BinContent.Get(Rec."Location Code", Rec."Bin Code", Rec."Item No.", Rec."Variant Code", Rec."Unit of Measure Code") then begin
            WhseJnlRegisterLine.InsertToBinContent(Rec);
        end;
        WarehouseSetup.Get();
        if WarehouseSetup."AQD Allow DPP. Transfer" then
            if Rec."Source Type" = Database::"Item Journal Line" then begin
                if ItemJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name") then begin
                    ItemJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    ItemJournalLine.SetRange("Document No.", Rec."Source No.");
                    ItemJournalLine.SetRange("Line No.", Rec."Source Line No.");
                    if ItemJournalLine.FindFirst() then
                        if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Transfer then begin
                            if (ItemJournalLine."New Location Code" <> ItemJournalLine."Location Code") then begin
                                FLocation.Get(ItemJournalLine."Location Code");
                                TLocation.Get(ItemJournalLine."New Location Code");
                                if Rec."Location Code" = ItemJournalLine."Location Code" then begin
                                    if FLocation."Directed Put-away and Pick" then begin
                                        FBin.Get(ItemJournalLine."Location Code", ItemJournalLine."Bin Code");
                                        Rec."Zone Code" := FBin."Zone Code";
                                        Rec."Bin Code" := ItemJournalLine."Bin Code";
                                        if FLocation."AQD QA. Zone" <> '' then begin
                                            FBin.Get(ItemJournalLine."Location Code", ItemJournalLine."Bin Code");
                                            TBin.Get(ItemJournalLine."New Location Code", ItemJournalLine."New Bin Code");
                                            if FBin."Zone Code" = FLocation."AQD QA. Zone" then begin
                                                if (FLocation."AQD QA. Zone" <> '') <> (TLocation."AQD QA. Zone" <> '') then Error(QAToQAError);
                                                if TBin."Zone Code" = TLocation."AQD QA. Zone" then begin
                                                    if (FLocation."AQD QA. Zone" <> '') <> (TLocation."AQD QA. Zone" <> '') then Error(QAToQAError);
                                                end
                                                else
                                                    Error(QAToQAError);
                                                ItemJnlBatch.TestField("AQD Allow QA. Transaction");
                                                FLocation.TestField("AQD Allow QA. Transfer");
                                                TLocation.TestField("AQD Allow QA. Transfer");
                                                QASingleInstance.SetQARestriction(true);
                                                QAManagment.TransferActrivity(ItemJournalLine."Location Code", ItemJournalLine."New Location Code", ItemJournalLine."Item No.", ItemJournalLine."Variant Code", Rec."Lot No.", ItemJournalLine."Bin Code", ItemJournalLine."New Bin Code", -Rec.Quantity, Rec."Unit of Measure Code", ItemJournalLine."Document No.", ItemJournalLine."Document Line No.");
                                            end;
                                        end;
                                    end;
                                end;
                                if Rec."Location Code" = ItemJournalLine."New Location Code" then begin
                                    if TLocation."Directed Put-away and Pick" then begin
                                        TBin.Get(ItemJournalLine."New Location Code", ItemJournalLine."New Bin Code");
                                        Rec."Zone Code" := TBin."Zone Code";
                                        Rec."Bin Code" := ItemJournalLine."New Bin Code";
                                    end;
                                end;
                            end;
                        end;
                end;
            end;
        if Rec."Entry Type" = Rec."Entry Type"::Movement then begin
            if Rec."Whse. Document Type" = Rec."Whse. Document Type"::"Whse. Journal" then
                if WhseJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."Location Code") then begin
                    WhseJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    WhseJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    WhseJournalLine.SetRange("Location Code", Rec."Location Code");
                    WhseJournalLine.SetRange("Whse. Document No.", Rec."Whse. Document No.");
                    WhseJournalLine.SetRange("Line No.", Rec."Whse. Document Line No.");
                    if WhseJournalLine.FindFirst() then
                        if WhseJournalLine."Entry Type" = WhseJournalLine."Entry Type"::Movement then
                            if WhseJournalLine."From Bin Code" <> WhseJournalLine."To Bin Code" then begin
                                FLocation.Get(WhseJournalLine."Location Code");
                                if Rec."Bin Code" = WhseJournalLine."From Bin Code" then begin
                                    if FLocation."Directed Put-away and Pick" then begin
                                        if FLocation."AQD QA. Zone" <> '' then begin
                                            FBin.Get(WhseJournalLine."Location Code", WhseJournalLine."From Bin Code");
                                            TBin.Get(WhseJournalLine."Location Code", WhseJournalLine."To Bin Code");
                                            if FBin."Zone Code" = FLocation."AQD QA. Zone" then begin
                                                WhseJnlBatch.TestField("AQD Allow QA. Transaction");
                                                QASingleInstance.SetQARestriction(true);
                                                QAManagment.TransferActrivity(WhseJournalLine."Location Code", WhseJournalLine."Location Code", WhseJournalLine."Item No.", WhseJournalLine."Variant Code", Rec."Lot No.", WhseJournalLine."From Bin Code", WhseJournalLine."To Bin Code", -Rec.Quantity, Rec."Unit of Measure Code", WhseJournalLine."Whse. Document No.", WhseJournalLine."Line No.");
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bin Content", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertEvent(var Rec: Record "Bin Content")
    var
        QAManagement: Codeunit "AQD QA Management";
    begin
        QAManagement.CreateBinContent(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Whse. Item Tracking Line", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertEventLotNo(var Rec: Record "Whse. Item Tracking Line")
    var
        WhseSetup: Record "Warehouse Setup";
        ItemRestrictions: Record "AQD Item Restrictions";
        WhseJnlLine: Record "Warehouse Journal Line";
        Location: Record Location;
        Bin: Record Bin;
        QABin: Record Bin;
        QAManagement: Codeunit "AQD QA Management";
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        if Rec.IsTemporary then exit;
        WhseSetup.Get;
        if not QASingleInstance.GetQABin() then
            if not WhseSetup."AQD Allow Partial Release" then begin
                ItemRestrictions.SetRange("Item No.", Rec."Item No.");
                ItemRestrictions.SetRange("Variant Code", Rec."Variant Code");
                ItemRestrictions.SetRange("Lot No.", Rec."Lot No.");
                ItemRestrictions.SetRange("Location Code", Rec."Location Code");
                ItemRestrictions.SetRange(Open, true);
                ItemRestrictions.SetRange("Initial Entry", false);
                if ItemRestrictions.FindFirst() then
                    if WhseJnlLine.Get(Rec."Source Batch Name", Rec."Source ID", Rec."Location Code", Rec."Source Ref. No.") then begin
                        IF (WhseJnlLine."Entry Type" = WhseJnlLine."Entry Type"::Movement) AND (WhseJnlLine."Journal Batch Name" = WhseSetup."AQD QA. Warehouse Batch Name") and (WhseJnlLine."Journal Template Name" = WhseSetup."AQD QA. Whse Template Name") then exit;
                        Location.Get(Rec."Location Code");
                        Bin.Get(Rec."Location Code", WhseJnlLine."From Bin Code");
                        if not Bin."AQD Restrict Item" then begin
                            if QABin.Get(WhseJnlLine."Location Code", WhseJnlLine."From Bin Code" + '-Q') then begin
                                WhseJnlLine."From Zone Code" := Location."AQD QA. Zone";
                                WhseJnlLine."From Bin Code" += '-Q';
                                WhseJnlLine.Modify();
                            end;
                            if WhseJnlLine."To Zone Code" <> Location."AQD QA. Zone" then begin
                                WhseJnlLine."To Zone Code" := Location."AQD QA. Zone";
                                WhseJnlLine."To Bin Code" := QAManagement.CreateQABin(WhseJnlLine."Location Code", WhseJnlLine."To Bin Code");
                                WhseJnlLine.Modify();
                            end;
                        end;
                    end;
            end;
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterNavigateFindTrackingRecords, '', false, false)]
    local procedure OnAfterNavigateFindTrackingRecords(var DocumentEntry: Record "Document Entry" temporary; LotNoFilter: Text)
    var
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        Navigate: Page Navigate;
    begin
        if (LotNoFilter = '') then exit;
        if ItemRestrictionEntry.ReadPermission() then begin
            ItemRestrictionEntry.Reset();
            ItemRestrictionEntry.SetCurrentKey("Lot No.");
            ItemRestrictionEntry.SetFilter("Lot No.", LotNoFilter);
            Navigate.InsertIntoDocEntry(DocumentEntry, Database::"AQD Item Restriction Entry", ItemRestrictionEntry.TableCaption(), ItemRestrictionEntry.Count);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnBeforeNavigateShowRecords, '', false, false)]
    local procedure OnBeforeShowRecords(TableID: Integer; var TempDocumentEntry: Record "Document Entry" temporary; var IsHandled: Boolean)
    var
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        Navigate: Page Navigate;
    begin
        if (TempDocumentEntry.GetFilter("Lot No. Filter") = '') then exit;
        if ItemRestrictionEntry.ReadPermission() then begin
            ItemRestrictionEntry.Reset();
            ItemRestrictionEntry.SetCurrentKey("Lot No.");
            ItemRestrictionEntry.SetFilter("Lot No.", TempDocumentEntry.GetFilter("Lot No. Filter"));
        end;
        case TableID of
            Database::"AQD Item Restriction Entry":
                begin
                    PAGE.Run(0, ItemRestrictionEntry);
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Reclass. Journal", OnBeforeActionEvent, Post, false, false)]
    local procedure OnBeforeActionEventItemReclas(var Rec: Record "Item Journal Line")
    var
        QAManagment: Codeunit "AQD QA Management";
    begin
        QAManagment.CheckBinQty(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Reclass. Journal", OnBeforeActionEvent, "Post and &Print", false, false)]
    local procedure OnBeforeActionEventItemReclasPP(var Rec: Record "Item Journal Line")
    var
        QAManagment: Codeunit "AQD QA Management";
    begin
        QAManagment.CheckBinQty(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Reclass. Journal", OnBeforeActionEvent, PreviewPosting, false, false)]
    local procedure OnBeforeActionEventPreviewPostingItemReclas(var Rec: Record "Item Journal Line")
    var
        QAManagment: Codeunit "AQD QA Management";
    begin
        QAManagment.CheckBinQty(Rec);
    end;
}
