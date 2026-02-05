pageextension 14304106 "AQD QAZones" extends Zones
{
    layout
    {
        addafter("Warehouse Class Code")
        {
            field("AQD QA. Zone"; Rec."AQD QA. Zone")
            {
                ApplicationArea = All;
                Caption = 'QA. Zone';
                ToolTip = 'Specifies the value of the QA. Zone field.';
            }
        }
    }
    var
}
