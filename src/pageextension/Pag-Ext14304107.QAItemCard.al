pageextension 14304107 QAItemCard extends "Item Card"
{
    actions
    {
        addfirst(navigation)
        {
            action("Warehouse Item Restrictions")
            {
                ApplicationArea = Assembly;
                Caption = 'Warehouse Item Restrictions';
                Image = Permission;
                RunObject = page "Warehouse Item Restrictions";
                RunPageLink = "Item No." = field("No.");
            }
        }
    }
}
