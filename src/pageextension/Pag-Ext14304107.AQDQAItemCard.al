pageextension 14304107 "AQD QAItemCard" extends "Item Card"
{
    actions
    {
        addfirst(navigation)
        {
            action("AQD Warehouse Item Restrictions")
            {
                ApplicationArea = Assembly;
                Caption = 'Warehouse Item Restrictions';
                Image = Permission;
                RunObject = page "AQD WarehouseItem Restrictions";
                RunPageLink = "item No." = field("No.");
                ToolTip = 'Executes the Warehouse Item Restrictions action.';
            }
        }
        addafter(Category_Category6)
        {
            group("AQD AQDAcumens Inventory Quality Control Promoted")
            {
                Caption = 'Acumens Inventory Quality Control';
                actionref(AQDWarehouseItemRestrictions_Promoted; "AQD Warehouse Item Restrictions")
                {
                }
            }
        }
    }
}
