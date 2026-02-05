page 14304105 "AQD Warehouse Restrictions"
{
    Caption = 'Warehouse Restrictions';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "AQD Warehouse Restriction";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Caption = 'GroupName';
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        RestrictionUserSetup: Record "AQD Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        Rec.FilterGroup(2);
        if RestrictionUserSetup."Restriction Code Filter" <> '' then Rec.SetFilter("Code", RestrictionUserSetup."Restriction Code Filter");
        Rec.FilterGroup(0);
    end;

    procedure GetSelectionFilter(): Text
    var
        WarehouseRestriction: Record "AQD Warehouse Restriction";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        CurrPage.SetSelectionFilter(WarehouseRestriction);
        RecRef.GetTable(WarehouseRestriction);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, WarehouseRestriction.FieldNo(Code)));
    end;
}
