page 14304109 "AQD WarehouseRestrictionStatus"
{
    Caption = 'Warehouse Restriction Status';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "AQD WarehouseRestrictionStatus";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Caption = 'GroupName';
                field("Code"; Rec.Code)
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
                field(Scrap; Rec."Enable Scrap")
                {
                    ApplicationArea = All;
                    Caption = 'Enable Scrap';
                    ToolTip = 'Specifies the value of the Enable Scrap field.';
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
                RunObject = page "AQD Warehouse Restrictions";
                RunPageLink = Status = field(Code);
                ToolTip = 'Executes the Restriction Codes action.';
            }
        }
    }
    trigger OnOpenPage()
    var
        RestrictionUserSetup: Record "AQD Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        Rec.FilterGroup(2);
        if RestrictionUserSetup."Restriction Status Filter" <> '' then Rec.SetFilter(Code, RestrictionUserSetup."Restriction Status Filter");
        Rec.FilterGroup(0);
    end;

    procedure GetSelectionFilter(): Text
    var
        WarehouseRestrictionStatus: Record "AQD WarehouseRestrictionStatus";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        CurrPage.SetSelectionFilter(WarehouseRestrictionStatus);
        RecRef.GetTable(WarehouseRestrictionStatus);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, WarehouseRestrictionStatus.FieldNo(Code)));
    end;
}
