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
        addafter(Category_Category20)
        {
            group("AQD Acumens Quality Control Management Promoted")
            {
                Caption = 'Acumens Quality Control Management';
                actionref(AQDWarehouseItemRestrictions_Promoted; "AQD Warehouse Item Restrictions")
                {
                }
            }
        }
    }
}
