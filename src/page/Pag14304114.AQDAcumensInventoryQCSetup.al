// SBC. 2026-02-06. 
// It is not advisable to delete journal templates because it may have been used for postings. Therefore, this section was disabled for ready production.
page 14304114 "AQD Acumens Inventory QC Setup"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = Card;
    SourceTable = "AQD Acumens Inventory QC Setup";
    Caption = 'Acumens Inventory Quality Control Setup';

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
                    Caption = 'Enabled';
                    ToolTip = 'Specifies the value of the Enabled field.';
                }
                field("Log To History"; Rec."AQD Log To History")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Log To History field.';
                    Caption = 'Log To History';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Delete Acumens Inventory Quality Control Setups")
            {
                Image = CancelAllLines;
                ApplicationArea = All;
                ToolTip = 'Executes the Delete Acumens Inventory Quality Control Default Setups action.';
                Caption = 'Delete Acumens Inventory Quality Control Setups';
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
        }
        area(Navigation)
        {
            action("About the App")
            {
                Image = AboutNav;
                RunObject = page "AQD About Acumens Inventory QC";
                ApplicationArea = All;
                ToolTip = 'Executes the About Acumens Inventory Quality Control page.';
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
            group(Category_Process)
            {
                Caption = 'Home', Comment = 'Generated from the PromotedActionCategories property index 1.';
                actionref("Delete Acumens Inventory Quality Control Setups_Promoted"; "Delete Acumens Inventory Quality Control Setups") { }
                actionref("AQD Restriction User Setup_Promoted"; "Restriction User Setup") { }
                actionref("Warehouse Setup_Promoted"; "Warehouse Setup") { }
                actionref("AQD WarehouseRestrictionStatus_Promoted"; "AQD WarehouseRestrictionStatus") { }
                actionref("AQD Warehouse Restrictions_Promoted"; "AQD Warehouse Restrictions") { }
                actionref("Location Setup_Promoted"; "Location Setup") { }
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
        AERAccessMgt.AccessManager('AIQC01', true, false);
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);

            InitDefaultSetup();
        end;
    end;

    var
        AcumensInventoryQCSetup: Record "AQD Acumens Inventory QC Setup";
        AERAccessMgt: Codeunit "AQD Inventory QC Access Mgt.";
        RestrictionUserSetup: Record "AQD Restriction User Setup";
        WarehouseSetup: Record "Warehouse Setup";
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        WareHouseJournalTemplate: Record "Warehouse Journal Template";
        WareHouseJournalBatch: Record "Warehouse Journal Batch";
        Location: Record Location;
        AQDWarehouseRestrictionStatus: Record "AQD WarehouseRestrictionStatus";
        AQDWarehouseRestriction: Record "AQD Warehouse Restriction";

    local procedure InitDefaultSetup();
    begin
        if Confirm('Do you want to automatically Initialize default Acumens Inventory Quality Control Setups?') then begin
            Rec."AQD Enabled" := true;
            Rec."AQD Log To History" := true;
            Rec."AQD Setup Initialized By" := UserId;
            Rec.Modify();

            InitializeRestrictionUserSetup();

            CreateDummyLocation();

            CreateWarehouseJournalSetup();

            InitializeWarehouseRestriction();

            AssignWarehouseSetup();
        end;
        Message('Default Setups Initialized Successfully!');
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

    local procedure CreateDummyLocation()
    begin
        if not Location.Get('DUMMY') then begin
            Location.Init();
            Location.Code := 'DUMMY';
            Location.Name := 'Dummy Warehouse';
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
            WhseJnlBatch."Location Code" := 'DUMMY';
            WhseJnlTemplate.Insert();
        end;

        if not WhseJnlBatch.Get('SPLWHSEJNR', 'SPLWHSEBAT', 'DUMMY') then begin
            WhseJnlBatch.Init();
            WhseJnlBatch."Journal Template Name" := 'SPLWHSEJNR';
            WhseJnlBatch.Name := 'SPLWHSEBAT';
            WhseJnlBatch.Description := 'Split Lot Warehouse Batch';
            WhseJnlBatch.Insert();
        end;

        // === QA JOURNAL ===
        if not ItemJournalTemplate.Get('QAJOURNAL') then begin
            ItemJournalTemplate.Init();
            ItemJournalTemplate.Name := 'QAJOURNAL';
            ItemJournalTemplate.Description := 'QA Journal';
            ItemJournalTemplate.Type := ItemJournalTemplate.Type::Item;
            ItemJournalTemplate."Source Code" := 'ITEMJNL';
            ItemJournalTemplate.Insert();
        end;

        if not ItemJournalBatch.Get('QAJOURNAL', 'QABATCH') then begin
            ItemJournalBatch.Init();
            ItemJournalBatch."Journal Template Name" := 'QAJOURNAL';
            ItemJournalBatch.Name := 'QABATCH';
            ItemJournalBatch.Description := 'QA Batch';
            ItemJournalBatch.Insert();
        end;

        // === QA WAREHOUSE JOURNAL ===
        if not WhseJnlTemplate.Get('QAWHSEJNR') then begin
            WhseJnlTemplate.Init();
            WhseJnlTemplate.Name := 'QAWHSEJNR';
            WhseJnlTemplate.Description := 'QA Warehouse Journal';
            WhseJnlTemplate.Type := WhseJnlTemplate.Type::Item;
            WhseJnlTemplate.Insert();
        end;

        if not WhseJnlBatch.Get('QAWHSEJNR', 'QAWHSEBATC', 'DUMMY') then begin
            WhseJnlBatch.Init();
            WhseJnlBatch."Journal Template Name" := 'QAWHSEJNR';
            WhseJnlBatch.Name := 'QAWHSEBATC';
            WhseJnlBatch.Description := 'QA Warehouse Batch';
            WhseJnlBatch."Location Code" := 'DUMMY';
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

        WarehouseSetup.Validate("AQD QA. Template Name", 'QAJOURNAL');
        WarehouseSetup.Validate("AQD QA. Batch Name", 'QABATCH');
        WarehouseSetup.Validate("AQD QA. Whse Template Name", 'QAWHSEJNR');
        WarehouseSetup.Validate("AQD QA. Warehouse Batch Name", 'QAWHSEBATC');

        WarehouseSetup.Validate("AQD Inv. Counts Restr. Status", 'COUNTING');
        WarehouseSetup.Validate("AQD Inv. Counts Restr. Code", 'INVCOUNT');
        WarehouseSetup.Validate("AQD Expired Lot Restr. Status", 'EXPIRED');
        WarehouseSetup.Validate("AQD Expired Lot Restr. Code", 'EXPLOT');

        WarehouseSetup.Modify(true);
    end;

    local procedure DeleteAllSetups();
    begin
        if not Confirm('Deleting Setup Card will delete all Acumens Inventory Quality Control specific Setups. Proceed?', false) then
            exit;

        //Delete Acumens Restriction User Setups
        RestrictionUserSetup.Reset();
        RestrictionUserSetup.DeleteAll();

        //Delete Created Dummy Location
        if not LocationHasPostings('DUMMY') then begin
            Location.Reset();
            Location.SetRange(Code, 'DUMMY');
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
        // ItemJournalTemplate.SetFilter(Name, 'SPLITLOT|QAJOURNAL');
        // ItemJournalTemplate.DeleteAll(true);

        // ItemJournalBatch.Reset();
        // ItemJournalBatch.SetFilter("Journal Template Name", 'SPLITLOT|QAJOURNAL');
        // ItemJournalBatch.SetFilter(Name, 'SPLBATCH|QABATCH');
        // ItemJournalBatch.DeleteAll(true);

        // WarehouseJournalTemplate.Reset();
        // WarehouseJournalTemplate.SetFilter(Name, 'SPLWHSEJNR|QAWHSEJNR');
        // WarehouseJournalTemplate.DeleteAll(true);

        // WarehouseJournalBatch.Reset();
        // WarehouseJournalBatch.SetFilter("Journal Template Name", 'SPLWHSEJNR|QAWHSEJNR');
        // WarehouseJournalBatch.SetFilter(Name, 'SPLWHSEBAT|QAWHSEBATC');
        // WarehouseJournalBatch.DeleteAll(true);
        //>>>SBC. 2026-02-06.

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
}

