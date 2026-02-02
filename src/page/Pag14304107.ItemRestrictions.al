page 14304107 "Item Restrictions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Item Restrictions";
    //DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Initial Entry"; Rec."Initial Entry")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        LotNo: Record "Lot No. Information";
                    begin
                        LotNo.SetRange("Item No.", Rec."Item No.");
                        LotNo.SetRange("Variant Code", Rec."Variant Code");
                        LotNo.SetRange("Lot No.", Rec."Lot No.");
                        Page.Run(Page::"Lot No. Information Card", LotNo);
                    end;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Restriction Status"; Rec."Restriction Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Restriction Code"; Rec."Restriction Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Release Bin Code"; Rec."Release Bin Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QA. Bin Code"; Rec."QA. Bin Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Days Restricted"; DaysRestricted)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Qty."; Rec."Remaining Qty.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty. QA. Warehouse Entry"; Rec."Qty. QA. Warehouse Entry")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty. to Handle"; Rec."Qty. to Handle")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        ErrLbl: Label 'Qty. to Handle must not be grater than Remaining Qty."';
                    begin
                        Rec.CalcFields("Remaining Qty.");
                        if Rec."Remaining Qty." < Rec."Qty. to Handle" then Error(ErrLbl);
                    end;
                }
            }
        }
        area(factboxes)
        {
            part("POAttached Documents2"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Production Order"), "No." = field("Document No."), "Document Type" = filter(DocumentType::"Credit Memo" | (DocumentType::"Blanket Order"));
                Enabled = VAttachPrO;
                Visible = VAttachPrO;
            }
            part("PROAttached Documents2"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Purchase Header"), "No." = field("Document No."), "Document Type" = const(Order);
                Enabled = VAttachPo;
                Visible = VAttachPo;
            }
            systempart(Links; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action("Bin Content")
            {
                ApplicationArea = All;
                Caption = 'Bin Content';
                Ellipsis = true;
                Image = BinContent;

                trigger OnAction()
                var
                    BinContent: Record "Bin Content";
                begin
                    BinContent.SetRange("Location Code", Rec."Location Code");
                    BinContent.SetRange("Item No.", Rec."Item No.");
                    BinContent.SetRange("Variant Code", Rec."Variant Code");
                    BinContent.SetRange("Bin Code", Rec."QA. Bin Code");
                    BinContent.SetRange("Lot No. Filter", Rec."Lot No.");
                    Page.Run(Page::"Bin Content", BinContent);
                end;
            }
            action("ParentRestriction")
            {
                ApplicationArea = All;
                Caption = '&Parent Restriction';
                Ellipsis = true;
                Image = Order;
                Enabled = not (NGuid);
                RunObject = page "Item Restrictions";
                RunPageLink = "Restriction ID" = field("Parent Restriction ID");
            }
            action("SourceDocument")
            {
                ApplicationArea = All;
                Caption = '&Source Document';
                Ellipsis = true;
                Image = SourceDocLine;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    ProductionOrder: Record "Production Order";
                begin
                    if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, Rec."Document No.") then begin
                        PurchaseHeader.SetRecFilter();
                        Page.Run(0, PurchaseHeader);
                    end
                    else begin
                        ProductionOrder.SetRange("No.", Rec."Document No.");
                        Page.Run(0, ProductionOrder);
                    end;
                end;
            }
            action("ItemTracing")
            {
                ApplicationArea = All;
                Caption = '&Item Tracing';
                Ellipsis = true;
                Image = ItemTracing;

                trigger OnAction()
                var
                    ItemTrackingEntry: Record "Item Tracing Buffer";
                    ItemTracing: Page "Item Tracing";
                begin
                    ItemTrackingEntry.SetRange("Item No.", Rec."Item No.");
                    ItemTrackingEntry.SetRange("Variant Code", Rec."Variant Code");
                    ItemTrackingEntry.SetRange("Lot No.", Rec."Lot No.");
                    ItemTracing.InitFilters(ItemTrackingEntry);
                    ItemTracing.RunModal();
                end;
            }
            action("Entries")
            {
                ApplicationArea = All;
                Caption = '&Entries';
                Ellipsis = true;
                Image = Entries;
                RunObject = page "Item Restriction Entries";
                RunPageLink = "Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.");
            }
            action(Navigate)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Find entries...';
                Image = Navigate;
                ShortCutKey = 'Ctrl+Alt+Q';
                ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';

                trigger OnAction()
                var
                    ItemTrackingSetup: Record "Item Tracking Setup";
                    Navigate: Page Navigate;
                begin
                    ItemTrackingSetup."Lot No." := Rec."Lot No.";
                    Navigate.SetTracking(ItemTrackingSetup);
                    Navigate.Run();
                end;
            }
        }
        area(Processing)
        {
            action("ReleaseItem")
            {
                ApplicationArea = All;
                Caption = '&Release Item';
                Ellipsis = true;
                Image = ReleaseDoc;
                Enabled = AllowReleasItem;
                Visible = AllowReleasItem;

                trigger OnAction()
                var
                    ItemRestrictions: Record "Item Restrictions";
                    WhseSetup: Record "Warehouse Setup";
                    QAManagment: Codeunit "QA Management";
                    ConLbl: Label 'Are you sure you want to Release items';
                    IniConLbl: Label 'You are releasing the initial entry for this restriction. Proceeding will release all Qty.';
                begin
                    WhseSetup.TestField("Allow Partial Release", true);
                    if Confirm(ConLbl, true) then begin
                        CurrPage.SetSelectionFilter(ItemRestrictions);
                        ItemRestrictions.SetRange(Open, true);
                        if ItemRestrictions.FindSet() then
                            repeat
                                Clear(QAManagment);
                                if (ItemRestrictions."Qty. to Handle" <> 0) or (ItemRestrictions."Initial Entry" = true) then
                                    if ItemRestrictions."Initial Entry" then begin
                                        if Confirm(IniConLbl, false) then QAManagment.RegisterRelease(ItemRestrictions);
                                    end
                                    else
                                        QAManagment.RegisterRelease(ItemRestrictions);
                            until ItemRestrictions.Next() = 0;
                        Message('Done');
                    end;
                    CurrPage.Update(false);
                end;
            }
            action("ReleaseLot")
            {
                ApplicationArea = All;
                Caption = '&Release Lot';
                Ellipsis = true;
                Image = ReleaseDoc;
                Enabled = AllowReleasLot;
                Visible = AllowReleasLot;

                trigger OnAction()
                var
                    ItemRestrictions: Record "Item Restrictions";
                    ItemRestrictions2: Record "Item Restrictions";
                    WhseSetup: Record "Warehouse Setup";
                    QAManagment: Codeunit "QA Management";
                    RestStatusCode: Text[50];
                    ProcessAction: Boolean;
                    MultyConLbl: Label 'This lot is in multiple bins. Do you want to release all restrictions for the Lot No. %1 from Location %2? ';
                    ConLbl: Label 'Are you sure you want to Release the Lot No. %1?';
                    IniConLbl: Label 'You are releasing the initial entry for this Lot No. %1. Proceeding will release all Qty.';
                    ErrorLot: Label 'This Lot No. %1 has multiple restriction Statuses/Codes. You must either perform a Lot Split or condense the lot into a matching Status/Code.';
                begin
                    CurrPage.SetSelectionFilter(ItemRestrictions2);
                    ItemRestrictions2.SetRange(Open, true);
                    WhseSetup.TestField("Allow Partial Release", false);
                    if ItemRestrictions2.FindSet() then
                        repeat
                            ItemRestrictions.SetRange("Item No.", ItemRestrictions2."Item No.");
                            ItemRestrictions.SetRange("Lot No.", ItemRestrictions2."Lot No.");
                            ItemRestrictions.SetRange("Location Code", ItemRestrictions2."Location Code");
                            ItemRestrictions.SetRange(Open, true);
                            if ItemRestrictions.FindSet() then
                                repeat
                                    if RestStatusCode <> '' then if RestStatusCode <> ItemRestrictions."Restriction Status" + ItemRestrictions."Restriction Code" then Error(ErrorLot, ItemRestrictions."Lot No.");
                                    RestStatusCode := ItemRestrictions."Restriction Status" + ItemRestrictions."Restriction Code";
                                until ItemRestrictions.Next() = 0;
                        until ItemRestrictions2.Next() = 0;
                    if ItemRestrictions2.FindSet() then
                        repeat
                            ItemRestrictions.SetRange("Item No.", ItemRestrictions2."Item No.");
                            ItemRestrictions.SetRange("Lot No.", ItemRestrictions2."Lot No.");
                            ItemRestrictions.SetRange("Location Code", ItemRestrictions2."Location Code");
                            ItemRestrictions.SetRange(Open, true);
                            if ItemRestrictions.FindSet() then begin
                                ProcessAction := false;
                                if ItemRestrictions.Count > 1 then begin
                                    if Confirm(MultyConLbl, true, ItemRestrictions."Lot No.", ItemRestrictions."Location Code") then ProcessAction := true;
                                end
                                else if Confirm(ConLbl, true, ItemRestrictions."Lot No.") then ProcessAction := true;
                                if ProcessAction then begin
                                    ItemRestrictions.FindSet();
                                    repeat
                                        Clear(QAManagment);
                                        if ItemRestrictions."Initial Entry" then begin
                                            if Confirm(IniConLbl, false, ItemRestrictions."Lot No.") then QAManagment.RegisterRelease(ItemRestrictions);
                                        end
                                        else begin
                                            ItemRestrictions.CalcFields("Remaining Qty.");
                                            ItemRestrictions."Qty. to Handle" := ItemRestrictions."Remaining Qty.";
                                            ItemRestrictions.Modify();
                                            QAManagment.RegisterRelease(ItemRestrictions);
                                        end;
                                        Commit();
                                    until ItemRestrictions.Next() = 0;
                                end;
                            end;
                        until ItemRestrictions2.Next() = 0;
                    Message('Done');
                    CurrPage.Update(false);
                end;
            }
            action("ScrapItem")
            {
                ApplicationArea = All;
                Caption = '&Scrap Item';
                Ellipsis = true;
                Image = NegativeLines;
                Enabled = not (Rec."Initial Entry") and AllowScrap;

                trigger OnAction()
                var
                    ItemRestrictions: Record "Item Restrictions";
                    QAManagment: Codeunit "QA Management";
                    QASingleInstance: Codeunit "QA Single Instance";
                    ConLbl: Label 'Are you sure you want to Scrap items';
                begin
                    if Confirm(ConLbl, true) then begin
                        ClearLastError();
                        CurrPage.SetSelectionFilter(ItemRestrictions);
                        ItemRestrictions.SetRange(Open, true);
                        if ItemRestrictions.FindSet() then
                            repeat
                                Clear(QAManagment);
                                if (ItemRestrictions."Qty. to Handle" <> 0) or (ItemRestrictions."Initial Entry" = true) then begin
                                    QASingleInstance.SetReclass(true);
                                    QASingleInstance.SetQABin(true);
                                    if not QAManagment.RegisterScrap(ItemRestrictions) then begin
                                        Error(GetLastErrorText());
                                    end;
                                    QASingleInstance.SetQABin(false);
                                    QASingleInstance.SetReclass(false);
                                end;
                            until ItemRestrictions.Next() = 0;
                        Message('Done');
                        CurrPage.Update(false);
                    end;
                end;
            }
            action("AutofillQtytoHandle")
            {
                ApplicationArea = All;
                Caption = 'Autofill Qty. to Handle';
                Ellipsis = true;
                Image = AutofillQtyToHandle;
                Enabled = AllowReleasItem or AllowScrap;

                trigger OnAction()
                var
                    ItemRestrictions: Record "Item Restrictions";
                    QAManagment: Codeunit "QA Management";
                begin
                    CurrPage.SetSelectionFilter(ItemRestrictions);
                    ItemRestrictions.SetRange(Open, true);
                    ItemRestrictions.SetRange("Initial Entry", false);
                    if ItemRestrictions.FindSet() then
                        repeat
                            ItemRestrictions.CalcFields("Remaining Qty.");
                            ItemRestrictions."Qty. to Handle" := ItemRestrictions."Remaining Qty.";
                            ItemRestrictions.Modify();
                        until ItemRestrictions.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
            action("ReclassItem")
            {
                ApplicationArea = All;
                Caption = 'R&eclass Item';
                Ellipsis = true;
                Enabled = not (Rec."Initial Entry") and AllowReclass;
                Image = Recalculate;
                RunObject = page "Reclass Item Restrictions";
                RunPageLink = "Restriction ID" = field("Restriction ID");
            }
            action("Split")
            {
                ApplicationArea = All;
                Caption = 'Split Merge Lot';
                Ellipsis = true;
                Image = Split;
                Enabled = AllowSplit;

                trigger OnAction()
                var
                    LotNoInfo: Record "Lot No. Information";
                    MSLotNo: Page "QA Split - Merge Lot No.";
                begin
                    LotNoInfo.SetRange("Item No.", Rec."Item No.");
                    LotNoInfo.SetRange("Variant Code", Rec."Variant Code");
                    LotNoInfo.SetRange("Lot No.", Rec."Lot No.");
                    MSLotNo.SetItemRestrictions(Rec);
                    MSLotNo.SetTableView(LotNoInfo);
                    MSLotNo.Run();
                    CurrPage.Update(false);
                end;
            }
            action("UpdateFromQABins")
            {
                ApplicationArea = All;
                Caption = 'Update From QA. Bins';
                Ellipsis = true;
                Image = UpdateShipment;
                Enabled = AllowUpdateFromQABins;
                Visible = AllowUpdateFromQABins;

                trigger OnAction()
                var
                    Location: Record Location;
                    WarehouseEntry: Record "Warehouse Entry";
                    ItemRestrictions: Record "Item Restrictions";
                    TempItemRestrictions: Record "Item Restrictions" temporary;
                    WarehouseSetup: Record "Warehouse Setup";
                    QAManagment: Codeunit "QA Management";
                    RemQty: Decimal;
                    EmptGuid: Guid;
                begin
                    TempItemRestrictions.DeleteAll();
                    WarehouseSetup.Get();
                    WarehouseSetup.TestField("Inv. Counts Restriction Code");
                    WarehouseSetup.TestField("Inv. Counts Restriction Status");
                    Location.SetFilter("QA. Zone", '<>%1', '');
                    if Location.FindSet() then
                        repeat
                            WarehouseEntry.SetRange("Location Code", Location.Code);
                            WarehouseEntry.SetRange("Zone Code", Location."QA. Zone");
                            if WarehouseEntry.FindSet() then
                                repeat
                                    Clear(TempItemRestrictions);
                                    TempItemRestrictions.SetRange("Item No.", WarehouseEntry."Item No.");
                                    TempItemRestrictions.SetRange("Variant Code", WarehouseEntry."Variant Code");
                                    TempItemRestrictions.SetRange("Lot No.", WarehouseEntry."Lot No.");
                                    TempItemRestrictions.SetRange("QA. Bin Code", WarehouseEntry."Bin Code");
                                    TempItemRestrictions.SetRange("Location Code", WarehouseEntry."Location Code");
                                    TempItemRestrictions.SetRange("Unit of Measure Code", WarehouseEntry."Unit of Measure Code");
                                    if TempItemRestrictions.Find() then begin
                                        TempItemRestrictions.Quantity += WarehouseEntry.Quantity;
                                        TempItemRestrictions."Qty. (Base)" += WarehouseEntry."Qty. (Base)";
                                        TempItemRestrictions.Modify();
                                    end
                                    else begin
                                        TempItemRestrictions.Init();
                                        TempItemRestrictions."Initial Entry" := false;
                                        TempItemRestrictions."Restriction ID" := CreateGuid();
                                        TempItemRestrictions."Item No." := WarehouseEntry."Item No.";
                                        TempItemRestrictions."Variant Code" := WarehouseEntry."Variant Code";
                                        TempItemRestrictions."Lot No." := WarehouseEntry."Lot No.";
                                        TempItemRestrictions."Restriction Code" := WarehouseSetup."Inv. Counts Restriction Code";
                                        TempItemRestrictions."Restriction Status" := WarehouseSetup."Inv. Counts Restriction Status";
                                        TempItemRestrictions."Line No." := WarehouseEntry."Whse. Document Line No.";
                                        TempItemRestrictions."Location Code" := WarehouseEntry."Location Code";
                                        TempItemRestrictions."Release Bin Code" := QAManagment.ReplaceString(WarehouseEntry."Bin Code", '-Q', '');
                                        TempItemRestrictions."QA. Bin Code" := WarehouseEntry."Bin Code";
                                        TempItemRestrictions.Quantity := WarehouseEntry.Quantity;
                                        TempItemRestrictions."Qty. (Base)" := WarehouseEntry."Qty. (Base)";
                                        TempItemRestrictions."Qty. per Unit of Measure" := WarehouseEntry."Qty. per Unit of Measure";
                                        TempItemRestrictions."Unit of Measure Code" := WarehouseEntry."Unit of Measure Code";
                                        TempItemRestrictions.Open := true;
                                        TempItemRestrictions."Document No." := WarehouseEntry."Whse. Document No.";
                                        TempItemRestrictions.Insert();
                                    end;
                                until WarehouseEntry.Next() = 0;
                        until Location.Next() = 0;
                    Clear(TempItemRestrictions);
                    TempItemRestrictions.SetRange(Quantity, 0);
                    TempItemRestrictions.DeleteAll();
                    TempItemRestrictions.Reset();
                    if TempItemRestrictions.FindSet() then
                        repeat
                            RemQty := 0;
                            ItemRestrictions.SetRange("Item No.", TempItemRestrictions."Item No.");
                            ItemRestrictions.SetRange("Variant Code", TempItemRestrictions."Variant Code");
                            ItemRestrictions.SetRange("Lot No.", TempItemRestrictions."Lot No.");
                            ItemRestrictions.SetRange("Location Code", TempItemRestrictions."Location Code");
                            ItemRestrictions.SetRange("QA. Bin Code", TempItemRestrictions."QA. Bin Code");
                            ItemRestrictions.SetRange("Release Bin Code", TempItemRestrictions."Release Bin Code");
                            ItemRestrictions.SetRange("Unit of Measure Code", TempItemRestrictions."Unit of Measure Code");
                            ItemRestrictions.SetRange(Open, true);
                            ItemRestrictions.SetRange("Initial Entry", false);
                            if ItemRestrictions.FindFirst() then
                                repeat
                                    ItemRestrictions.CalcFields("Remaining Qty.");
                                    ItemRestrictions.Mark(true);
                                    RemQty += ItemRestrictions."Remaining Qty.";
                                until ItemRestrictions.Next() = 0;
                            if RemQty < TempItemRestrictions.Quantity then begin
                                QAManagment.SetRestriction(TempItemRestrictions."Item No.", TempItemRestrictions."Variant Code", TempItemRestrictions."Lot No.", TempItemRestrictions."Location Code", TempItemRestrictions."Release Bin Code", TempItemRestrictions."Document No.", TempItemRestrictions."Line No.", TempItemRestrictions."Document No.", TempItemRestrictions.Quantity - RemQty, (TempItemRestrictions.Quantity - RemQty) * TempItemRestrictions."Qty. per Unit of Measure", TempItemRestrictions."Unit of Measure Code", TempItemRestrictions."Qty. per Unit of Measure", TempItemRestrictions."QA. Bin Code", WarehouseSetup."Inv. Counts Restriction Code", WarehouseSetup."Inv. Counts Restriction Status", false, EmptGuid, EmptGuid)
                            end
                            else if RemQty > TempItemRestrictions.Quantity then begin
                                RemQty := RemQty - TempItemRestrictions.Quantity;
                                if ItemRestrictions.FindFirst() then
                                    repeat
                                        ItemRestrictions.CalcFields("Remaining Qty.");
                                        if RemQty > ItemRestrictions."Remaining Qty." then begin
                                            ItemRestrictions."Qty. to Handle" := ItemRestrictions."Remaining Qty.";
                                            RemQty := ItemRestrictions."Remaining Qty." - RemQty;
                                            QAManagment.ReleaseRestriction(ItemRestrictions, '', 0);
                                        end
                                        else begin
                                            RemQty := 0;
                                            ItemRestrictions."Qty. to Handle" := RemQty;
                                            QAManagment.ReleaseRestriction(ItemRestrictions, '', 0);
                                        end;
                                    until (ItemRestrictions.Next() = 0) or (RemQty = 0);
                            end;
                        until TempItemRestrictions.Next() = 0;
                    CurrPage.Update(false);
                    Message('Done');
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(AutofillQtytoHandle_Process_Promoted; AutofillQtytoHandle)
                {
                }
                actionref(Split_Process_Promoted; Split)
                {
                }
                actionref(ReclassItem_Process_Promoted; ReclassItem)
                {
                }
                actionref(ScrapItem_Process_Promoted; ScrapItem)
                {
                }
                actionref(ReleaseItem_Process_Promoted; ReleaseItem)
                {
                }
                actionref(ReleaseLot_Process_Promoted; ReleaseLot)
                {
                }
                actionref(UpdateFromQABins_Process_Promoted; UpdateFromQABins)
                {
                }
            }
            group(Category_Navigate)
            {
                Caption = 'Navigate';

                actionref(Navigate_Promoted; Navigate)
                {
                }
                actionref(Entries_Promoted; Entries)
                {
                }
                actionref(Bin_Content_Promoted; "Bin Content")
                {
                }
                actionref(ItemTracing_Promoted; ItemTracing)
                {
                }
                actionref(SourceDocument_Promoted; SourceDocument)
                {
                }
                actionref(ParentRestriction_Promoted; ParentRestriction)
                {
                }
            }
        }
    }
    trigger OnClosePage()
    var
        QASingleInstance: Codeunit "QA Single Instance";
    begin
        QASingleInstance.SetReclass(false);
    end;

    trigger OnOpenPage()
    var
        RestrictionUserSetup: Record "Restriction User Setup";
        WhseSetup: Record "Warehouse Setup";
    begin
        WhseSetup.Get();
        RestrictionUserSetup.Get(UserId);
        if WhseSetup."Allow Partial Release" then
            AllowReleasItem := RestrictionUserSetup."Allow Release"
        else
            AllowReleasLot := RestrictionUserSetup."Allow Release";
        AllowReclass := RestrictionUserSetup."Allow Reclass";
        AllowSplit := RestrictionUserSetup."Allow Split - Merge Lot No.";
        AllowUpdateFromQABins := RestrictionUserSetup."Allow Update From QA. Bins";
        Rec.FilterGroup(2);
        if RestrictionUserSetup."Restriction Code Filter" <> '' then Rec.SetFilter("Restriction Code", RestrictionUserSetup."Restriction Code Filter");
        if RestrictionUserSetup."Restriction Status Filter" <> '' then Rec.SetFilter("Restriction Status", RestrictionUserSetup."Restriction Status Filter");
        Rec.FilterGroup(0);
    end;

    trigger OnAfterGetCurrRecord()
    var
        PurchHeader: Record "Purchase Header";
        ProdOrder: Record "Production Order";
        RestrictionUserSetup: Record "Restriction User Setup";
    begin
        VAttachPO := false;
        VAttachPro := false;
        RestrictionUserSetup.Get(UserId);
        Rec.CalcFields("Enable Scrap");
        AllowScrap := RestrictionUserSetup."Allow Scrap" and Rec."Enable Scrap";
        NGuid := IsNullGuid(Rec."Parent Restriction ID");
        if PurchHeader.Get(PurchHeader."Document Type"::Order, Rec."Document No.") then
            VAttachPO := true
        else if ProdOrder.Get(ProdOrder.Status::Released, Rec."Document No.") then VAttachPrO := true;
    end;

    trigger OnAfterGetRecord()
    begin
        DaysRestricted := 0;
        if Rec.Open then begin
            Rec.CalcFields("Last Transaction Date");
            if Rec."Last Transaction Date" <> 0DT then DaysRestricted := Today - DT2Date(Rec."Last Transaction Date");
        end;
    end;

    var
        AllowScrap: Boolean;
        AllowReleasItem: Boolean;
        AllowReleasLot: Boolean;
        AllowReclass: Boolean;
        AllowSplit: Boolean;
        AllowUpdateFromQABins: Boolean;
        NGuid: Boolean;
        DocumentType: Enum "Attachment Document Type";
        VAttachPO: Boolean;
        VAttachPro: Boolean;
        DaysRestricted: Decimal;
}
