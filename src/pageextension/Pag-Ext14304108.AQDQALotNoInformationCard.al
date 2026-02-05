pageextension 14304108 "AQD QALotNoInformationCard" extends "Lot No. Information Card"
{
    layout
    {
        addafter(InventoryField)
        {
            field("AQD Qty. In QA. Bin"; Rec."AQD Qty. In QA. Bin")
            {
                ApplicationArea = All;
                Caption = 'Qty. In QA. Bin';
                ToolTip = 'Specifies the value of the Qty. In QA. Bin field.';
            }
            field("AQD Qty. Restricted"; Rec."AQD Qty. Restricted")
            {
                ApplicationArea = All;
                Caption = 'Qty. Restricted';
                ToolTip = 'Specifies the value of the Qty. Restricted field.';
            }
            field("AQD Restriction Code"; Rec."AQD Restriction Code")
            {
                ApplicationArea = All;
                Caption = 'Restriction Code';
                ToolTip = 'Specifies the value of the Restriction Code field.';
            }
            field("AQD Restriction Status"; Rec."AQD Restriction Status")
            {
                ApplicationArea = All;
                Caption = 'Restriction Status';
                ToolTip = 'Specifies the value of the Restriction Status field.';
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action("AQD Restrict Item")
            {
                ApplicationArea = All;
                Caption = 'Restrict Item';
                // PromotedCategory = Process;
                // Promoted = true;
                Ellipsis = true;
                Image = Lock;
                ToolTip = 'Executes the Restrict Item action.';

                trigger OnAction()
                var
                    LotNoInfo: Record "Lot No. Information";
                    RestrictLot: Page "AQD Restrict Lot";
                begin
                    LotNoInfo := Rec;
                    LotNoInfo.SetRecFilter();
                    RestrictLot.SetTableView(LotNoInfo);
                    RestrictLot.Run();
                    CurrPage.Update(false);
                end;
            }
        }
        addafter(Category_Process)
        {
            group("AQD AQDAcumens Inventory Quality Control Promoted")
            {
                Caption = 'Acumens Inventory Quality Control';
                actionref(AQDRestrictItem_Promoted; "AQD Restrict Item")
                {
                }
            }
        }
    }
}
