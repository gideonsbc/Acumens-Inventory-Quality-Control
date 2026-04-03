// SBC. 2026-02-06. 
// It is not advisable to delete journal templates after initializing because it may have been used for postings. 
// Therefore, journal templates deletion section was disabled for ready production.
page 14304114 "AQD Acumens Inventory QC Setup"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = Card;
    SourceTable = "AQD Acumens Inventory QC Setup";
    Caption = 'Acumens Defective Inventory Management Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Enabled; Rec."AQD Enabled")
                {
                    ApplicationArea = All;
                    Caption = 'Enabled App';
                    ToolTip = 'Specifies the value of the Enabled field.';
                }
            }
            group("Acumens Quality Control Features")
            {
                Caption = 'Features';
                field("AQD Allow DPP. Transfer"; Rec."AQD Allow DPP. Transfer")
                {
                    ApplicationArea = All;
                    Caption = 'Allow DPP. Transfer';
                    ToolTip = 'Specifies the value of the Allow DPP. Transfer field.';
                }
                field("AQD Allow Partial Release"; Rec."AQD Allow Partial Release")
                {
                    ApplicationArea = All;
                    Caption = 'Allow Partial Release';
                    ToolTip = 'Specifies the value of the Allow Partial Release field.';
                }
                field("AQD Create Rest. for Expired Lot"; Rec."AQD CreateRest. forExpired Lot")
                {
                    ApplicationArea = All;
                    Caption = 'Create Restrictions for Expired Lot.';
                    ToolTip = 'Specifies the value of the Create Restrictions for Expired Lot. field.';
                }
            }
            group("Acumens Restrictionl Setups")
            {
                Caption = 'Restriction Setups';
                field("AQD Inv. Counts Restriction Status"; Rec."AQD Inv. Counts Restr. Status")
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Counts Restriction Status';
                    ToolTip = 'Specifies the value of the Inventory Counts Restriction Status field.';
                }
                field("AQD Inv. Counts Restriction Code"; Rec."AQD Inv. Counts Restr. Code")
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Counts Restriction Code';
                    ToolTip = 'Specifies the value of the Inventory Counts Restriction Code field.';
                }
                field("AQD Expired Lot Restriction Status"; Rec."AQD Expired Lot Restr. Status")
                {
                    ApplicationArea = All;
                    Caption = 'Expired Lot Restriction Status';
                    ToolTip = 'Specifies the value of the Expired Lot Restriction Status field.';
                }
                field("AQD Expired Lot Restriction Code"; Rec."AQD Expired Lot Restr. Code")
                {
                    ApplicationArea = All;
                    Caption = 'Expired Lot Restriction Code';
                    ToolTip = 'Specifies the value of the Expired Lot Restriction Code field.';
                }
            }
            group("AQD Number Series Setups")
            {
                Caption = 'Journal Templates';
                field("AQD Split Lot Template Name"; Rec."AQD Split Lot Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'Split Lot Template Name';
                    ToolTip = 'Specifies the value of the Split Lot Template Name field.';
                }
                field("AQD Split Lot Batch Name"; Rec."AQD Split Lot Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'Split Lot Batch Name';
                    ToolTip = 'Specifies the value of the Split Lot Batch Name field.';
                }
                field("AQD Split Lot Whse Template Name"; Rec."AQD Split Lot Whse Temp. Name")
                {
                    ApplicationArea = All;
                    Caption = 'Split Lot Warehouse Template Name';
                    ToolTip = 'Specifies the value of the Split Lot Warehouse Template Name field.';
                }
                field("AQD Split Lot Warehouse Batch Name"; Rec."AQD Split Lot Whse Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'Split Lot Warehouse Batch Name';
                    ToolTip = 'Specifies the value of the Split Lot Warehouse Batch Name field.';
                }
                field("AQD QA. Template Name"; Rec."AQD QA. Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'DIM Template Name';
                    ToolTip = 'Specifies the value of the Defective Inventory Management Template Name field.';
                }
                field("AQD QA. Batch No."; Rec."AQD QA. Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'DIM Batch Name';
                    ToolTip = 'Specifies the value of the Defective Inventory Management Batch Name field.';
                }
                field("AQD QA. Warehouse Template Name"; Rec."AQD QA. Whse Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'DIM Warehouse Template Name';
                    ToolTip = 'Specifies the value of the Defective Inventory Management Warehouse Template Name field.';
                }
                field("AQD QA. Warehouse Batch No."; Rec."AQD QA. Warehouse Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'DIM Warehouse Batch Name';
                    ToolTip = 'Specifies the value of the Defective Inventory Management Warehouse Batch Name field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Delete Acumens Quality Control Management Setups")
            {
                Image = CancelAllLines;
                ApplicationArea = All;
                ToolTip = 'Executes the Delete Acumens Defective Inventory Management Default Setups action.';
                Caption = 'Delete Acumens Defective Inventory Management Setups';
                trigger OnAction();
                begin
                    DeleteAllSetups();
                end;
            }
        }
        area(Creation)
        {
            action("Restriction User Setup")
            {
                Image = UserSetup;
                RunObject = page "AQD Restriction User Setup";
                ApplicationArea = All;
                ToolTip = 'Executes the Restriction User Setup action.';
                Caption = 'Restriction User Setup';
            }
            action("Warehouse Setup")
            {
                Image = WarehouseSetup;
                RunObject = page "Warehouse Setup";
                ApplicationArea = All;
                ToolTip = 'Executes the Warehouse Setup action.';
                Caption = 'Warehouse Setup';
            }
            action("AQD WarehouseRestrictionStatus")
            {
                Image = Status;
                RunObject = page "AQD WarehouseRestrictionStatus";
                ApplicationArea = All;
                ToolTip = 'Executes the Warehouse Restriction Status action.';
                Caption = 'Warehouse Restriction Status';
            }
            action("AQD Warehouse Restrictions")
            {
                Image = RegisterPick;
                RunObject = page "AQD Warehouse Restrictions";
                ApplicationArea = All;
                ToolTip = 'Executes the Warehouse Restrictions action.';
                Caption = 'Warehouse Restrictions';
            }
            action("Location Setup")
            {
                Image = Delivery;
                RunObject = page "Location List";
                ApplicationArea = All;
                ToolTip = 'Executes the Locations action.';
                Caption = 'Locations';
            }
            action("Whse. Journal Templates")
            {
                Image = Template;
                RunObject = page "Whse. Journal Templates";
                ApplicationArea = All;
                ToolTip = 'Executes the Whse. Journal Templates action.';
                Caption = 'Whse. Journal Templates';
            }
            action("Item Journal Templates")
            {
                Image = Journals;
                RunObject = page "Item Journal Templates";
                ApplicationArea = All;
                ToolTip = 'Executes the Item Journal Templates action.';
                Caption = 'Item Journal Templates';
            }
            action(ResetNoSeriesAction)
            {
                Caption = 'Reset Number Series';
                Image = ResetStatus;
                ToolTip = 'Resets All AIQC Warehouse Number series on the setup';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ResetNoSeries();
                end;
            }
        }
        area(Navigation)
        {
            action("About the App")
            {
                Image = AboutNav;
                RunObject = page "AQD AboutAcumensQualityCMgt";
                ApplicationArea = All;
                ToolTip = 'Executes the About Acumens Defective Inventory Management page.';
                Caption = 'About the App';
            }
        }
        area(Reporting)
        {
            action("AQD Block Expired Lots")
            {
                Image = Lot;
                RunObject = report "AQD Block Expired Lots";
                ApplicationArea = All;
                ToolTip = 'Executes the Block Expired Lots report.';
                Caption = 'Block Expired Lots';
            }
            action("AQD Update Lot Restriction")
            {
                Image = UpdateDescription;
                RunObject = report "AQD Update Lot Restriction";
                ApplicationArea = All;
                ToolTip = 'Executes the Update Lot Restriction report.';
                Caption = 'Update Lot Restriction';
            }
        }
        area(Promoted)
        {
            group(Category_Category20)
            {
                Caption = 'Home', Comment = 'Generated from the PromotedActionCategories property index 1.';
                actionref("Delete Acumens Quality Control Management Setups_Promoted"; "Delete Acumens Quality Control Management Setups") { }
                actionref("AQD Restriction User Setup_Promoted"; "Restriction User Setup") { }
                actionref("Warehouse Setup_Promoted"; "Warehouse Setup") { }
                actionref("AQD WarehouseRestrictionStatus_Promoted"; "AQD WarehouseRestrictionStatus") { }
                actionref("AQD Warehouse Restrictions_Promoted"; "AQD Warehouse Restrictions") { }
                actionref("Location Setup_Promoted"; "Location Setup") { }
                actionref("ResetNoSeriesAction_Promoted"; ResetNoSeriesAction) { }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';
                actionref("AQD Block Expired Lots_Promoted"; "AQD Block Expired Lots") { }
                actionref("AQD Update Lot Restriction_Promoted"; "AQD Update Lot Restriction") { }
            }
            group(Category_Category4)
            {
                Caption = 'Journal Templates', Comment = 'Generated from the PromotedActionCategories property index 3.';
                actionref("Whse. Journal Templates_Promoted"; "Whse. Journal Templates") { }
                actionref("Item Journal Templates_Promoted"; "Item Journal Templates") { }
            }
            group(Category_New)
            {
                Caption = 'About', Comment = 'Generated from the PromotedActionCategories property index 4.';
                actionref(AbouttheApp; "About the App") { }
            }
        }
    }

    trigger OnOpenPage();
    begin
        //AERAccessMgt.AccessManager('AQCM01', true, false);
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);

            InitDefaultSetup();
        end;
    end;

    var
        Text001: Label 'Do you want to automatically Initialize default Acumens Defective Inventory Management Setups?';
        Text002: Label 'Default Setups Initialized Successfully!';
        Text003: Label 'Deleting Setup Card will delete all Acumens Defective Inventory Management specific Setups. Proceed?';
        AcumensInventoryQCSetup: Record "AQD Acumens Inventory QC Setup";
        AERAccessMgt: Codeunit "AQD Inventory QC Access Mgt.";
        RestrictionUserSetup: Record "AQD Restriction User Setup";
        Location: Record Location;
        AQDWarehouseRestrictionStatus: Record "AQD WarehouseRestrictionStatus";
        AQDWarehouseRestriction: Record "AQD Warehouse Restriction";

    local procedure InitDefaultSetup();
    begin
        if Confirm(Text001) then begin

            InitializeRestrictionUserSetup();

            CreateCoManLocation();

            CreateWarehouseJournalSetup();

            InitializeWarehouseRestriction();

            GenerateNoSeries();

            AssignWarehouseSetup();

            Rec."AQD Enabled" := true;
            Rec."AQD Log To History" := true;
            Rec."AQD Setup Initialized By" := UserId;
            Rec."AQD Split Lot Template Name" := 'SPLITLOT';
            Rec."AQD Split Lot Batch Name" := 'SPLBATCH';
            Rec."AQD Split Lot Whse Temp. Name" := 'SPLWHSEJNR';
            Rec."AQD Split Lot Whse Batch Name" := 'SPLWHSEBAT';
            Rec."AQD QA. Template Name" := 'DIMJOURNAL';
            Rec."AQD QA. Batch Name" := 'DIMBATCH';
            Rec."AQD QA. Whse Template Name" := 'DIMWHSEJNR';
            Rec."AQD QA. Warehouse Batch Name" := 'DIMWHSEBAT';
            Rec."AQD Allow DPP. Transfer" := false;
            Rec."AQD Allow Partial Release" := false;
            Rec."AQD Inv. Counts Restr. Status" := 'COUNTING';
            Rec."AQD Inv. Counts Restr. Code" := 'INVCOUNT';
            Rec."AQD CreateRest. forExpired Lot" := false;
            Rec."AQD Expired Lot Restr. Status" := 'EXPIRED';
            Rec."AQD Expired Lot Restr. Code" := 'EXPLOT';
            Rec.Modify();
        end;
        Message(Text002);
    end;

    local procedure InitializeRestrictionUserSetup();
    var
        User: Record User;
    begin
        AcumensInventoryQCSetup.Get();
        User.Reset();
        User.SetFilter("License Type", '%1|%2', User."License Type"::"Full User", User."License Type"::"Limited User");
        if User.FindSet() then begin
            repeat
                RestrictionUserSetup.Reset();
                RestrictionUserSetup.SetRange("User ID", User."User Name");

                if not RestrictionUserSetup.FindFirst() then begin
                    RestrictionUserSetup.Init();
                    RestrictionUserSetup."User ID" := User."User Name";
                    RestrictionUserSetup.Admin := false; // Update to true if necessary
                    RestrictionUserSetup."Allow Reclass" := false; // Update to true if necessary 
                    RestrictionUserSetup."Allow Release" := false; // Update to true if necessary
                    RestrictionUserSetup."Allow Scrap" := false; // Update to true if necessary
                    RestrictionUserSetup."Allow Set Restriction" := false; // Update to true if necessary
                    RestrictionUserSetup."Allow Split - Merge Lot No." := false; // Update to true if necessary
                    RestrictionUserSetup."Allow Update From QA. Bins" := false; // Update to true if necessary
                    RestrictionUserSetup.Insert();
                end;
            until User.Next() = 0;
        end;
    end;

    local procedure CreateCoManLocation()
    begin
        if not Location.Get('COMAN') then begin
            Location.Init();
            Location.Code := 'COMAN';
            Location.Name := 'C0-Manufacturing Warehouse';
            Location.Insert();
        end;
    end;

    local procedure CreateWarehouseJournalSetup()
    var
        WhseJnlTemplate: Record "Warehouse Journal Template";
        WhseJnlBatch: Record "Warehouse Journal Batch";
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
    begin
        // === SPLIT LOT JOURNAL ===
        if not ItemJournalTemplate.Get('SPLITLOT') then begin
            ItemJournalTemplate.Init();
            ItemJournalTemplate.Name := 'SPLITLOT';
            ItemJournalTemplate.Description := 'Split Lot Template Journal';
            ItemJournalTemplate.Type := ItemJournalTemplate.Type::Item;
            ItemJournalTemplate."Source Code" := 'ITEMJNL';
            ItemJournalTemplate.Insert();
        end;

        if not ItemJournalBatch.Get('SPLITLOT', 'SPLBATCH') then begin
            ItemJournalBatch.Init();
            ItemJournalBatch."Journal Template Name" := 'SPLITLOT';
            ItemJournalBatch.Name := 'SPLBATCH';
            ItemJournalBatch.Description := 'Split Lot Template Batch';
            ItemJournalBatch.Insert();
        end;

        // === QSPLIT LOT WAREHOUSE JOURNAL ===
        if not WhseJnlTemplate.Get('SPLWHSEJNR') then begin
            WhseJnlTemplate.Init();
            WhseJnlTemplate.Name := 'SPLWHSEJNR';
            WhseJnlTemplate.Description := 'Split Lot Warehouse Journal';
            WhseJnlTemplate.Type := WhseJnlTemplate.Type::Item;
            WhseJnlBatch."Location Code" := 'COMAN';
            WhseJnlTemplate.Insert();
        end;

        //if not WhseJnlBatch.Get('SPLWHSEJNR', 'SPLWHSEBAT', 'COMAN') then begin
        WhseJnlBatch.Reset();
        WhseJnlBatch.SetRange("Journal Template Name", 'SPLWHSEJNR');
        WhseJnlBatch.SetRange(Name, 'SPLWHSEBAT');
        if not WhseJnlBatch.FindFirst() then begin
            WhseJnlBatch.Init();
            WhseJnlBatch."Journal Template Name" := 'SPLWHSEJNR';
            WhseJnlBatch.Name := 'SPLWHSEBAT';
            WhseJnlBatch.Description := 'Split Lot Warehouse Batch';
            WhseJnlBatch."Location Code" := 'COMAN';
            WhseJnlBatch.Insert();
        end;

        // === QA JOURNAL ===
        if not ItemJournalTemplate.Get('DIMJOURNAL') then begin
            ItemJournalTemplate.Init();
            ItemJournalTemplate.Name := 'DIMJOURNAL';
            ItemJournalTemplate.Description := 'Defective Inventory Management Journal';
            ItemJournalTemplate.Type := ItemJournalTemplate.Type::Item;
            ItemJournalTemplate."Source Code" := 'ITEMJNL';
            ItemJournalTemplate.Insert();
        end;

        if not ItemJournalBatch.Get('DIMJOURNAL', 'DIMBATCH') then begin
            ItemJournalBatch.Init();
            ItemJournalBatch."Journal Template Name" := 'DIMJOURNAL';
            ItemJournalBatch.Name := 'DIMBATCH';
            ItemJournalBatch.Description := 'Defective Inventory Management Batch';
            ItemJournalBatch.Insert();
        end;

        // === QA WAREHOUSE JOURNAL ===
        if not WhseJnlTemplate.Get('DIMWHSEJNR') then begin
            WhseJnlTemplate.Init();
            WhseJnlTemplate.Name := 'DIMWHSEJNR';
            WhseJnlTemplate.Description := 'Defective Inventory Management Warehouse Journal';
            WhseJnlTemplate.Type := WhseJnlTemplate.Type::Item;
            WhseJnlTemplate.Insert();
        end;

        //if not WhseJnlBatch.Get('DIMWHSEJNR', 'DIMWHSEBAT', 'COMAN') then begin
        WhseJnlBatch.Reset();
        WhseJnlBatch.SetRange("Journal Template Name", 'DIMWHSEJNR');
        WhseJnlBatch.SetRange(Name, 'DIMWHSEBAT');
        if not WhseJnlBatch.FindFirst() then begin
            WhseJnlBatch.Init();
            WhseJnlBatch."Journal Template Name" := 'DIMWHSEJNR';
            WhseJnlBatch.Name := 'DIMWHSEBAT';
            WhseJnlBatch.Description := 'Defective Inventory Management Warehouse Batch';
            WhseJnlBatch."Location Code" := 'COMAN';
            WhseJnlBatch.Insert();
        end;
    end;

    local procedure InitializeWarehouseRestriction()
    begin
        if not AQDWarehouseRestrictionStatus.Get('COUNTING') then begin
            AQDWarehouseRestrictionStatus.Init();
            AQDWarehouseRestrictionStatus.Code := 'COUNTING';
            AQDWarehouseRestrictionStatus.Description := 'Item is under inventory count';
            AQDWarehouseRestrictionStatus."Enable Scrap" := true;
            AQDWarehouseRestrictionStatus.Insert();
        end;
        if not AQDWarehouseRestrictionStatus.Get('AVAILABLE') then begin
            AQDWarehouseRestrictionStatus.Init();
            AQDWarehouseRestrictionStatus.Code := 'AVAILABLE';
            AQDWarehouseRestrictionStatus.Description := 'Normal operations allowed';
            AQDWarehouseRestrictionStatus."Enable Scrap" := true;
            AQDWarehouseRestrictionStatus.Insert();
        end;
        if not AQDWarehouseRestrictionStatus.Get('EXPIRED') then begin
            AQDWarehouseRestrictionStatus.Init();
            AQDWarehouseRestrictionStatus.Code := 'EXPIRED';
            AQDWarehouseRestrictionStatus.Description := 'Lot is expired or blocked';
            AQDWarehouseRestrictionStatus."Enable Scrap" := true;
            AQDWarehouseRestrictionStatus.Insert();
        end;

        if not AQDWarehouseRestriction.Get('INVCOUNT') then begin
            AQDWarehouseRestriction.Init();
            AQDWarehouseRestriction.Code := 'INVCOUNT';
            AQDWarehouseRestriction.Description := 'Inventory Count Lock';
            AQDWarehouseRestriction.Status := 'COUNTING';
            AQDWarehouseRestriction.Insert();
        end;
        if not AQDWarehouseRestriction.Get('PHYLOCK') then begin
            AQDWarehouseRestriction.Init();
            AQDWarehouseRestriction.Code := 'PHYLOCK';
            AQDWarehouseRestriction.Description := 'Physical Count Restriction';
            AQDWarehouseRestriction.Status := 'AVAILABLE';
            AQDWarehouseRestriction.Insert();
        end;
        if not AQDWarehouseRestriction.Get('EXPLOT') then begin
            AQDWarehouseRestriction.Init();
            AQDWarehouseRestriction.Code := 'EXPLOT';
            AQDWarehouseRestriction.Description := 'Expired Lot Restriction';
            AQDWarehouseRestriction.Status := 'EXPIRED';
            AQDWarehouseRestriction.Insert();
        end;
    end;

    local procedure GenerateNoSeries()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMS-RCPT') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMS-RCPT';
            NoSeries.Description := 'Defective Inventory Management Warehouse Receipt Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMS-RCPT';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-RE00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMS-RCPT+') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMS-RCPT+';
            NoSeries.Description := 'Defective Inventory Management Posted Warehouse Receipt Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMS-RCPT+';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-PR00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMS-SHIP') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMS-SHIP';
            NoSeries.Description := 'Defective Inventory Management Warehouse Shipment Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMS-SHIP';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-SH00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMS-SHIP+') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMS-SHIP+';
            NoSeries.Description := 'Defective Inventory Management Posted Warehouse Shipment Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMS-SHIP+';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-PS00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMS-PUT-') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMS-PUT-';
            NoSeries.Description := 'Defective Inventory Management Warehouse Internal Put-away Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMS-PUT-';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-IPU0001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMS-PUT-+') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMS-PUT-+';
            NoSeries.Description := 'Defective Inventory Management Registered Warehouse Put-away Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMS-PUT-+';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-RPU0001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSI-PICK') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSI-PICK';
            NoSeries.Description := 'Defective Inventory Management Warehouse Internal Pick Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSI-PICK';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-IP00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSI-PICK+') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSI-PICK+';
            NoSeries.Description := 'Defective Inventory Management Registered Warehouse Pick Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSI-PICK+';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-RP00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMS-PUT') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMS-PUT';
            NoSeries.Description := 'Defective Inventory Management Warehouse Put-away Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMS-PUT';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-PU00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMS-MOVE') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMS-MOVE';
            NoSeries.Description := 'Defective Inventory Management Warehouse Movement Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMS-MOVE';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-WM00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMS-PICK') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMS-PICK';
            NoSeries.Description := 'Defective Inventory Management Warehouse Pick Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMS-PICK';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-PI00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMS-MOVE+') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMS-MOVE+';
            NoSeries.Description := 'Defective Inventory Management Registered Whse. Movement Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMS-MOVE+';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIM-WM00001';
            if NoSeriesLine.Insert() then;
        end;
    end;

    local procedure AssignWarehouseSetup()
    var
        WarehouseSetup: Record "Warehouse Setup";
    begin
        if not WarehouseSetup.Get() then
            exit;

        WarehouseSetup.Validate("AQD Split Lot Template Name", 'SPLITLOT');
        WarehouseSetup.Validate("AQD Split Lot Batch Name", 'SPLBATCH');
        WarehouseSetup.Validate("AQD Split Lot Whse Temp. Name", 'SPLWHSEJNR');
        WarehouseSetup.Validate("AQD Split Lot Whse Batch Name", 'SPLWHSEBAT');

        WarehouseSetup.Validate("AQD QA. Template Name", 'DIMJOURNAL');
        WarehouseSetup.Validate("AQD QA. Batch Name", 'DIMBATCH');
        WarehouseSetup.Validate("AQD QA. Whse Template Name", 'DIMWHSEJNR');
        WarehouseSetup.Validate("AQD QA. Warehouse Batch Name", 'DIMWHSEBAT');

        WarehouseSetup.Validate("AQD Inv. Counts Restr. Status", 'COUNTING');
        WarehouseSetup.Validate("AQD Inv. Counts Restr. Code", 'INVCOUNT');
        WarehouseSetup.Validate("AQD Expired Lot Restr. Status", 'EXPIRED');
        WarehouseSetup.Validate("AQD Expired Lot Restr. Code", 'EXPLOT');

        if WarehouseSetup."Whse. Receipt Nos." = '' then
            WarehouseSetup."Whse. Receipt Nos." := 'DIM-WMS-RCPT';

        if WarehouseSetup."Posted Whse. Receipt Nos." = '' then
            WarehouseSetup."Posted Whse. Receipt Nos." := 'DIM-WMS-RCPT+';

        if WarehouseSetup."Whse. Ship Nos." = '' then
            WarehouseSetup."Whse. Ship Nos." := 'DIM-WMS-SHIP';

        if WarehouseSetup."Posted Whse. Shipment Nos." = '' then
            WarehouseSetup."Posted Whse. Shipment Nos." := 'DIM-WMS-SHIP+';

        if WarehouseSetup."Whse. Internal Put-away Nos." = '' then
            WarehouseSetup."Whse. Internal Put-away Nos." := 'DIM-WMS-PUT-';

        if WarehouseSetup."Registered Whse. Put-away Nos." = '' then
            WarehouseSetup."Registered Whse. Put-away Nos." := 'DIM-WMS-PUT-+';

        if WarehouseSetup."Whse. Internal Pick Nos." = '' then
            WarehouseSetup."Whse. Internal Pick Nos." := 'DIM-WMSI-PICK';

        if WarehouseSetup."Registered Whse. Pick Nos." = '' then
            WarehouseSetup."Registered Whse. Pick Nos." := 'DIM-WMSI-PICK+';

        if WarehouseSetup."Whse. Put-away Nos." = '' then
            WarehouseSetup."Whse. Put-away Nos." := 'DIM-WMS-PUT';

        if WarehouseSetup."Whse. Movement Nos." = '' then
            WarehouseSetup."Whse. Movement Nos." := 'DIM-WMS-MOVE';

        if WarehouseSetup."Whse. Pick Nos." = '' then
            WarehouseSetup."Whse. Pick Nos." := 'DIM-WMS-PICK';

        if WarehouseSetup."Whse. Movement Nos." = '' then
            WarehouseSetup."Whse. Movement Nos." := 'DIM-WMS-MOVE+';

        WarehouseSetup.Modify(true);
    end;

    local procedure DeleteAllSetups();
    begin
        if not Confirm(Text003, false) then
            exit;

        //Delete Acumens Restriction User Setups
        RestrictionUserSetup.Reset();
        RestrictionUserSetup.DeleteAll();

        //Delete Created COMAN Location
        if not LocationHasPostings('COMAN') then begin
            Location.Reset();
            Location.SetRange(Code, 'COMAN');
            Location.DeleteAll();
        end;

        //Delete Warehouse Setup generated data
        ClearWarehouseSetup();

        //Delete Warehouse Restriction Setups
        AQDWarehouseRestrictionStatus.Reset();
        AQDWarehouseRestrictionStatus.SetFilter(Code, 'COUNTING|AVAILABLE|EXPIRED');
        AQDWarehouseRestrictionStatus.DeleteAll(true);

        AQDWarehouseRestriction.Reset();
        AQDWarehouseRestriction.SetFilter(Code, 'INVCOUNT|PHYLOCK|EXPLOT');
        AQDWarehouseRestriction.DeleteAll(true);

        //<<<SBC. 2026-02-06. Delete Warehouse Journal Templates
        // it is not advisable to delete journal templates because it may have been used for postings. Therefore, this section is disabled for ready production.
        // ItemJournalTemplate.Reset();
        // ItemJournalTemplate.SetFilter(Name, 'SPLITLOT|DIMJOURNAL');
        // ItemJournalTemplate.DeleteAll(true);

        // ItemJournalBatch.Reset();
        // ItemJournalBatch.SetFilter("Journal Template Name", 'SPLITLOT|DIMJOURNAL');
        // ItemJournalBatch.SetFilter(Name, 'SPLBATCH|DIMBATCH');
        // ItemJournalBatch.DeleteAll(true);

        // WarehouseJournalTemplate.Reset();
        // WarehouseJournalTemplate.SetFilter(Name, 'SPLWHSEJNR|DIMWHSEJNR');
        // WarehouseJournalTemplate.DeleteAll(true);

        // WarehouseJournalBatch.Reset();
        // WarehouseJournalBatch.SetFilter("Journal Template Name", 'SPLWHSEJNR|DIMWHSEJNR');
        // WarehouseJournalBatch.SetFilter(Name, 'SPLWHSEBAT|DIMWHSEBAT');
        // WarehouseJournalBatch.DeleteAll(true);
        //>>>SBC. 2026-02-06.

        //OnAfterDeleteAllSetups();

        Rec.DeleteAll();
        CurrPage.Close();
    end;

    procedure ClearWarehouseSetup()
    var
        WarehouseSetupRec: Record "Warehouse Setup";
    begin
        if not WarehouseSetupRec.Get() then
            exit;

        // Clear Split Lot Setup Fields
        Clear(WarehouseSetupRec."AQD Split Lot Template Name");
        Clear(WarehouseSetupRec."AQD Split Lot Batch Name");
        Clear(WarehouseSetupRec."AQD Split Lot Whse Temp. Name");
        Clear(WarehouseSetupRec."AQD Split Lot Whse Batch Name");

        // Clear QA Setup Fields
        Clear(WarehouseSetupRec."AQD QA. Template Name");
        Clear(WarehouseSetupRec."AQD QA. Batch Name");
        Clear(WarehouseSetupRec."AQD QA. Whse Template Name");
        Clear(WarehouseSetupRec."AQD QA. Warehouse Batch Name");

        // Clear Restriction Status/Code Fields
        Clear(WarehouseSetupRec."AQD Inv. Counts Restr. Status");
        Clear(WarehouseSetupRec."AQD Inv. Counts Restr. Code");
        Clear(WarehouseSetupRec."AQD Expired Lot Restr. Status");
        Clear(WarehouseSetupRec."AQD Expired Lot Restr. Code");

        // Clear Warehouse Setup assigned Number series
        Clear(WarehouseSetupRec."Whse. Internal Put-away Nos.");
        Clear(WarehouseSetupRec."Whse. Internal Pick Nos.");

        WarehouseSetupRec.Modify(true);
    end;

    procedure LocationHasPostings(LocationCode: Code[10]): Boolean
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        WhseEntry: Record "Warehouse Entry";
    begin
        // Item Ledger Entries
        ItemLedgerEntry.SetRange("Location Code", LocationCode);
        if ItemLedgerEntry.FindFirst() then
            exit(true);

        // Value Entries
        ValueEntry.SetRange("Location Code", LocationCode);
        if ValueEntry.FindFirst() then
            exit(true);

        // Warehouse Entries
        WhseEntry.SetRange("Location Code", LocationCode);
        if WhseEntry.FindFirst() then
            exit(true);

        exit(false);
    end;

    local procedure ResetNoSeries()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        WarehouseSetup: Record "Warehouse Setup";
    begin
        if not Confirm('This will reset all Acumens Defective Inventory Management number series setups. Are you sure you want to Proceed?', false) then
            exit;

        if not WarehouseSetup.Get() then
            exit;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSRCPT') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSRCPT';
            NoSeries.Description := 'Defective Inventory Management Warehouse Receipt New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSRCPT';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMRE00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSRCPT+') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSRCPT+';
            NoSeries.Description := 'Defective Inventory Management Posted Warehouse Receipt New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSRCPT+';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMPR00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSSHIP') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSSHIP';
            NoSeries.Description := 'Defective Inventory Management Warehouse Shipment New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSSHIP';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMSH00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSSHIP+') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSSHIP+';
            NoSeries.Description := 'Defective Inventory Management Posted Warehouse Shipment New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSSHIP+';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMPS00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSPUT-') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSPUT-';
            NoSeries.Description := 'Defective Inventory Management Warehouse Internal Put-away New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSPUT-';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMIPU0001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSPUT-+') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSPUT-+';
            NoSeries.Description := 'Defective Inventory Management Registered Warehouse Put-away New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSPUT-+';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMRPU0001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMIPICK') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMIPICK';
            NoSeries.Description := 'Defective Inventory Management Warehouse Internal Pick New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMIPICK';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMIP00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSPICK+') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSPICK+';
            NoSeries.Description := 'Defective Inventory Management Registered Warehouse Pick New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSPICK+';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMRP00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSPUT') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSPUT';
            NoSeries.Description := 'Defective Inventory Management Warehouse Put-away New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSPUT';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMPU00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSMOV') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSMOV';
            NoSeries.Description := 'Defective Inventory Management Warehouse Movement New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSMOV';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMWM00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSPICK') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSPICK';
            NoSeries.Description := 'Defective Inventory Management Warehouse Pick New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSPICK';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMPI00001';
            if NoSeriesLine.Insert() then;
        end;

        NoSeries.Reset();
        if not NoSeries.Get('DIM-WMSMOVE+') then begin
            NoSeries.Init();
            NoSeries.Code := 'DIM-WMSMOVE+';
            NoSeries.Description := 'Defective Inventory Management Registered Warehouse Movement New';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'DIM-WMSMOVE+';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'DIMWM00001';
            if NoSeriesLine.Insert() then;
        end;

        WarehouseSetup."Whse. Receipt Nos." := 'DIM-WMSRCPT';
        WarehouseSetup."Posted Whse. Receipt Nos." := 'DIM-WMSRCPT+';
        WarehouseSetup."Whse. Ship Nos." := 'DIM-WMSSHIP';
        WarehouseSetup."Posted Whse. Shipment Nos." := 'DIM-WMSSHIP+';
        WarehouseSetup."Whse. Internal Put-away Nos." := 'DIM-WMSPUT-';
        WarehouseSetup."Registered Whse. Put-away Nos." := 'DIM-WMSPUT-+';
        WarehouseSetup."Whse. Internal Pick Nos." := 'DIM-WMIPICK';
        WarehouseSetup."Registered Whse. Pick Nos." := 'DIM-WMSPICK+';
        WarehouseSetup."Whse. Put-away Nos." := 'DIM-WMSPUT';
        WarehouseSetup."Whse. Movement Nos." := 'DIM-WMSMOV';
        WarehouseSetup."Whse. Pick Nos." := 'DIM-WMSPICK';
        WarehouseSetup."Whse. Movement Nos." := 'DIM-WMSMOVE+';

        if WarehouseSetup.Modify(true) then
            //if Rec.Modify(true) then;
            CurrPage.Update();

        Message('Number series setups have been reset.')
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterInitDefaultSetup()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterDeleteAllSetups()
    begin
    end;
}

