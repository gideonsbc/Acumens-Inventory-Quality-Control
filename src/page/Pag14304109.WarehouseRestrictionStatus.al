page 14304109 "Warehouse Restriction Status"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Warehouse Restriction Status";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Scrap; Rec."Enable Scrap")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action("Restriction Codes")
            {
                ApplicationArea = All;
                Caption = 'Restriction Codes';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = Stop;
                RunObject = page "Warehouse Restrictions";
                RunPageLink = Status = field(Code);
            }
        }
    }
    trigger OnOpenPage()
    var
        RestrictionUserSetup: Record "Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        Rec.FilterGroup(2);
        if RestrictionUserSetup."Restriction Status Filter" <> '' then Rec.SetFilter(Code, RestrictionUserSetup."Restriction Status Filter");
        Rec.FilterGroup(0);
    end;

    procedure GetSelectionFilter(): Text
    var
        WarehouseRestrictionStatus: Record "Warehouse Restriction Status";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        CurrPage.SetSelectionFilter(WarehouseRestrictionStatus);
        RecRef.GetTable(WarehouseRestrictionStatus);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, WarehouseRestrictionStatus.FieldNo(Code)));
    end;
}
