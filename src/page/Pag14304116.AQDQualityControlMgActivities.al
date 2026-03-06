page 14304116 "AQD QualityControlMgActivities"
{
    Caption = 'Acumens Quality Control Management Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Warehouse WMS Cue";

    layout
    {
        area(content)
        {
            cuegroup("Warehouse Restrictions")
            {
                Caption = 'Warehouse Restrictions';
                field("AQD Warehouse Restriction"; Rec."AQD Warehouse Restriction")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "AQD Warehouse Restrictions";
                    Caption = 'Warehouse Restrictions';
                }
                field("AQD Warehouse Item Restriction"; Rec."AQD Warehouse Item Restriction")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "AQD WarehouseItem Restrictions";
                    Caption = 'Warehouse Item Restrictions';
                }
            }
            cuegroup("Item Restrictions")
            {
                Caption = 'Item Restrictions';
                field("AQD Item Restrictions"; Rec."AQD Item Restrictions")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "AQD Item Restrictions";
                    Caption = 'Item Restrictions';
                }
                field("AQD Item Restriction Entry"; Rec."AQD Item Restriction Entry")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "AQD Item Restriction Entries";
                    Caption = 'Item Restriction Entries';
                }
                field("AQD WarehouseRestrictionStatus"; Rec."AQD WarehouseRestrictionStatus")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "AQD WarehouseRestrictionStatus";
                    Caption = 'Warehouse Restriction Status';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        // Rec.SetRange("User ID Filter", UserId());
        // LocationCode := WhseWMSCue.GetEmployeeLocation(UserId());
        // Rec.SetFilter("Location Filter", LocationCode);
    end;

    var
        WhseWMSCue: Record "Warehouse WMS Cue";
        LocationCode: Text[1024];
}

