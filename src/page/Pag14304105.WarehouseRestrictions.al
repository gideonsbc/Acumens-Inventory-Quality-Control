page 14304105 "Warehouse Restrictions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Warehouse Restriction";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        RestrictionUserSetup: Record "Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        Rec.FilterGroup(2);
        if RestrictionUserSetup."Restriction Code Filter" <> '' then Rec.SetFilter("Code", RestrictionUserSetup."Restriction Code Filter");
        Rec.FilterGroup(0);
    end;

    procedure GetSelectionFilter(): Text
    var
        WarehouseRestriction: Record "Warehouse Restriction";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        CurrPage.SetSelectionFilter(WarehouseRestriction);
        RecRef.GetTable(WarehouseRestriction);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, WarehouseRestriction.FieldNo(Code)));
    end;
}
