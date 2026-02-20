page 14304106 "AQD WarehouseItem Restrictions"
{
    Caption = 'Warehouse Item Restrictions';
    PageType = List;
    ApplicationArea = All;
    SourceTable = "AQD Warehouse Item Restriction";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Caption = 'GroupName';
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Restriction Status"; Rec."Restriction Status")
                {
                    ApplicationArea = All;
                    Caption = 'Restriction Status';
                    ToolTip = 'Specifies the value of the Restriction Status field.';
                }
                field("Restriction Code"; Rec."Restriction Code")
                {
                    ApplicationArea = All;
                    Caption = 'Restriction Code';
                    ToolTip = 'Specifies the value of the Restriction Code field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the value of the Type field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not QASingleInstance.IsInventoryQualityControlEnabled() then
            Error(AcumensInventoryQClbl);
    end;

    var
        AcumensInventoryQClbl: Label 'Acumens Quality Control Management is not enabled';
        QASingleInstance: Codeunit "AQD QA Single Instance";
}
