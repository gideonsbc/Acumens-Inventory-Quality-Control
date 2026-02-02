page 14304106 "Warehouse Item Restrictions"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Warehouse Item Restriction";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Restriction Status"; Rec."Restriction Status")
                {
                    ApplicationArea = All;
                }
                field("Restriction Code"; Rec."Restriction Code")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
