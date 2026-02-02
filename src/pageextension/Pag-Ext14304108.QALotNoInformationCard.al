pageextension 14304108 QALotNoInformationCard extends "Lot No. Information Card"
{
    layout
    {
        addafter(InventoryField)
        {
            field("Qty. In QA. Bin"; Rec."Qty. In QA. Bin")
            {
                ApplicationArea = All;
            }
            field("Qty. Restricted"; Rec."Qty. Restricted")
            {
                ApplicationArea = All;
            }
            field("Restriction Code"; Rec."Restriction Code")
            {
                ApplicationArea = All;
            }
            field("Restriction Status"; Rec."Restriction Status")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action("Restrict Item")
            {
                ApplicationArea = All;
                Caption = 'Restrict Item';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = Lock;

                trigger OnAction()
                var
                    LotNoInfo: Record "Lot No. Information";
                    RestrictLot: Page "Restrict Lot";
                begin
                    LotNoInfo := Rec;
                    LotNoInfo.SetRecFilter();
                    RestrictLot.SetTableView(LotNoInfo);
                    RestrictLot.Run();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
