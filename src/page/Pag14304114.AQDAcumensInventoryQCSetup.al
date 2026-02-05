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
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';
                actionref("AQD Block Expired Lots_Promoted"; "AQD Block Expired Lots") { }
                actionref("AQD Update Lot Restriction_Promoted"; "AQD Update Lot Restriction") { }
            }
            group(Category_New)
            {
                Caption = 'About', Comment = 'Generated from the PromotedActionCategories property index 3.';
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

    local procedure InitDefaultSetup();
    begin
        if Confirm('Do you want to automatically Initialize default Acumens Inventory Quality Control Setups?') then begin
            Rec."AQD Enabled" := true;
            Rec."AQD Log To History" := true;
            Rec."AQD Setup Initialized By" := UserId;
            Rec.Modify();

            InitializeRestrictionUserSetup();

            InitializeWareHouseSetup();
        end;
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

    local procedure InitializeWareHouseSetup();
    begin
        AcumensInventoryQCSetup.Get();
        WarehouseSetup.Reset();
        // <<< SBC. To be auto generated and assigned later.TODO
        if not WarehouseSetup.FindFirst() then begin
            WarehouseSetup.Init();
            WarehouseSetup."AQD QA. Template Name" := '';
            WarehouseSetup."AQD Split Lot Batch Name" := '';
            WarehouseSetup."AQD QA. Warehouse Template Name" := '';
            WarehouseSetup."AQD Split Lot Whse Template Name" := '';
            WarehouseSetup."AQD QA. Batch Name" := '';
            WarehouseSetup."AQD QA. Template Name" := '';
            WarehouseSetup."AQD QA. Warehouse Template Name" := '';
            WarehouseSetup."AQD QA. Warehouse Batch Name" := '';
            WarehouseSetup.Insert();
        end;
    end;

    local procedure DeleteAllSetups();
    begin
        if not Confirm('Deleting Setup Card will delete all Acumens Inventory Quality Control specific Setups. Proceed?', false) then
            exit;

        //Delete Acumens Restriction User Setups
        RestrictionUserSetup.Reset();
        RestrictionUserSetup.DeleteAll();

        Rec.DeleteAll();
        CurrPage.Close();
    end;
}

