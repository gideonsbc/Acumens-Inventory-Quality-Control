codeunit 14304104 "AQD QA Management"
{
    [TryFunction]
    procedure RestrictItem(var LotNo: Record "Lot No. Information"; QtyToHandle: Decimal; QtyToHandleBase: Decimal; RestrictionCode: Code[20]; RestrictionStatus: Code[20]; LocationCode: Code[20]; BinCode: Code[20]; UOM: Code[10])
    var
        Item: Record Item;
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        ItemRestrictions: Record "AQD Item Restrictions";
        WhseSetup: Record "Warehouse Setup";
        Location: Record Location;
        FromBin: Record Bin;
        ToBin: Record Bin;
        ItemUOM: Record "Item Unit of Measure";
        PostJnl: Boolean;
        RemQty: Decimal;
        DocNo: Code[20];
        LineNo: Integer;
        NGuid: Guid;
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Warehouse Batch Name");
        if Location.Get(LocationCode) then
            if Location."AQD QA. Zone" <> '' then begin
                FromBin.Get(LocationCode, BinCode);
                ToBin.Get(LocationCode, CreateQABin(LocationCode, FromBin.Code));
                Item.Get(LotNo."Item No.");
                DPPDelJnl(LocationCode);
                if Location."Directed Put-away and Pick" then
                    DPPAddJnl(LocationCode, LotNo."Item No.", LotNo."Variant Code", LotNo."Lot No.", BinCode, ToBin.Code, QtyToHandle, QtyToHandleBase, UOM, WhsEntryType::Movement, DocNo, LineNo)
                else
                    NAddJnl(LocationCode, LotNo."Item No.", LotNo."Variant Code", LotNo."Lot No.", BinCode, ToBin.Code, QtyToHandle, UOM, EntryType::Transfer, DocNo, LineNo);
                PostJnl := true;
                ItemUOM.Get(LotNo."Item No.", UOM);
                SetRestriction(LotNo."Item No.", LotNo."Variant Code", LotNo."Lot No.", LocationCode, BinCode, DocNo, LineNo, '', QtyToHandle, QtyToHandle * ItemUOM."Qty. per Unit of Measure", UOM, ItemUOM."Qty. per Unit of Measure", ToBin.Code, RestrictionCode, RestrictionStatus, False, NGuid, NGuid);
                if PostJnl then begin
                    if Location."Directed Put-away and Pick" then
                        DPPPost()
                    else
                        NPost();
                end;
            end;
    end;

    [TryFunction]
    procedure RegisterActivity(var WarehouseActivityHeader: Record "Warehouse Activity Header")
    var
        QAWarehouseActivityLine: Record "AQD QA-Warehouse Activity Line";
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        ItemRestrictions: Record "AQD Item Restrictions";
        WhseSetup: Record "Warehouse Setup";
        TransferReceiptLine: Record "Transfer Receipt Line";
        Location: Record Location;
        FromBin: Record Bin;
        ToBin: Record Bin;
        WhseItemRestriction: Record "AQD Warehouse Item Restriction";
        PostJnl: Boolean;
        RemQty: Decimal;
        DocNo: Code[20];
        RestrictionCode: Code[40];
        RestrictionStatus: Code[20];
        LineNo: Integer;
    begin
        RestrictionCode := '';
        RestrictionStatus := '';
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Warehouse Batch Name");
        QAWarehouseActivityLine.SetRange("Activity Type", WarehouseActivityHeader.Type);
        QAWarehouseActivityLine.SetRange("No.", WarehouseActivityHeader."No.");
        QAWarehouseActivityLine.SetRange("Action Type", QAWarehouseActivityLine."Action Type"::Place);
        if QAWarehouseActivityLine.FindSet() then begin
            if Location.Get(QAWarehouseActivityLine."Location Code") then
                if Location."AQD QA. Zone" <> '' then begin
                    DPPDelJnl(QAWarehouseActivityLine."Location Code");
                    repeat
                        WhseItemRestriction.SetRange("Item No.", QAWarehouseActivityLine."Item No.");
                        case QAWarehouseActivityLine."Source Document" of
                            "Warehouse Activity Source Document"::"Purchase Order":
                                WhseItemRestriction.SetRange(Type, WhseItemRestriction.Type::Purchase);
                            "Warehouse Activity Source Document"::"Inbound Transfer":
                                WhseItemRestriction.SetRange(Type, WhseItemRestriction.Type::Transfer);
                        end;
                        if WhseItemRestriction.FindFirst() then begin
                            RestrictionCode := WhseItemRestriction."Restriction Code";
                            RestrictionStatus := WhseItemRestriction."Restriction Status";
                        end
                        else begin
                            TransferReceiptLine.SetRange("Transfer Order No.", QAWarehouseActivityLine."Source No.");
                            TransferReceiptLine.SetRange("Line No.", QAWarehouseActivityLine."Source Line No.");
                            if TransferReceiptLine.FindFirst() then
                                if TransferReceiptLine."AQD Restriction Code" <> '' then begin
                                    RestrictionCode := TransferReceiptLine."AQD Restriction Code";
                                    RestrictionStatus := TransferReceiptLine."AQD Restriction Status";
                                end;
                        end;
                        if RestrictionCode <> '' then begin
                            ItemRestrictionEntry.SetRange("Item No.", QAWarehouseActivityLine."Item No.");
                            ItemRestrictionEntry.SetRange("Variant Code", QAWarehouseActivityLine."Variant Code");
                            ItemRestrictionEntry.SetRange("Lot No.", QAWarehouseActivityLine."Lot No.");
                            ItemRestrictionEntry.SetRange("Restriction Code", RestrictionCode);
                            ItemRestrictionEntry.SetRange("Restriction Status", RestrictionStatus);
                            ItemRestrictionEntry.SetRange("Document No.", QAWarehouseActivityLine."Source No.");
                            ItemRestrictionEntry.SetRange("Document Line No.", QAWarehouseActivityLine."Source Line No.");
                            ItemRestrictionEntry.SetRange("Unit of Measure Code", QAWarehouseActivityLine."Unit of Measure Code");
                            ItemRestrictionEntry.SetRange("Initial Entry", true);
                            if ItemRestrictionEntry.FindFirst() then begin
                                ItemRestrictionEntry.CalcSums("Remaining Qty.");
                                if ItemRestrictionEntry."Remaining Qty." >= QAWarehouseActivityLine."Qty. to Handle" then begin
                                    FromBin.Get(QAWarehouseActivityLine."Location Code", QAWarehouseActivityLine."Bin Code");
                                    ToBin.Get(QAWarehouseActivityLine."Location Code", CreateQABin(QAWarehouseActivityLine."Location Code", FromBin.Code));
                                    if Location."Directed Put-away and Pick" then
                                        DPPAddJnl(QAWarehouseActivityLine."Location Code", QAWarehouseActivityLine."Item No.", QAWarehouseActivityLine."Variant Code", QAWarehouseActivityLine."Lot No.", QAWarehouseActivityLine."Bin Code", ToBin.Code, QAWarehouseActivityLine."Qty. to Handle", QAWarehouseActivityLine."Qty. to Handle (Base)", QAWarehouseActivityLine."Unit of Measure Code", WhsEntryType::Movement, DocNo, LineNo)
                                    else
                                        NAddJnl(QAWarehouseActivityLine."Location Code", QAWarehouseActivityLine."Item No.", QAWarehouseActivityLine."Variant Code", QAWarehouseActivityLine."Lot No.", QAWarehouseActivityLine."Bin Code", ToBin.Code, QAWarehouseActivityLine."Qty. to Handle", QAWarehouseActivityLine."Unit of Measure Code", EntryType::Transfer, DocNo, LineNo);
                                    PostJnl := true;
                                    ItemRestrictions.Get(ItemRestrictionEntry."Restriction ID");
                                    SetRestriction(QAWarehouseActivityLine."Item No.", QAWarehouseActivityLine."Variant Code", QAWarehouseActivityLine."Lot No.", QAWarehouseActivityLine."Location Code", QAWarehouseActivityLine."Bin Code", QAWarehouseActivityLine."Source No.", QAWarehouseActivityLine."Source Line No.", ItemRestrictions."Document No.", QAWarehouseActivityLine."Qty. to Handle", QAWarehouseActivityLine."Qty. to Handle (Base)", QAWarehouseActivityLine."Unit of Measure Code", QAWarehouseActivityLine."Qty. per Unit of Measure", ToBin.Code, RestrictionCode, RestrictionStatus, False, ItemRestrictionEntry."Restriction ID", ItemRestrictionEntry."Initial Restriction ID");
                                    ItemRestrictions."Qty. to Handle" := QAWarehouseActivityLine."Qty. to Handle";
                                    ReleaseRestriction(ItemRestrictions, QAWarehouseActivityLine."Source No.", QAWarehouseActivityLine."Source Line No.");
                                end;
                            end;
                        end;
                    until QAWarehouseActivityLine.Next() = 0;
                    if PostJnl then begin
                        if Location."Directed Put-away and Pick" then
                            DPPPost()
                        else
                            NPost();
                    end;
                end;
            QAWarehouseActivityLine.DeleteAll();
        end;
    end;

    procedure SplitLotActivity(LocationCode: Code[20]; ItemNo: Code[20]; VariantCode: Code[20]; NewLotNo: Code[50]; LotNo: Code[50]; QABin: Code[20]; Qty: Decimal; UOM: Code[20]; var DocNo: Code[20]; var LineNo: Integer)
    var
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        ItemRestrictions: Record "AQD Item Restrictions";
        WhseSetup: Record "Warehouse Setup";
        Location: Record Location;
        PostJnl: Boolean;
        RemQty: Decimal;
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Warehouse Batch Name");
        if Location.Get(LocationCode) then
            if Location."AQD QA. Zone" <> '' then begin
                ItemRestrictions.SetRange("Item No.", ItemNo);
                ItemRestrictions.SetRange("Variant Code", VariantCode);
                ItemRestrictions.SetRange("Lot No.", LotNo);
                ItemRestrictions.SetRange("Location Code", LocationCode);
                ItemRestrictions.SetRange("QA. Bin Code", QABin);
                ItemRestrictions.SetRange(Open, true);
                ItemRestrictions.SetRange("Unit of Measure Code", UOM);
                if ItemRestrictions.FindFirst() then begin
                    ItemRestrictions.CalcFields("Remaining Qty.");
                    if ItemRestrictions."Remaining Qty." >= Qty then begin
                        SetRestriction(ItemNo, VariantCode, NewLotNo, LocationCode, ItemRestrictions."Release Bin Code", DocNo, LineNo, '', Qty, Qty * ItemRestrictions."Qty. per Unit of Measure", ItemRestrictions."Unit of Measure Code", ItemRestrictions."Qty. per Unit of Measure", QABin, ItemRestrictions."Restriction Code", ItemRestrictions."Restriction Status", ItemRestrictions."Initial Entry", ItemRestrictions."Restriction ID", ItemRestrictions."Initial Restriction ID");
                        ItemRestrictions."Qty. to Handle" := Qty;
                        ReleaseRestriction(ItemRestrictions, DocNo, LineNo);
                        UpLotInfo(ItemNo, VariantCode, LotNo, true);
                    end;
                end;
            end;
    end;

    procedure TransferActrivity(FLocationCode: Code[20]; TLocationCode: Code[20]; ItemNo: Code[20]; VariantCode: Code[20]; LotNo: Code[50]; FQABin: Code[20]; TQABin: Code[20]; Qty: Decimal; UOM: Code[20]; var DocNo: Code[20]; var LineNo: Integer)
    var
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        ItemRestrictions: Record "AQD Item Restrictions";
        WhseSetup: Record "Warehouse Setup";
        Location: Record Location;
        BinContent: Record "Bin Content";
        PostJnl: Boolean;
        RemQty: Decimal;
        PartialBinCount: Integer;
        RestError: Label 'There are multiple Item Restrictions found for the Item No. %1, Lot No. %2 and at Bin %3, please reach QA for processing. ';
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Warehouse Batch Name");
        if Location.Get(FLocationCode) then
            if Location."AQD QA. Zone" <> '' then begin
                ItemRestrictions.SetRange("Item No.", ItemNo);
                ItemRestrictions.SetRange("Variant Code", VariantCode);
                ItemRestrictions.SetRange("Lot No.", LotNo);
                ItemRestrictions.SetRange("Location Code", FLocationCode);
                ItemRestrictions.SetRange("QA. Bin Code", FQABin);
                ItemRestrictions.SetRange(Open, true);
                ItemRestrictions.SetRange("Unit of Measure Code", UOM);
                ItemRestrictions.FindFirst();
                if ItemRestrictions.Count > 1 then Error(RestError, ItemNo, LotNo, FQABin);
                // if not WhseSetup."Allow Partial Release" then begin
                //     PartialBinCount := 0;
                //     BinContent.SetRange("Location Code", FLocationCode);
                //     BinContent.SetRange("Item No.", ItemNo);
                //     BinContent.SetRange("Variant Code", VariantCode);
                //     BinContent.SetRange("Lot No. Filter", LotNo);
                //     if BinContent.FindSet() then
                //         repeat
                //             BinContent.CalcFields("Quantity (Base)");
                //             if BinContent."Quantity (Base)" <> 0 then
                //                 PartialBinCount += 1;
                //         until BinContent.Next() = 0;
                //     if PartialBinCount > 1 then
                //         WhseSetup.TestField("Allow Partial Release");
                // end;
                ItemRestrictions.CalcFields("Remaining Qty.");
                if ItemRestrictions."Remaining Qty." >= Qty then begin
                    SetRestriction(ItemNo, VariantCode, LotNo, TLocationCode, ReplaceString(TQABin, '-Q', ''), DocNo, LineNo, '', Qty, Qty * ItemRestrictions."Qty. per Unit of Measure", ItemRestrictions."Unit of Measure Code", ItemRestrictions."Qty. per Unit of Measure", TQABin, ItemRestrictions."Restriction Code", ItemRestrictions."Restriction Status", ItemRestrictions."Initial Entry", ItemRestrictions."Restriction ID", ItemRestrictions."Initial Restriction ID");
                    ItemRestrictions."Qty. to Handle" := Qty;
                    ReleaseRestriction(ItemRestrictions, DocNo, LineNo);
                end;
            end;
    end;

    [TryFunction]
    procedure RegisterJnlActivity(var WarehouseJournalLine: Record "Warehouse Journal Line"; var WarehouseEntry: Record "Warehouse Entry")
    var
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        ItemRestrictions: Record "AQD Item Restrictions";
        WhseSetup: Record "Warehouse Setup";
        Location: Record Location;
        FromBin: Record Bin;
        ToBin: Record Bin;
        WhseItemRestriction: Record "AQD Warehouse Item Restriction";
        PostJnl: Boolean;
        RemQty: Decimal;
        DocNo: Code[20];
        LineNo: Integer;
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Warehouse Batch Name");
        if Location.Get(WarehouseEntry."Location Code") then
            if Location."AQD QA. Zone" <> '' then begin
                WhseItemRestriction.SetRange("Item No.", WarehouseEntry."Item No.");
                WhseItemRestriction.SetRange(Type, WhseItemRestriction.Type::Production);
                if WhseItemRestriction.FindFirst() then begin
                    ItemRestrictionEntry.SetRange("Item No.", WarehouseEntry."Item No.");
                    ItemRestrictionEntry.SetRange("Variant Code", WarehouseEntry."Variant Code");
                    ItemRestrictionEntry.SetRange("Lot No.", WarehouseEntry."Lot No.");
                    ItemRestrictionEntry.SetRange("Restriction Code", WhseItemRestriction."Restriction Code");
                    ItemRestrictionEntry.SetRange("Initial Entry", true);
                    if ItemRestrictionEntry.FindFirst() then begin
                        ItemRestrictionEntry.CalcSums("Remaining Qty.");
                        if ItemRestrictionEntry."Remaining Qty." >= WarehouseEntry.Quantity then begin
                            FromBin.Get(WarehouseEntry."Location Code", WarehouseJournalLine."From Bin Code");
                            if FromBin."AQD Restrict Item" then begin
                                ToBin.Get(WarehouseEntry."Location Code", CreateQABin(WarehouseEntry."Location Code", WarehouseEntry."Bin Code"));
                                DPPDelJnl(WarehouseEntry."Location Code");
                                if Location."Directed Put-away and Pick" then
                                    DPPAddJnl(WarehouseEntry."Location Code", WarehouseEntry."Item No.", WarehouseEntry."Variant Code", WarehouseEntry."Lot No.", WarehouseEntry."Bin Code", ToBin.Code, WarehouseEntry.Quantity, WarehouseEntry."Qty. (Base)", WarehouseEntry."Unit of Measure Code", WhsEntryType::Movement, DocNo, LineNo)
                                else
                                    NAddJnl(WarehouseEntry."Location Code", WarehouseEntry."Item No.", WarehouseEntry."Variant Code", WarehouseEntry."Lot No.", WarehouseEntry."Bin Code", ToBin.Code, WarehouseEntry.Quantity, WarehouseEntry."Unit of Measure Code", EntryType::Transfer, DocNo, LineNo);
                                PostJnl := true;
                                SetRestriction(WarehouseEntry."Item No.", WarehouseEntry."Variant Code", WarehouseEntry."Lot No.", WarehouseEntry."Location Code", WarehouseEntry."Bin Code", DocNo, LineNo, WarehouseEntry."Source No.", WarehouseEntry.Quantity, WarehouseEntry."Qty. (Base)", WarehouseEntry."Unit of Measure Code", WarehouseEntry."Qty. per Unit of Measure", ToBin.Code, WhseItemRestriction."Restriction Code", WhseItemRestriction."Restriction Status", False, ItemRestrictionEntry."Restriction ID", ItemRestrictionEntry."Initial Restriction ID");
                                ItemRestrictions.Get(ItemRestrictionEntry."Restriction ID");
                                ItemRestrictions."Qty. to Handle" := WarehouseEntry.Quantity;
                                ReleaseRestriction(ItemRestrictions, DocNo, LineNo);
                            end;
                        end;
                    end;
                end;
                if PostJnl then begin
                    if Location."Directed Put-away and Pick" then
                        DPPPost()
                    else
                        NPost();
                end;
            end;
    end;

    procedure RegisterRelease(var ItemRestrictions: Record "AQD Item Restrictions")
    var
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        WhseSetup: Record "Warehouse Setup";
        Location: Record Location;
        QASingleInstance: Codeunit "AQD QA Single Instance";
        NoSeriesMgt: Codeunit "No. Series";
        QABinCode: Code[20];
        PostJnl: Boolean;
        DocNo: Code[20];
        LineNo: Integer;
        RemQty: Decimal;
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Warehouse Batch Name");
        if Location.Get(ItemRestrictions."Location Code") then begin
            QASingleInstance.SetReclass(true);
            QASingleInstance.SetQABin(true);
            if ItemRestrictions."Initial Entry" then begin
                ItemRestrictions.CalcFields("Remaining Qty.");
                ItemRestrictions."Qty. to Handle" := ItemRestrictions."Remaining Qty.";
                ItemRestrictionEntry.SetRange("Restriction ID", ItemRestrictions."Restriction ID");
                if ItemRestrictions."Initial Entry" then begin
                    ItemRestrictionEntry.ModifyAll("Remaining Qty.", 0);
                end;
            end
            else begin
                DPPDelJnl(ItemRestrictions."Location Code");
                if Location."Directed Put-away and Pick" then
                    DPPAddJnl(ItemRestrictions."Location Code", ItemRestrictions."Item No.", ItemRestrictions."Variant Code", ItemRestrictions."Lot No.", ItemRestrictions."QA. Bin Code", ItemRestrictions."Release Bin Code", ItemRestrictions."Qty. to Handle", 0, ItemRestrictions."Unit of Measure Code", WhsEntryType::Movement, DocNo, LineNo)
                else
                    NAddJnl(ItemRestrictions."Location Code", ItemRestrictions."Item No.", ItemRestrictions."Variant Code", ItemRestrictions."Lot No.", ItemRestrictions."QA. Bin Code", ItemRestrictions."Release Bin Code", ItemRestrictions."Qty. to Handle", ItemRestrictions."Unit of Measure Code", EntryType::Transfer, DocNo, LineNo);
                PostJnl := true;
            end;
            ReleaseRestriction(ItemRestrictions, DocNo, LineNo);
            UpLotInfo(ItemRestrictions."Item No.", ItemRestrictions."Variant Code", ItemRestrictions."Lot No.", false);
            if PostJnl then begin
                if Location."Directed Put-away and Pick" then
                    DPPPost()
                else
                    NPost();
            end;
            QASingleInstance.SetReclass(false);
            QASingleInstance.SetQABin(false);
        end;
    end;

    [TryFunction]
    procedure RegisterScrap(var ItemRestrictions: Record "AQD Item Restrictions")
    var
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        WhseSetup: Record "Warehouse Setup";
        Location: Record Location;
        NoSeriesMgt: Codeunit "No. Series";
        QABinCode: Code[20];
        PostJnl: Boolean;
        DocNo: Code[20];
        LineNo: Integer;
        RemQty: Decimal;
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Warehouse Batch Name");
        if Location.Get(ItemRestrictions."Location Code") then begin
            DPPDelJnl(ItemRestrictions."Location Code");
            if Location."Directed Put-away and Pick" then
                DPPAddJnl(ItemRestrictions."Location Code", ItemRestrictions."Item No.", ItemRestrictions."Variant Code", ItemRestrictions."Lot No.", ItemRestrictions."QA. Bin Code", ItemRestrictions."QA. Bin Code", ItemRestrictions."Qty. to Handle", 0, ItemRestrictions."Unit of Measure Code", WhsEntryType::"Negative Adjmt.", DocNo, LineNo)
            else
                NAddJnl(ItemRestrictions."Location Code", ItemRestrictions."Item No.", ItemRestrictions."Variant Code", ItemRestrictions."Lot No.", ItemRestrictions."QA. Bin Code", ItemRestrictions."QA. Bin Code", ItemRestrictions."Qty. to Handle", ItemRestrictions."Unit of Measure Code", EntryType::"Negative Adjmt.", DocNo, LineNo);
            PostJnl := true;
        end;
        ReleaseRestriction(ItemRestrictions, DocNo, LineNo);
        if PostJnl then begin
            if Location."Directed Put-away and Pick" then
                DPPPost()
            else
                NPost();
        end;
    end;

    procedure RegisterReclass(var ItemRestrictions: Record "AQD Item Restrictions"; RestrictionCode: Code[20]; RestrictionStatus: Code[20]; FromBinCode: Code[20]; FBinCode: Code[20]; TBinCode: Code[20])
    var
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        WhseSetup: Record "Warehouse Setup";
        Location: Record Location;
        ToBin: Record Bin;
        FromBin: Record Bin;
        NoSeriesMgt: Codeunit "No. Series";
        QASingleInstance: Codeunit "AQD QA Single Instance";
        QABinCode: Code[20];
        PostJnl: Boolean;
        DocNo: Code[20];
        LineNo: Integer;
        RemQty: Decimal;
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Warehouse Batch Name");
        if Location.Get(ItemRestrictions."Location Code") then begin
            if FBinCode <> TBinCode then begin
                FromBin.Get(ItemRestrictions."Location Code", FBinCode);
                ToBin.SetRange("Location Code", ItemRestrictions."Location Code");
                ToBin.SetRange("Zone Code", Location."AQD QA. Zone");
                ToBin.SetRange(Code, TBinCode);
                if not ToBin.FindFirst() then begin
                    ToBin.Init();
                    ToBin.TransferFields(FromBin);
                    ToBin.Code := TBinCode;
                    ToBin."Zone Code" := Location."AQD QA. Zone";
                    ToBin."AQD QA. Bin" := true;
                    ToBin.Insert();
                end;
                DPPDelJnl(ItemRestrictions."Location Code");
                if Location."Directed Put-away and Pick" then
                    DPPAddJnl(ItemRestrictions."Location Code", ItemRestrictions."Item No.", ItemRestrictions."Variant Code", ItemRestrictions."Lot No.", FBinCode, TBinCode, ItemRestrictions."Qty. to Handle", 0, ItemRestrictions."Unit of Measure Code", WhsEntryType::Movement, DocNo, LineNo)
                else
                    NAddJnl(ItemRestrictions."Location Code", ItemRestrictions."Item No.", ItemRestrictions."Variant Code", ItemRestrictions."Lot No.", FBinCode, TBinCode, ItemRestrictions."Qty. to Handle", ItemRestrictions."Unit of Measure Code", EntryType::Transfer, DocNo, LineNo);
                PostJnl := true;
            end;
            SetRestriction(ItemRestrictions."Item No.", ItemRestrictions."Variant Code", ItemRestrictions."Lot No.", ItemRestrictions."Location Code", FromBinCode, DocNo, LineNo, ItemRestrictions."Document No.", ItemRestrictions."Qty. to Handle", ItemRestrictions."Qty. to Handle" * ItemRestrictions."Qty. per Unit of Measure", ItemRestrictions."Unit of Measure Code", ItemRestrictions."Qty. per Unit of Measure", TBinCode, RestrictionCode, RestrictionStatus, False, ItemRestrictions."Restriction ID", ItemRestrictions."Initial Restriction ID");
            ReleaseRestriction(ItemRestrictions, DocNo, LineNo);
            QASingleInstance.SetReclass(true);
            if PostJnl then begin
                if Location."Directed Put-away and Pick" then
                    DPPPost()
                else
                    NPost();
            end;
            QASingleInstance.SetReclass(false);
        end;
    end;

    procedure WhsEntryRestriction(var WarehouseEntry: Record "Warehouse Entry")
    var
        WhseSetup: Record "Warehouse Setup";
        WhseItemRestriction: Record "AQD Warehouse Item Restriction";
        Location: Record Location;
        Bin: Record Bin;
        ItemRestrictions: Record "AQD Item Restrictions";
        TransferLine: Record "Transfer Line";
        QASingleInstance: Codeunit "AQD QA Single Instance";
        NGuid: Guid;
        RestrictionCode: Code[20];
        RestrictionStatus: Code[20];
        XRestrictionCode: Code[20];
        XRestrictionStatus: Code[20];
        EndCheck: Boolean;
        RestError: Label 'There are multiple Item Restrictions found for the Item No. %1, Lot No. %2 and at Bin %3, please reach QA for processing. ';
        RestError2: Label 'Lot No. %2 is restricted, Bin %3 should be a -Q bin.';
    begin
        Location.Get(WarehouseEntry."Location Code");
        if Location."AQD QA. Bin Restriction" then begin
            if not QASingleInstance.GetQARestriction() then if Bin.Get(WarehouseEntry."Location Code", WarehouseEntry."Bin Code") then if Bin."Zone Code" = Location."AQD QA. Zone" then Location.TestField("AQD QA. Bin Restriction", false);
        end;
        if Location."AQD QA. Zone" <> '' then
            case WarehouseEntry."Entry Type" of
                WarehouseEntry."Entry Type"::"Positive Adjmt.":
                    case WarehouseEntry."Whse. Document Type" of
                        "Warehouse Journal Document Type"::Production:
                            begin
                                IF WarehouseEntry."Source Document" = WarehouseEntry."Source Document"::"Consumption Jnl." then exit;
                                WhseItemRestriction.SetRange("Item No.", WarehouseEntry."Item No.");
                                WhseItemRestriction.SetRange(Type, WhseItemRestriction.Type::Production);
                                if WhseItemRestriction.FindFirst() then SetRestriction(WarehouseEntry."Item No.", WarehouseEntry."Variant Code", WarehouseEntry."Lot No.", WarehouseEntry."Location Code", WarehouseEntry."Bin Code", WarehouseEntry."Whse. Document No.", WarehouseEntry."Whse. Document Line No.", WarehouseEntry."Source No.", WarehouseEntry.Quantity, WarehouseEntry."Qty. (Base)", WarehouseEntry."Unit of Measure Code", WarehouseEntry."Qty. per Unit of Measure", '', WhseItemRestriction."Restriction Code", WhseItemRestriction."Restriction Status", True, NGuid, NGuid);
                            end;
                        "Warehouse Journal Document Type"::Receipt:
                            begin
                                WhseItemRestriction.SetRange("Item No.", WarehouseEntry."Item No.");
                                if WarehouseEntry."Source Document" = WarehouseEntry."Source Document"::"P. Order" then WhseItemRestriction.SetRange(Type, WhseItemRestriction.Type::Purchase);
                                if WarehouseEntry."Source Document" = WarehouseEntry."Source Document"::"Inb. Transfer" then begin
                                    if TransferLine.Get(WarehouseEntry."Source No.", WarehouseEntry."Source Line No.") then
                                        if TransferLine."AQD Restriction Code" <> '' then begin
                                            SetRestriction(WarehouseEntry."Item No.", WarehouseEntry."Variant Code", WarehouseEntry."Lot No.", WarehouseEntry."Location Code", WarehouseEntry."Bin Code", WarehouseEntry."Source No.", WarehouseEntry."Source Line No.", WarehouseEntry."Source No.", WarehouseEntry.Quantity, WarehouseEntry."Qty. (Base)", WarehouseEntry."Unit of Measure Code", WarehouseEntry."Qty. per Unit of Measure", '', TransferLine."AQD Restriction Code", TransferLine."AQD Restriction Status", True, NGuid, NGuid);
                                            exit;
                                        end;
                                    WhseItemRestriction.SetRange(Type, WhseItemRestriction.Type::Transfer);
                                end;
                                if WhseItemRestriction.FindFirst() then SetRestriction(WarehouseEntry."Item No.", WarehouseEntry."Variant Code", WarehouseEntry."Lot No.", WarehouseEntry."Location Code", WarehouseEntry."Bin Code", WarehouseEntry."Source No.", WarehouseEntry."Source Line No.", WarehouseEntry."Source No.", WarehouseEntry.Quantity, WarehouseEntry."Qty. (Base)", WarehouseEntry."Unit of Measure Code", WarehouseEntry."Qty. per Unit of Measure", '', WhseItemRestriction."Restriction Code", WhseItemRestriction."Restriction Status", True, NGuid, NGuid);
                            end;
                        "Warehouse Journal Document Type"::" ", "Warehouse Journal Document Type"::"Whse. Phys. Inventory":
                            begin
                                if Location.Get(WarehouseEntry."Location Code") then
                                    if Location."AQD QA. Zone" <> '' then
                                        if Bin.Get(WarehouseEntry."Location Code", WarehouseEntry."Bin Code") then
                                            if Bin."Zone Code" = Location."AQD QA. Zone" then begin
                                                WhseSetup.Get();
                                                WhseSetup.TestField("AQD Inv. Counts Restr. Code");
                                                WhseSetup.TestField("AQD Inv. Counts Restr. Status");
                                                RestrictionCode := WhseSetup."AQD Inv. Counts Restr. Code";
                                                RestrictionStatus := WhseSetup."AQD Inv. Counts Restr. Status";
                                                ItemRestrictions.SetRange("Item No.", WarehouseEntry."Item No.");
                                                ItemRestrictions.SetRange("Variant Code", WarehouseEntry."Variant Code");
                                                ItemRestrictions.SetRange("Lot No.", WarehouseEntry."Lot No.");
                                                ItemRestrictions.SetRange("Location Code", WarehouseEntry."Location Code");
                                                ItemRestrictions.SetRange(Open, true);
                                                ItemRestrictions.SetRange("Unit of Measure Code", WarehouseEntry."Unit of Measure Code");
                                                if ItemRestrictions.FindSet() then
                                                    repeat
                                                        if XRestrictionCode = '' then begin
                                                            XRestrictionCode := ItemRestrictions."Restriction Code";
                                                            XRestrictionStatus := ItemRestrictions."Restriction Status";
                                                        end;
                                                        if (XRestrictionCode <> ItemRestrictions."Restriction Code") or (XRestrictionStatus <> ItemRestrictions."Restriction Status") then begin
                                                            XRestrictionCode := '';
                                                            XRestrictionStatus := '';
                                                            EndCheck := true;
                                                        end;
                                                    until (ItemRestrictions.Next() = 0) or EndCheck;
                                                if XRestrictionCode <> '' then begin
                                                    RestrictionCode := XRestrictionCode;
                                                    RestrictionStatus := XRestrictionStatus;
                                                end;
                                                SetRestriction(WarehouseEntry."Item No.", WarehouseEntry."Variant Code", WarehouseEntry."Lot No.", WarehouseEntry."Location Code", ReplaceString(WarehouseEntry."Bin Code", '-Q', ''), WarehouseEntry."Source No.", WarehouseEntry."Source Line No.", WarehouseEntry."Source No.", WarehouseEntry.Quantity, WarehouseEntry."Qty. (Base)", WarehouseEntry."Unit of Measure Code", WarehouseEntry."Qty. per Unit of Measure", WarehouseEntry."Bin Code", RestrictionCode, RestrictionStatus, false, NGuid, NGuid);
                                            end
                                            else begin
                                                if WarehouseEntry."Bin Code" <> Location."Adjustment Bin Code" then begin
                                                    ItemRestrictions.SetRange("Item No.", WarehouseEntry."Item No.");
                                                    ItemRestrictions.SetRange("Variant Code", WarehouseEntry."Variant Code");
                                                    ItemRestrictions.SetRange("Lot No.", WarehouseEntry."Lot No.");
                                                    ItemRestrictions.SetRange("Location Code", WarehouseEntry."Location Code");
                                                    ItemRestrictions.SetRange(Open, true);
                                                    if ItemRestrictions.FindFirst() then Error(RestError2, WarehouseEntry."Item No.", WarehouseEntry."Lot No.", WarehouseEntry."Bin Code");
                                                end;
                                            end;
                            end;
                    end;
                WarehouseEntry."Entry Type"::"Negative Adjmt.":
                    case WarehouseEntry."Whse. Document Type" of
                        "Warehouse Journal Document Type"::Production:
                            begin
                                IF WarehouseEntry."Source Document" <> WarehouseEntry."Source Document"::"Output Jnl." then exit;
                                WhseItemRestriction.SetRange("Item No.", WarehouseEntry."Item No.");
                                WhseItemRestriction.SetRange(Type, WhseItemRestriction.Type::Production);
                                if WhseItemRestriction.FindFirst() then SetRestriction(WarehouseEntry."Item No.", WarehouseEntry."Variant Code", WarehouseEntry."Lot No.", WarehouseEntry."Location Code", WarehouseEntry."Bin Code", WarehouseEntry."Whse. Document No.", WarehouseEntry."Whse. Document Line No.", WarehouseEntry."Source No.", WarehouseEntry.Quantity, WarehouseEntry."Qty. (Base)", WarehouseEntry."Unit of Measure Code", WarehouseEntry."Qty. per Unit of Measure", '', WhseItemRestriction."Restriction Code", WhseItemRestriction."Restriction Status", True, NGuid, NGuid);
                            end;
                        "Warehouse Journal Document Type"::" ", "Warehouse Journal Document Type"::"Whse. Phys. Inventory":
                            begin
                                if Location.Get(WarehouseEntry."Location Code") then
                                    if Location."AQD QA. Zone" <> '' then
                                        if Bin.Get(WarehouseEntry."Location Code", WarehouseEntry."Bin Code") then
                                            if Bin."Zone Code" = Location."AQD QA. Zone" then begin
                                                WhseSetup.Get();
                                                WhseSetup.TestField("AQD Inv. Counts Restr. Code");
                                                WhseSetup.TestField("AQD Inv. Counts Restr. Status");
                                                ItemRestrictions.SetRange("Item No.", WarehouseEntry."Item No.");
                                                ItemRestrictions.SetRange("Variant Code", WarehouseEntry."Variant Code");
                                                ItemRestrictions.SetRange("Lot No.", WarehouseEntry."Lot No.");
                                                ItemRestrictions.SetRange("Location Code", WarehouseEntry."Location Code");
                                                ItemRestrictions.SetRange("QA. Bin Code", WarehouseEntry."Bin Code");
                                                ItemRestrictions.SetRange(Open, true);
                                                ItemRestrictions.SetRange("Unit of Measure Code", WarehouseEntry."Unit of Measure Code");
                                                ItemRestrictions.FindFirst();
                                                if ItemRestrictions.Count > 1 then Error(RestError, WarehouseEntry."Item No.", WarehouseEntry."Lot No.", WarehouseEntry."Bin Code");
                                                ItemRestrictions."Qty. to Handle" := -WarehouseEntry.Quantity;
                                                ReleaseRestriction(ItemRestrictions, WarehouseEntry."Source No.", WarehouseEntry."Source Line No.");
                                            end;
                            end;
                    end;
            end;
    end;

    procedure SetRestriction(ItemNo: Code[20]; VariantCode: Code[20]; LotNo: Code[50]; LocationCode: Code[20]; FromBin: Code[20]; DocNo: Code[20]; DocLineNo: Integer; SDocNo: Code[20]; Qty: Decimal; BQty: Decimal; UOM: Code[20]; QtyPUOM: Decimal; QABinCode: Code[20]; RestrictionCode: Code[20]; RestrictionStatus: Code[20]; Init: Boolean; ParentID: Guid; InitialRestrictionID: Guid)
    var
        ItemRestrictions: Record "AQD Item Restrictions";
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        WhseSetup: Record "Warehouse Setup";
        NoSeries: Codeunit "No. Series";
        Item: Record Item;
        LineNo: Integer;
        RLineNo: Integer;
    begin
        WhseSetup.Get();
        ItemRestrictions.SetRange("Item No.", ItemNo);
        ItemRestrictions.SetRange("Variant Code", VariantCode);
        ItemRestrictions.SetRange("Lot No.", LotNo);
        ItemRestrictions.SetRange("Restriction Code", RestrictionCode);
        ItemRestrictions.SetRange("Restriction Status", RestrictionStatus);
        ItemRestrictions.SetRange("QA. Bin Code", QABinCode);
        ItemRestrictions.SetRange("Location Code", LocationCode);
        ItemRestrictions.SetRange("Release Bin Code", FromBin);
        ItemRestrictions.SetRange("Unit of Measure Code", UOM);
        ItemRestrictions.SetRange("Initial Entry", Init);
        LineNo := 10000;
        if ItemRestrictions.FindFirst() then begin
            ItemRestrictions.CalcFields("Remaining Qty.");
            if ItemRestrictions."Remaining Qty." + Qty > ItemRestrictions.Quantity then begin
                ItemRestrictions.Quantity += Qty;
                ItemRestrictions."Qty. (Base)" += BQty;
                ItemRestrictions."Document No." := SDocNo;
            end;
            ItemRestrictions.Open := true;
            ItemRestrictions.Modify();
        end
        else begin
            ItemRestrictions.Init();
            ItemRestrictions."Initial Entry" := Init;
            ItemRestrictions."Restriction ID" := CreateGuid();
            ItemRestrictions."Item No." := ItemNo;
            ItemRestrictions."Variant Code" := VariantCode;
            ItemRestrictions."Lot No." := LotNo;
            ItemRestrictions."Restriction Code" := RestrictionCode;
            ItemRestrictions."Restriction Status" := RestrictionStatus;
            ItemRestrictions."Line No." := LineNo;
            ItemRestrictions."Location Code" := LocationCode;
            ItemRestrictions."Release Bin Code" := FromBin;
            ItemRestrictions."QA. Bin Code" := QABinCode;
            ItemRestrictions.Quantity := Qty;
            ItemRestrictions."Qty. (Base)" := BQty;
            ItemRestrictions."Qty. per Unit of Measure" := QtyPUOM;
            ItemRestrictions."Unit of Measure Code" := UOM;
            ItemRestrictions.Open := true;
            ItemRestrictions."Parent Restriction ID" := ParentID;
            ItemRestrictions."Document No." := SDocNo;
            if IsNullGuid(InitialRestrictionID) then
                ItemRestrictions."Initial Entry" := ItemRestrictions."Initial Entry"
            else
                ItemRestrictions."Initial Restriction ID" := InitialRestrictionID;
            ItemRestrictions.Insert();
        end;
        Item.Get(ItemRestrictions."Item No.");
        ItemRestrictionEntry.SetRange("Restriction ID", ItemRestrictions."Restriction ID");
        RLineNo := 1;
        if ItemRestrictionEntry.FindLast() then RLineNo := ItemRestrictionEntry."Entry No." + 1;
        ItemRestrictionEntry.Init();
        ItemRestrictionEntry."Restriction ID" := ItemRestrictions."Restriction ID";
        ItemRestrictionEntry."Initial Entry" := Init;
        ItemRestrictionEntry."Posting Date" := WorkDate();
        ItemRestrictionEntry."Item No." := ItemNo;
        ItemRestrictionEntry."Variant Code" := VariantCode;
        ItemRestrictionEntry."Lot No." := LotNo;
        ItemRestrictionEntry."Restriction Code" := RestrictionCode;
        ItemRestrictionEntry."Restriction Status" := RestrictionStatus;
        ItemRestrictionEntry."Restriction Line No." := ItemRestrictions."Line No.";
        ItemRestrictionEntry."Entry No." := RLineNo;
        ItemRestrictionEntry."Document No." := DocNo;
        ItemRestrictionEntry."Document Line No." := DocLineNo;
        ItemRestrictionEntry.Quantity := Qty;
        ItemRestrictionEntry."Remaining Qty." := Qty;
        ItemRestrictionEntry."Qty. (Base)" := BQty;
        ItemRestrictionEntry."Qty. per Unit of Measure" := QtyPUOM;
        ItemRestrictionEntry."Unit of Measure Code" := UOM;
        ItemRestrictionEntry."Unit Cost" := Item."Standard Cost";
        ItemRestrictionEntry.Amount := Item."Standard Cost" * Qty;
        ItemRestrictionEntry."Transaction DateTime" := CurrentDateTime;
        if IsNullGuid(InitialRestrictionID) then
            ItemRestrictionEntry."Initial Restriction ID" := ItemRestrictions."Restriction ID"
        else
            ItemRestrictionEntry."Initial Restriction ID" := InitialRestrictionID;
        ItemRestrictionEntry."Location Code" := ItemRestrictions."Location Code";
        ItemRestrictionEntry."QA. Bin Code" := ItemRestrictions."QA. Bin Code";
        ItemRestrictionEntry."Release Bin Code" := ItemRestrictions."Release Bin Code";
        ItemRestrictionEntry.Insert();
        SetQaBin(LocationCode);
        UpLotInfo(ItemNo, VariantCode, LotNo, true);
    end;

    procedure ReleaseRestriction(var ItemRestrictions: Record "AQD Item Restrictions"; DocNo: Code[20]; DocLineNo: Integer)
    var
        ItemRestrictionEntry: Record "AQD Item Restriction Entry";
        Item: Record Item;
        LotInfo: Record "Lot No. Information";
        RLineNo: Integer;
        RemQty: Decimal;
    begin
        ItemRestrictionEntry.SetRange("Restriction ID", ItemRestrictions."Restriction ID");
        RLineNo := 1;
        if ItemRestrictionEntry.FindLast() then RLineNo := ItemRestrictionEntry."Entry No." + 1;
        Item.Get(ItemRestrictions."Item No.");
        ItemRestrictionEntry.Init();
        ItemRestrictionEntry."Restriction ID" := ItemRestrictions."Restriction ID";
        ItemRestrictionEntry."Initial Entry" := ItemRestrictions."Initial Entry";
        ItemRestrictionEntry."Document No." := DocNo;
        ItemRestrictionEntry."Posting Date" := WorkDate();
        ItemRestrictionEntry."Document Line No." := DocLineNo;
        ItemRestrictionEntry."Item No." := ItemRestrictions."Item No.";
        ItemRestrictionEntry."Variant Code" := ItemRestrictions."Variant Code";
        ItemRestrictionEntry."Lot No." := ItemRestrictions."Lot No.";
        ItemRestrictionEntry."Restriction Code" := ItemRestrictions."Restriction Code";
        ItemRestrictionEntry."Restriction Status" := ItemRestrictions."Restriction Status";
        ItemRestrictionEntry."Restriction Line No." := ItemRestrictions."Line No.";
        ItemRestrictionEntry."Entry No." := RLineNo;
        ItemRestrictionEntry.Quantity := -ItemRestrictions."Qty. to Handle";
        ItemRestrictionEntry."Qty. (Base)" := -ItemRestrictions."Qty. to Handle" * ItemRestrictions."Qty. per Unit of Measure";
        ItemRestrictionEntry."Qty. per Unit of Measure" := ItemRestrictions."Qty. per Unit of Measure";
        ItemRestrictionEntry."Unit Cost" := Item."Standard Cost";
        ItemRestrictionEntry.Amount := Item."Standard Cost" * ItemRestrictions."Qty. to Handle";
        ItemRestrictionEntry."Unit of Measure Code" := ItemRestrictions."Unit of Measure Code";
        ItemRestrictionEntry."Transaction DateTime" := CurrentDateTime;
        ItemRestrictionEntry."Initial Restriction ID" := ItemRestrictions."Initial Restriction ID";
        ItemRestrictionEntry."Location Code" := ItemRestrictions."Location Code";
        ItemRestrictionEntry."QA. Bin Code" := ItemRestrictions."QA. Bin Code";
        ItemRestrictionEntry."Release Bin Code" := ItemRestrictions."Release Bin Code";
        ItemRestrictionEntry.Insert();
        if LotInfo.Get(ItemRestrictions."Item No.", ItemRestrictions."Variant Code", ItemRestrictions."Lot No.") then begin
            LotInfo."AQD Restriction Code" := ItemRestrictions."Restriction Code";
            LotInfo."AQD Restriction Status" := ItemRestrictions."Restriction Status";
            LotInfo.Modify();
        end;
        SetQaBin(ItemRestrictions."Location Code");
        RemQty := ItemRestrictions."Qty. to Handle";
        if not ItemRestrictions."Initial Entry" then begin
            ItemRestrictionEntry.SetRange("Restriction ID", ItemRestrictions."Restriction ID");
            if ItemRestrictionEntry.FindSet() then
                repeat
                    if ItemRestrictionEntry."Remaining Qty." >= RemQty then begin
                        ItemRestrictionEntry."Remaining Qty." -= RemQty;
                        ItemRestrictionEntry.Modify();
                        RemQty := 0;
                    end
                    else begin
                        RemQty -= ItemRestrictionEntry."Remaining Qty.";
                        ItemRestrictionEntry."Remaining Qty." := 0;
                        ItemRestrictionEntry.Modify();
                    end;
                until (ItemRestrictionEntry.Next() = 0) or (RemQty = 0);
        end;
        ItemRestrictions.CalcFields("Remaining Qty.");
        if ItemRestrictions."Remaining Qty." = 0 then ItemRestrictions.Open := false;
        ItemRestrictions."Qty. to Handle" := 0;
        ItemRestrictions.Modify();
    end;

    local procedure SetQaBin(LocationCode: Code[20])
    var
        Location: Record Location;
        Zone: Record Zone;
        Bin: Record Bin;
        BinContent: Record "Bin Content";
    begin
        if Location.Get(LocationCode) then
            if Zone.Get(Location.Code, Location."AQD QA. Zone") then begin
                Bin.SetRange("Location Code", Zone."Location Code");
                Bin.SetRange("Zone Code", Zone.Code);
                Bin.SetRange("AQD QA. Bin", not (Zone."AQD QA. Zone"));
                Bin.ModifyAll("AQD QA. Bin", Zone."AQD QA. Zone");
                BinContent.SetRange("Location Code", Zone."Location Code");
                BinContent.SetRange("Zone Code", Zone.Code);
                BinContent.SetRange("AQD QA. Bin", not (Zone."AQD QA. Zone"));
                BinContent.ModifyAll("AQD QA. Bin", Zone."AQD QA. Zone");
            end;
    end;

    local procedure NAddJnl(LocationCode: Code[20]; ItemNo: Code[20]; VariantCode: Code[20]; LotNo: Code[50]; FromBin: Code[20]; ToBin: Code[20]; Qty: Decimal; UOM: Code[20]; EntryType: Enum "Item Ledger Entry Type"; var DocNo: Code[20]; var LineNo: Integer)
    var
        WhseSetup: Record "Warehouse Setup";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
        ResEntry: Record "Reservation Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Template Name");
        WhseSetup.TestField("AQD QA. Batch Name");
        LineNo := 10000;
        ItemJnlLine.SetRange("Journal Template Name", WhseSetup."AQD QA. Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", WhseSetup."AQD QA. Batch Name");
        if ItemJnlLine.FindLast() then LineNo := ItemJnlLine."Line No." + 10000;
        ItemJnlTemplate.Get(WhseSetup."AQD QA. Template Name");
        ItemJnlBatch.Get(WhseSetup."AQD QA. Template Name", WhseSetup."AQD QA. Batch Name");
        ItemJnlLine.Init();
        ItemJnlLine."Journal Template Name" := WhseSetup."AQD QA. Template Name";
        ItemJnlLine."Journal Batch Name" := WhseSetup."AQD QA. Batch Name";
        ItemJnlLine."Line No." := LineNo;
        ItemJnlLine."Posting Date" := WorkDate();
        ItemJnlLine."Document Date" := WorkDate();
        ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
        ItemJnlLine."Reason Code" := ItemJnlBatch."Reason Code";
        ItemJnlLine."Posting No. Series" := ItemJnlBatch."Posting No. Series";
        ItemJnlLine."Entry Type" := EntryType;
        ItemJnlLine.Insert();
        if ItemJnlBatch."No. Series" <> '' then begin
            Clear(NoSeriesMgt);
            ItemJnlLine."Document No." := NoSeriesMgt.PeekNextNo(ItemJnlBatch."No. Series", ItemJnlLine."Posting Date");
            DocNo := ItemJnlLine."Document No.";
        end;
        ItemJnlLine.Validate("Item No.", ItemNo);
        if VariantCode <> '' then ItemJnlLine.Validate("Variant Code", VariantCode);
        ItemJnlLine.Validate("Location Code", LocationCode);
        ItemJnlLine."New Location Code" := LocationCode;
        ItemJnlLine.Validate("Unit of Measure Code", UOM);
        ItemJnlLine.Validate("Bin Code", FromBin);
        if EntryType = EntryType::Transfer then ItemJnlLine.Validate("New Bin Code", ToBin);
        ItemJnlLine.Validate(Quantity, Qty);
        ItemJnlLine.Modify(true);
        Clear(ResEntry);
        ResEntry.Init();
        ResEntry."Item No." := ItemNo;
        ResEntry."Location Code" := LocationCode;
        ResEntry."Reservation Status" := ResEntry."Reservation Status"::Prospect;
        ResEntry."Creation Date" := Today;
        ResEntry."Source Type" := 83;
        ResEntry."Source Subtype" := 4;
        ResEntry."Source ID" := WhseSetup."AQD QA. Template Name";
        ResEntry."Source Batch Name" := ItemJnlBatch.Name;
        ResEntry."Source Ref. No." := ItemJnlLine."Line No.";
        ResEntry.Quantity := -ItemJnlLine.Quantity;
        ResEntry."Quantity (Base)" := -ItemJnlLine."Quantity (Base)";
        ResEntry."Qty. per Unit of Measure" := ItemJnlLine."Qty. per Unit of Measure";
        ResEntry."Qty. to Handle (Base)" := -ItemJnlLine."Quantity (Base)";
        ResEntry."Qty. to Invoice (Base)" := -ItemJnlLine."Quantity (Base)";
        ResEntry."Item Tracking" := ResEntry."Item Tracking"::"Lot No.";
        ResEntry."Lot No." := LotNo;
        ResEntry."New Lot No." := LotNo;
        if FindLastItemLedgerEntry(ItemJnlLine."Item No.", ItemJnlLine."Variant Code", LotNo, ItemLedgEntry) then begin
            ResEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
            ResEntry."New Expiration Date" := ItemLedgEntry."Expiration Date";
        end;
        ResEntry."Planning Flexibility" := ResEntry."Planning Flexibility"::Unlimited;
        ResEntry.Insert(true);
    end;

    local procedure DPPDelJnl(LocationCode: Code[20])
    var
        WhseSetup: Record "Warehouse Setup";
        WhsJnlLine: Record "Warehouse Journal Line";
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Whse Template Name");
        WhseSetup.TestField("AQD QA. Warehouse Batch Name");
        WhsJnlLine.SetRange("Journal Template Name", WhseSetup."AQD QA. Whse Template Name");
        WhsJnlLine.SetRange("Journal Batch Name", WhseSetup."AQD QA. Warehouse Batch Name");
        WhsJnlLine.SetRange("Location Code", LocationCode);
        if WhsJnlLine.FindLast() then WhsJnlLine.DeleteAll();
    end;

    local procedure DPPAddJnl(LocationCode: Code[20]; ItemNo: Code[20]; VariantCode: Code[20]; LotNo: Code[50]; FromBin: Code[20]; ToBin: Code[20]; Qty: Decimal; QtyBase: Decimal; UOM: Code[20]; EntryType: Option "Negative Adjmt.","Positive Adjmt.",Movement; var DocNo: Code[20]; var LineNo: Integer)
    var
        WhseSetup: Record "Warehouse Setup";
        WhsJnlLine: Record "Warehouse Journal Line";
        WhsJnlTemplate: Record "Warehouse Journal Template";
        WhsJnlBatch: Record "Warehouse Journal Batch";
        ResEntry: Record "Reservation Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        WhseItemTrLine: Record "Whse. Item Tracking Line";
        Location: Record Location;
        Bin: Record Bin;
        BinContent: Record "Bin Content";
        NoSeriesMgt: Codeunit "No. Series";
        EntryNo: Integer;
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Whse Template Name");
        WhseSetup.TestField("AQD QA. Warehouse Batch Name");
        LineNo := 10000;
        WhsJnlLine.SetRange("Journal Template Name", WhseSetup."AQD QA. Whse Template Name");
        WhsJnlLine.SetRange("Journal Batch Name", WhseSetup."AQD QA. Warehouse Batch Name");
        WhsJnlLine.SetRange("Location Code", LocationCode);
        if WhsJnlLine.FindLast() then LineNo := WhsJnlLine."Line No." + 10000;
        WhsJnlTemplate.Get(WhseSetup."AQD QA. Whse Template Name");
        WhsJnlBatch.Get(WhseSetup."AQD QA. Whse Template Name", WhseSetup."AQD QA. Warehouse Batch Name", LocationCode);
        WhsJnlLine.Init();
        WhsJnlLine."Journal Template Name" := WhseSetup."AQD QA. Whse Template Name";
        WhsJnlLine."Journal Batch Name" := WhseSetup."AQD QA. Warehouse Batch Name";
        WhsJnlLine.Validate("Location Code", LocationCode);
        WhsJnlLine."Line No." := LineNo;
        WhsJnlLine."Registering Date" := WorkDate();
        WhsJnlLine."Source Code" := WhsJnlTemplate."Source Code";
        WhsJnlLine."Reason Code" := WhsJnlBatch."Reason Code";
        WhsJnlLine."Registering No. Series" := WhsJnlBatch."Registering No. Series";
        WhsJnlLine."Entry Type" := EntryType;
        WhsJnlLine.Insert();
        if WhsJnlBatch."No. Series" <> '' then begin
            Clear(NoSeriesMgt);
            WhsJnlLine."Whse. Document No." := NoSeriesMgt.PeekNextNo(WhsJnlBatch."No. Series", WhsJnlLine."Registering Date");
            DocNo := WhsJnlLine."Whse. Document No.";
        end;
        WhsJnlLine.Validate("Item No.", ItemNo);
        if VariantCode <> '' then WhsJnlLine.Validate("Variant Code", VariantCode);
        WhsJnlLine.Validate("Unit of Measure Code", UOM);
        if not BinContent.Get(LocationCode, FromBin, ItemNo, VariantCode, UOM) then begin
            InsertToBinContent(LocationCode, ItemNo, VariantCode, LotNo, FromBin, UOM, WhsJnlLine."Qty. per Unit of Measure");
        end;
        if EntryType = EntryType::Movement then begin
            WhsJnlLine.Validate("From Bin Code", FromBin);
            WhsJnlLine.Validate("To Bin Code", ToBin);
        end
        else begin
            Location.Get(LocationCode);
            WhsJnlLine.Validate("Bin Code", FromBin);
            Bin.Get(LocationCode, Location."Adjustment Bin Code");
            WhsJnlLine."To Bin Code" := Location."Adjustment Bin Code";
            WhsJnlLine."To Zone Code" := Bin."Zone Code";
            WhsJnlLine.Validate("From Bin Code", FromBin);
        end;
        WhsJnlLine.Validate(Quantity, Qty);
        if QtyBase <> 0 then begin
            WhsJnlLine."Qty. (Base)" := QtyBase;
            WhsJnlLine."Qty. (Absolute, Base)" := QtyBase;
        end;
        WhsJnlLine.Modify(true);
        Clear(WhseItemTrLine);
        if WhseItemTrLine.FindLast() then EntryNo := WhseItemTrLine."Entry No.";
        WhseItemTrLine.Init();
        WhseItemTrLine."Entry No." := EntryNo + 1;
        WhseItemTrLine."Item No." := ItemNo;
        WhseItemTrLine."Location Code" := LocationCode;
        WhseItemTrLine."Source Type" := 7311;
        WhseItemTrLine."Source Subtype" := 0;
        WhseItemTrLine."Source ID" := WhsJnlBatch.Name;
        WhseItemTrLine."Source Batch Name" := WhsJnlBatch."Journal Template Name";
        WhseItemTrLine."Source Ref. No." := WhsJnlLine."Line No.";
        WhseItemTrLine."Quantity (Base)" := WhsJnlLine."Qty. (Base)";
        WhseItemTrLine."Qty. per Unit of Measure" := WhsJnlLine."Qty. per Unit of Measure";
        WhseItemTrLine."Qty. to Handle (Base)" := WhsJnlLine."Qty. (Base)";
        WhseItemTrLine."Qty. to Handle" := WhsJnlLine.Quantity;
        WhseItemTrLine."Lot No." := LotNo;
        WhseItemTrLine."New Lot No." := LotNo;
        if FindLastItemLedgerEntry(WhsJnlLine."Item No.", WhsJnlLine."Variant Code", LotNo, ItemLedgEntry) then begin
            WhseItemTrLine."Expiration Date" := ItemLedgEntry."Expiration Date";
            WhseItemTrLine."New Expiration Date" := ItemLedgEntry."Expiration Date";
        end;
        WhseItemTrLine."Buffer Status2" := WhseItemTrLine."Buffer Status2"::"ExpDate blocked";
        WhseItemTrLine.Insert(true);
    end;

    local procedure NPost()
    var
        WhseSetup: Record "Warehouse Setup";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Batch Name");
        WhseSetup.TestField("AQD QA. Template Name");
        QASingleInstance.SetQARestriction(true);
        ItemJnlLine.SetRange("Journal Template Name", WhseSetup."AQD QA. Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", WhseSetup."AQD QA. Batch Name");
        if ItemJnlLine.FindFirst() then begin
            ItemJnlPostBatch.SetSuppressCommit(true);
            ItemJnlPostBatch.Run(ItemJnlLine);
        end;
        QASingleInstance.SetQARestriction(false);
    end;

    local procedure DPPPost()
    var
        WhseSetup: Record "Warehouse Setup";
        WhsJnlLine: Record "Warehouse Journal Line";
        WhseJnlRegisterBatch: Codeunit "Whse. Jnl.-Register Batch";
        QASingleInstance: Codeunit "AQD QA Single Instance";
    begin
        WhseSetup.Get;
        WhseSetup.TestField("AQD QA. Warehouse Batch Name");
        WhseSetup.TestField("AQD QA. Whse Template Name");
        QASingleInstance.SetQARestriction(true);
        WhsJnlLine.SetRange("Journal Template Name", WhseSetup."AQD QA. Whse Template Name");
        WhsJnlLine.SetRange("Journal Batch Name", WhseSetup."AQD QA. Warehouse Batch Name");
        if WhsJnlLine.FindFirst() then begin
            WhseJnlRegisterBatch.SetSuppressCommit(true);
            WhseJnlRegisterBatch.Run(WhsJnlLine);
        end;
        QASingleInstance.SetQARestriction(false);
    end;

    procedure FindLastItemLedgerEntry(ItemNo: Code[20]; VariantCode: Code[20]; LotNo: Code[50]; var ItemLedgEntry: Record "Item Ledger Entry"): Boolean
    var
        EntryFound: Boolean;
    begin
        if ItemLedgEntry.GetFilters() <> '' then ItemLedgEntry.Reset();
        ItemLedgEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Lot No.", "Serial No.");
        ItemLedgEntry.SetRange("Item No.", ItemNo);
        ItemLedgEntry.SetRange("Variant Code", VariantCode);
        if LotNo <> '' then ItemLedgEntry.SetRange("Lot No.", LotNo);
        ItemLedgEntry.SetRange(Positive, true);
        exit(ItemLedgEntry.FindLast());
    end;

    procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    var
        FindPos: Integer;
    begin
        FindPos := STRPOS(String, FindWhat);
        WHILE FindPos > 0 DO BEGIN
            NewString += DELSTR(String, FindPos) + ReplaceWith;
            String := COPYSTR(String, FindPos + STRLEN(FindWhat));
            FindPos := STRPOS(String, FindWhat);
        END;
        NewString += String;
    end;

    procedure InsertToBinContent(LocationCode: Code[20]; ItemNo: Code[20]; VariantCode: Code[20]; LotNo: Code[50]; BinCode: Code[20]; UOM: Code[20]; QtyPerUOM: Decimal)
    var
        BinContent: Record "Bin Content";
        WhseIntegrationMgt: Codeunit "Whse. Integration Management";
        Bin: Record Bin;
    begin
        Bin.Get(LocationCode, BinCode);
        BinContent.Init();
        BinContent."Location Code" := LocationCode;
        BinContent."Zone Code" := Bin."Zone Code";
        BinContent."Bin Code" := BinCode;
        BinContent.Dedicated := Bin.Dedicated;
        BinContent."Bin Type Code" := Bin."Bin Type Code";
        BinContent."Block Movement" := Bin."Block Movement";
        BinContent."Bin Ranking" := Bin."Bin Ranking";
        BinContent."Cross-Dock Bin" := Bin."Cross-Dock Bin";
        BinContent."Warehouse Class Code" := Bin."Warehouse Class Code";
        BinContent."Item No." := ItemNo;
        BinContent."Variant Code" := VariantCode;
        BinContent."Unit of Measure Code" := UOM;
        BinContent."Qty. per Unit of Measure" := QtyPerUOM;
        BinContent.Fixed := WhseIntegrationMgt.IsOpenShopFloorBin(LocationCode, BinCode);
        BinContent.Insert();
    end;

    procedure CreateQABin(LocationCode: Code[20]; BinCode: Code[20]): Code[20]
    var
        Bin: Record Bin;
        QABin: Record Bin;
        Zone: Record Zone;
        Location: Record Location;
    begin
        if Bin.Get(LocationCode, BinCode) then begin
            Location.Get(Bin."Location Code");
            if Location."AQD QA. Zone" <> '' then
                if Bin."Zone Code" <> Location."AQD QA. Zone" then begin
                    QABin.SetRange("Location Code", Bin."Location Code");
                    QABin.SetRange("Zone Code", Location."AQD QA. Zone");
                    QABin.SetRange(Code, Bin.Code + '-Q');
                    if not QABin.FindFirst() then begin
                        Zone.Get(LocationCode, Location."AQD QA. Zone");
                        QABin.Init();
                        QABin.TransferFields(Bin);
                        QABin.Code := Bin.Code + '-Q';
                        QABin."Zone Code" := Location."AQD QA. Zone";
                        QABin."Bin Type Code" := Zone."Bin Type Code";
                        QABin."AQD QA. Bin" := true;
                        QABin.Insert();
                        exit(QABin.Code);
                    end
                    else
                        exit(QABin.Code);
                end;
            exit(Bin.Code);
        end
        else
            exit('');
    end;

    procedure CheckBinQty(var ItemJnlLine: Record "Item Journal Line")
    var
        BinContent: Record "Bin Content";
        ResEntry: Record "Reservation Entry";
        WarehouseSetup: Record "Warehouse Setup";
        Location: Record Location;
    begin
        WarehouseSetup.Get();
        if WarehouseSetup."AQD Allow DPP. Transfer" then
            if ItemJnlLine.FindSet() then
                repeat
                    if ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Transfer then
                        if (ItemJnlLine."New Location Code" <> ItemJnlLine."Location Code") then begin
                            Location.Get(ItemJnlLine."Location Code");
                            if Location."Directed Put-away and Pick" then begin
                                ResEntry.SetRange("Item No.", ItemJnlLine."Item No.");
                                ResEntry.SetRange("Variant Code", ItemJnlLine."Variant Code");
                                ResEntry.SetRange("Location Code", ItemJnlLine."Location Code");
                                ResEntry.SetRange("Reservation Status", ResEntry."Reservation Status"::Prospect);
                                ResEntry.SetRange("Source Type", 83);
                                ResEntry.SetRange("Source Subtype", 4);
                                ResEntry.SetRange("Source ID", ItemJnlLine."Journal Template Name");
                                ResEntry.SetRange("Source Batch Name", ItemJnlLine."Journal Batch Name");
                                ResEntry.SetRange("Source Ref. No.", ItemJnlLine."Line No.");
                                if ResEntry.FindSet() then
                                    repeat
                                        BinContent.SetRange("Lot No. Filter", ResEntry."Lot No.");
                                        BinContent.Get(ItemJnlLine."Location Code", ItemJnlLine."Bin Code", ItemJnlLine."Item No.", ItemJnlLine."Variant Code", ItemJnlLine."Unit of Measure Code");
                                        BinContent.CalcFields("Quantity (Base)");
                                        if BinContent."Quantity (Base)" < -ResEntry."Quantity (Base)" then BinContent.TestField("Quantity (Base)", -ResEntry."Quantity (Base)");
                                    until ResEntry.Next() = 0;
                            end;
                        end;
                until ItemJnlLine.Next() = 0;
    end;

    procedure UpLotInfo(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; Block: Boolean)
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if LotNoInformation.Get(ItemNo, VariantCode, LotNo) then begin
            if Block then
                LotNoInformation.Validate(Blocked, true)
            else
                LotNoInformation.Blocked := false;
            LotNoInformation.Modify();
        end;
    end;

    procedure CreateBinContent(BinContent: Record "Bin Content")
    var
        NewBinContent: Record "Bin Content";
        Bin: Record Bin;
        Zone: Record Zone;
        Location: Record Location;
    begin
        Location.Get(BinContent."Location Code");
        if Location."AQD QA. Zone" = BinContent."Zone Code" then
            if not NewBinContent.Get(BinContent."Location Code", ReplaceString(BinContent."Bin Code", '-Q', ''), BinContent."Item No.", BinContent."Variant Code", BinContent."Unit of Measure Code") then begin
                Bin.Get(BinContent."Location Code", ReplaceString(BinContent."Bin Code", '-Q', ''));
                Zone.Get(BinContent."Location Code", Bin."Zone Code");
                NewBinContent.Init();
                NewBinContent.TransferFields(BinContent);
                NewBinContent."Bin Code" := ReplaceString(BinContent."Bin Code", '-Q', '');
                NewBinContent."Zone Code" := Bin."Zone Code";
                NewBinContent."Bin Type Code" := Zone."Bin Type Code";
                NewBinContent."AQD QA. Bin" := false;
                NewBinContent.Insert();
            end;
    end;

    var
        WhsEntryType: Option "Negative Adjmt.","Positive Adjmt.",Movement;
        EntryType: Enum "Item Ledger Entry Type";
        AcumensInventoryQCSetup: Record "AQD Acumens Inventory QC Setup";
}
