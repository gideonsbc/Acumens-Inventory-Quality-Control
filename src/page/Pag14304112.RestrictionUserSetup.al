page 14304112 "Restriction User Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Restriction User Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Admin; Rec.Admin)
                {
                    ApplicationArea = All;
                }
                field("Allow Release"; Rec."Allow Release")
                {
                    ApplicationArea = All;
                }
                field("Allow Scrap"; Rec."Allow Scrap")
                {
                    ApplicationArea = All;
                }
                field("Allow Reclass"; Rec."Allow Reclass")
                {
                    ApplicationArea = All;
                }
                field("Allow Set Restriction"; Rec."Allow Set Restriction")
                {
                    ApplicationArea = All;
                }
                field("Allow Split - Merge Lot No."; Rec."Allow Split - Merge Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Allow Update From QA. Bins"; Rec."Allow Update From QA. Bins")
                {
                    ApplicationArea = All;
                }
                field("Restriction Code Filter"; Rec."Restriction Code Filter")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        WarehouseRestrictions: Page "Warehouse Restrictions";
                    begin
                        WarehouseRestrictions.RunModal();
                        Rec."Restriction Code Filter" := WarehouseRestrictions.GetSelectionFilter;
                    end;
                }
                field("Restriction Status Filter"; Rec."Restriction Status Filter")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        WarehouseRestrictionStatus: Page "Warehouse Restriction Status";
                    begin
                        WarehouseRestrictionStatus.RunModal();
                        Rec."Restriction Status Filter" := WarehouseRestrictionStatus.GetSelectionFilter;
                    end;
                }
            }
        }
    }
}
