page 14304112 "AQD Restriction User Setup"
{
    Caption = 'Acumens Restriction User Setup';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "AQD Restriction User Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Caption = 'GroupName';
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Caption = 'User ID';
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(Admin; Rec.Admin)
                {
                    ApplicationArea = All;
                    Caption = 'Admin';
                    ToolTip = 'Specifies the value of the Admin field.';
                }
                field("Allow Release"; Rec."Allow Release")
                {
                    ApplicationArea = All;
                    Caption = 'Allow Release';
                    ToolTip = 'Specifies the value of the Allow Release field.';
                }
                field("Allow Scrap"; Rec."Allow Scrap")
                {
                    ApplicationArea = All;
                    Caption = 'Allow Scrap';
                    ToolTip = 'Specifies the value of the Allow Scrap field.';
                }
                field("Allow Reclass"; Rec."Allow Reclass")
                {
                    ApplicationArea = All;
                    Caption = 'Allow Reclass';
                    ToolTip = 'Specifies the value of the Allow Reclass field.';
                }
                field("Allow Set Restriction"; Rec."Allow Set Restriction")
                {
                    ApplicationArea = All;
                    Caption = 'Allow Set Restriction';
                    ToolTip = 'Specifies the value of the Allow Set Restriction field.';
                }
                field("Allow Split - Merge Lot No."; Rec."Allow Split - Merge Lot No.")
                {
                    ApplicationArea = All;
                    Caption = 'Allow Split - Merge Lot No.';
                    ToolTip = 'Specifies the value of the Allow Split - Merge Lot No. field.';
                }
                field("Allow Update From QA. Bins"; Rec."Allow Update From QA. Bins")
                {
                    ApplicationArea = All;
                    Caption = 'Allow Update From QA. Bins';
                    ToolTip = 'Specifies the value of the Allow Update From QA. Bins field.';
                }
                field("Restriction Code Filter"; Rec."Restriction Code Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Restriction Code Filter';
                    ToolTip = 'Specifies the value of the Restriction Code Filter field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        WarehouseRestrictions: Page "AQD Warehouse Restrictions";
                    begin
                        WarehouseRestrictions.RunModal();
                        Rec."Restriction Code Filter" := WarehouseRestrictions.GetSelectionFilter;
                    end;
                }
                field("Restriction Status Filter"; Rec."Restriction Status Filter")
                {
                    ApplicationArea = All;
                    Caption = 'Restriction Status Filter';
                    ToolTip = 'Specifies the value of the Restriction Status Filter field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        WarehouseRestrictionStatus: Page "AQD WarehouseRestrictionStatus";
                    begin
                        WarehouseRestrictionStatus.RunModal();
                        Rec."Restriction Status Filter" := WarehouseRestrictionStatus.GetSelectionFilter;
                    end;
                }
            }
        }
    }
}
