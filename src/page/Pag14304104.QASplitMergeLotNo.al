page 14304104 "QA Split - Merge Lot No."
{
    Caption = 'Split - Merge Lot No.';
    PageType = ConfirmationDialog;
    SourceTable = "Lot No. Information";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                grid(MyGrid)
                {
                    group(Group1)
                    {
                        ShowCaption = false;

                        field("Item No."; Rec."Item No.")
                        {
                            Editable = false;
                            ApplicationArea = All;
                        }
                        field("Variant Code"; Rec."Variant Code")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Item Description"; Item."Description")
                        {
                            ApplicationArea = All;
                        }
                        field(GTIN; Item.GTIN)
                        {
                            Editable = false;
                            ApplicationArea = All;
                        }
                    }
                    group(Group2)
                    {
                        ShowCaption = false;

                        field("Lot No."; Rec."Lot No.")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field(Inventory; Rec.Inventory)
                        {
                            ApplicationArea = All;
                        }
                        field("Qty. Restricted"; Rec."Qty. Restricted")
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                }
            }
            field(Merge; VSetMerge)
            {
                ApplicationArea = All;
                Enabled = MergeEnabled;

                trigger OnValidate()
                begin
                    if VSetMerge then
                        NewLot := Rec."Parent Lot No."
                    else if Rec."Last Split No." = '' then
                        NewLot := Rec."Lot No." + '.1'
                    else
                        NewLot := IncStr(Rec."Last Split No.");
                end;
            }
            field("New Lot No."; NewLot)
            {
                ApplicationArea = All;
            }
            field("Location Code"; LocationCode)
            {
                ApplicationArea = All;
                TableRelation = Location.Code where("Use As In-Transit" = const(false));
                ShowMandatory = true;
            }
            field("Bin Code"; BinCode)
            {
                ApplicationArea = All;
                ShowMandatory = true;

                trigger OnLookup(var Text: Text): Boolean
                var
                    BinContent: Record "Bin Content";
                begin
                    BinContent.SetRange("Location Code", LocationCode);
                    BinContent.SetRange("Item No.", Rec."Item No.");
                    BinContent.SetRange("Variant Code", Rec."Variant Code");
                    BinContent.SetRange("Lot No. Filter", Rec."Lot No.");
                    BinContent.SetFilter("Quantity (Base)", '<> 0');
                    IF PAGE.RUNMODAL(PAGE::"Bin Contents List", BinContent) = ACTION::LookupOK THEN BEGIN
                        Text := BinContent."Bin Code";
                        UOM := BinContent."Unit of Measure Code";
                        EXIT(TRUE);
                    END;
                    EXIT(FALSE);
                end;
            }
            field("Split Quantity"; SpQty)
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field("Unit of Measure Code"; UOM)
            {
                ApplicationArea = All;
                Editable = false;
                TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Item.Get(Rec."Item No.");
        MergeEnabled := Rec."Parent Lot No." <> '';
        VSetMerge := Rec."Parent Lot No." <> '';
        if VSetMerge then
            NewLot := Rec."Parent Lot No."
        else if Rec."Last Split No." = '' then
            NewLot := Rec."Lot No." + '.1'
        else
            NewLot := IncStr(Rec."Last Split No.");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Location: Record Location;
        Item: Record Item;
        QAManagement: Codeunit "QA Management";
        SPQtyError: Label 'Split quantity should be greater than zero.';
        LocationCodeError: Label 'Location Code should not be blank.';
        BinCodeError: Label 'Bin Code should not be blank.';
        DocNo: Code[20];
        LineNo: Integer;
    begin
        if CloseAction = CloseAction::Yes then begin
            if SpQty = 0 then Error(SPQtyError);
            if LocationCode = '' then error(LocationCodeError);
            if BinCode = '' then Error(BinCodeError);
            if Location.Get(LocationCode) then begin
                if Location."Directed Put-away and Pick" then
                    DPPSPLTLOT(DocNo, LineNo)
                else
                    SPLTLOT(DocNo, LineNo);
                Item.Get(Rec."Item No.");
                QAManagement.SplitLotActivity(LocationCode, Rec."Item No.", Rec."Variant Code", NewLot, Rec."Lot No.", BinCode, SpQty, UOM, DocNo, LineNo);
            end;
        end;
    end;

    local procedure DPPSPLTLOT(var DocNo: Code[20]; var LineNo: Integer)
    var
        Item: Record Item;
        NewLotNoInfo: Record "Lot No. Information";
        WhseSetup: Record "Warehouse Setup";
        WhsJnlLine: Record "Warehouse Journal Line";
        WhsJnlTemplate: Record "Warehouse Journal Template";
        WhsJnlBatch: Record "Warehouse Journal Batch";
        WhseItemTrLine: Record "Whse. Item Tracking Line";
        ResEntry: Record "Reservation Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        NoSeriesMgt: Codeunit "No. Series";
        WhseJnlRegisterBatch: Codeunit "Whse. Jnl.-Register Batch";
        QASingleInstance: Codeunit "QA Single Instance";
        _LineNo: Integer;
        EntryNo: Integer;
    begin
        if SpQty <> 0 then begin
            WhseSetup.Get;
            Item.Get(Rec."Item No.");
            WhseSetup.TestField("Split Lot Warehouse Batch Name");
            WhseSetup.TestField("Split Lot Whse Template Name");
            if not VSetMerge then
                if not NewLotNoInfo.Get(Rec."Item No.", Rec."Variant Code", NewLot) then begin
                    NewLotNoInfo.Init();
                    NewLotNoInfo.TransferFields(Rec);
                    NewLotNoInfo."Lot No." := NewLot;
                    NewLotNoInfo."Parent Lot No." := Rec."Lot No.";
                    NewLotNoInfo."Last Split No." := '';
                    NewLotNoInfo.Insert();
                end;
            WhsJnlTemplate.Get(WhseSetup."Split Lot Whse Template Name");
            ResEntry.SetRange(ResEntry."Source Type", 83);
            ResEntry.SetRange("Source Subtype", 4);
            ResEntry.SetRange("Source ID", WhseSetup."Split Lot Warehouse Batch Name");
            ResEntry.SetRange("Source Batch Name", WhseSetup."Split Lot Whse Template Name");
            ResEntry.DeleteAll();
            WhsJnlLine.SetRange("Journal Template Name", WhseSetup."Split Lot Whse Template Name");
            WhsJnlLine.SetRange("Journal Batch Name", WhseSetup."Split Lot Warehouse Batch Name");
            WhsJnlLine.DeleteAll(true);
            WhsJnlBatch.Get(WhseSetup."Split Lot Whse Template Name", WhseSetup."Split Lot Warehouse Batch Name", LocationCode);
            WhsJnlLine.Init();
            WhsJnlLine."Journal Template Name" := WhseSetup."Split Lot Whse Template Name";
            WhsJnlLine."Journal Batch Name" := WhseSetup."Split Lot Warehouse Batch Name";
            WhsJnlLine."Location Code" := LocationCode;
            WhsJnlLine."Line No." := 10000;
            WhsJnlLine."Registering Date" := WorkDate();
            WhsJnlLine."Source Code" := WhsJnlTemplate."Source Code";
            WhsJnlLine."Reason Code" := WhsJnlBatch."Reason Code";
            WhsJnlLine."Registering No. Series" := WhsJnlBatch."Registering No. Series";
            WhsJnlLine."Entry Type" := WhsJnlLine."Entry Type"::Movement;
            WhsJnlLine.Insert();
            if WhsJnlBatch."No. Series" <> '' then begin
                Clear(NoSeriesMgt);
                WhsJnlLine."Whse. Document No." := NoSeriesMgt.PeekNextNo(WhsJnlBatch."No. Series", WhsJnlLine."Registering Date");
            end;
            WhsJnlLine.Validate("Item No.", Rec."Item No.");
            if Rec."Variant Code" <> '' then WhsJnlLine.Validate("Variant Code", Rec."Variant Code");
            WhsJnlLine.Validate("From Bin Code", BinCode);
            WhsJnlLine.Validate("Bin Code", BinCode);
            WhsJnlLine.Validate("Unit of Measure Code", UOM);
            WhsJnlLine.Validate(Quantity, SpQty);
            WhsJnlLine.Modify(true);
            Clear(WhseItemTrLine);
            if WhseItemTrLine.FindLast() then EntryNo := WhseItemTrLine."Entry No.";
            WhseItemTrLine.Init();
            WhseItemTrLine."Entry No." := EntryNo + 1;
            WhseItemTrLine."Item No." := Rec."Item No.";
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
            WhseItemTrLine."Lot No." := Rec."Lot No.";
            WhseItemTrLine."New Lot No." := NewLot;
            if FindLastItemLedgerEntry(WhsJnlLine."Item No.", WhsJnlLine."Variant Code", Rec."Lot No.", ItemLedgEntry) then begin
                WhseItemTrLine."Expiration Date" := ItemLedgEntry."Expiration Date";
                WhseItemTrLine."New Expiration Date" := ItemLedgEntry."Expiration Date";
            end;
            WhseItemTrLine."Buffer Status2" := WhseItemTrLine."Buffer Status2"::"ExpDate blocked";
            WhseItemTrLine.Insert(true);
            DocNo := WhsJnlLine."Whse. Document No.";
            LineNo := WhsJnlLine."Line No.";
            WhsJnlLine.SetRange("Journal Template Name", WhsJnlLine."Journal Template Name");
            WhsJnlLine.SetRange("Journal Batch Name", WhsJnlLine."Journal Batch Name");
            WhseJnlRegisterBatch.SetSuppressCommit(true);
            QASingleInstance.SetQARestriction(true);
            QASingleInstance.SetReclass(true);
            WhseJnlRegisterBatch.Run(WhsJnlLine);
            QASingleInstance.SetQARestriction(false);
            QASingleInstance.SetReclass(false);
            if not VSetMerge then begin
                Rec."Last Split No." := NewLot;
                Rec.Modify();
            end
            else begin
                Rec.CalcFields(Inventory);
                if Rec.Inventory = 0 then begin
                    Rec.Delete(true);
                end;
            end;
        end;
    end;

    local procedure SPLTLOT(var DocNo: Code[20]; var LineNo: Integer)
    var
        Item: Record Item;
        NewLotNoInfo: Record "Lot No. Information";
        WhseSetup: Record "Warehouse Setup";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
        ResEntry: Record "Reservation Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        NoSeriesMgt: Codeunit "No. Series";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
        QASingleInstance: Codeunit "QA Single Instance";
        _LineNo: Integer;
    begin
        if SpQty <> 0 then begin
            WhseSetup.Get;
            Item.Get(Rec."Item No.");
            WhseSetup.TestField("Split Lot Batch Name");
            WhseSetup.TestField("Split Lot Template Name");
            if not VSetMerge then
                if not NewLotNoInfo.Get(Rec."Item No.", Rec."Variant Code", NewLot) then begin
                    NewLotNoInfo.Init();
                    NewLotNoInfo.TransferFields(Rec);
                    NewLotNoInfo."Lot No." := NewLot;
                    NewLotNoInfo."Parent Lot No." := Rec."Lot No.";
                    NewLotNoInfo."Last Split No." := '';
                    NewLotNoInfo.Insert();
                end;
            ResEntry.SetRange(ResEntry."Source Type", 83);
            ResEntry.SetRange("Source Subtype", 4);
            ResEntry.SetRange("Source ID", WhseSetup."Split Lot Template Name");
            ResEntry.SetRange("Source Batch Name", WhseSetup."Split Lot Batch Name");
            ResEntry.DeleteAll();
            ItemJnlLine.SetRange("Journal Template Name", WhseSetup."Split Lot Template Name");
            ItemJnlLine.SetRange("Journal Batch Name", WhseSetup."Split Lot Batch Name");
            ItemJnlLine.DeleteAll(true);
            ItemJnlTemplate.Get(WhseSetup."Split Lot Template Name");
            ItemJnlBatch.Get(WhseSetup."Split Lot Template Name", WhseSetup."Split Lot Batch Name");
            ItemJnlLine.Init();
            ItemJnlLine."Journal Template Name" := WhseSetup."Split Lot Template Name";
            ItemJnlLine."Journal Batch Name" := WhseSetup."Split Lot Batch Name";
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine."Posting Date" := WorkDate();
            ItemJnlLine."Document Date" := WorkDate();
            ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
            ItemJnlLine."Reason Code" := ItemJnlBatch."Reason Code";
            ItemJnlLine."Posting No. Series" := ItemJnlBatch."Posting No. Series";
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
            ItemJnlLine.Insert();
            if ItemJnlBatch."No. Series" <> '' then begin
                Clear(NoSeriesMgt);
                ItemJnlLine."Document No." := NoSeriesMgt.PeekNextNo(ItemJnlBatch."No. Series", ItemJnlLine."Posting Date");
            end;
            ItemJnlLine.Validate("Item No.", Rec."Item No.");
            if Rec."Variant Code" <> '' then ItemJnlLine.Validate("Variant Code", Rec."Variant Code");
            ItemJnlLine.Validate("Location Code", LocationCode);
            ItemJnlLine."New Location Code" := LocationCode;
            ItemJnlLine.Validate("Bin Code", BinCode);
            ItemJnlLine.Validate("New Bin Code", BinCode);
            ItemJnlLine.Validate("Unit of Measure Code", UOM);
            ItemJnlLine.Validate(Quantity, SpQty);
            ItemJnlLine.Modify(true);
            DocNo := ItemJnlLine."Document No.";
            LineNo := ItemJnlLine."Line No.";
            Clear(ResEntry);
            ResEntry.Init();
            ResEntry."Item No." := Rec."Item No.";
            ResEntry."Location Code" := LocationCode;
            ResEntry."Reservation Status" := ResEntry."Reservation Status"::Prospect;
            ResEntry."Creation Date" := Today;
            ResEntry."Source Type" := 83;
            ResEntry."Source Subtype" := 4;
            ResEntry."Source ID" := WhseSetup."Split Lot Template Name";
            ResEntry."Source Batch Name" := ItemJnlBatch.Name;
            ResEntry."Source Ref. No." := ItemJnlLine."Line No.";
            ResEntry.Quantity := -ItemJnlLine.Quantity;
            ResEntry."Quantity (Base)" := -ItemJnlLine."Quantity (Base)";
            ResEntry."Qty. per Unit of Measure" := ItemJnlLine."Qty. per Unit of Measure";
            ResEntry."Qty. to Handle (Base)" := -ItemJnlLine."Quantity (Base)";
            ResEntry."Qty. to Invoice (Base)" := -ItemJnlLine."Quantity (Base)";
            ResEntry."Item Tracking" := ResEntry."Item Tracking"::"Lot No.";
            ResEntry."Lot No." := Rec."Lot No.";
            ResEntry."New Lot No." := NewLot;
            if FindLastItemLedgerEntry(ItemJnlLine."Item No.", ItemJnlLine."Variant Code", Rec."Lot No.", ItemLedgEntry) then begin
                ResEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
                ResEntry."New Expiration Date" := ItemLedgEntry."Expiration Date";
            end;
            ResEntry."Planning Flexibility" := ResEntry."Planning Flexibility"::Unlimited;
            ResEntry.Insert(true);
            ItemJnlLine.SetRange("Journal Template Name", ItemJnlLine."Journal Template Name");
            ItemJnlLine.SetRange("Journal Batch Name", ItemJnlLine."Journal Batch Name");
            ItemJnlPostBatch.SetSuppressCommit(true or false);
            QASingleInstance.SetQARestriction(true);
            ItemJnlPostBatch.Run(ItemJnlLine);
            QASingleInstance.SetQARestriction(false);
            if not VSetMerge then begin
                Rec."Last Split No." := NewLot;
                Rec.Modify();
            end
            else begin
                Rec.CalcFields(Inventory);
                if Rec.Inventory = 0 then begin
                    Rec.Delete(true);
                end;
            end;
        end;
    end;

    procedure SetItemRestrictions(_ItemRestrictions: Record "Item Restrictions")
    begin
        BinCode := _ItemRestrictions."QA. Bin Code";
        LocationCode := _ItemRestrictions."Location Code";
        UOM := _ItemRestrictions."Unit of Measure Code";
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

    var
        Item: Record Item;
        NewLot: Code[50];
        SpQty: Decimal;
        UOM: Code[10];
        LPLineNo: Integer;
        LocationCode: Code[20];
        BinCode: Code[20];
        VSetMerge: Boolean;
        MergeEnabled: Boolean;
}
