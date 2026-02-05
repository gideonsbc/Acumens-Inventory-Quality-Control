tableextension 14304111 "AQD QAWarehouseEntry" extends "Warehouse Entry"
{
    fields
    {
        field(14304104; "AQD QA. Bin"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Bin."AQD QA. Bin" where("Location Code" = field("Location Code"), "Zone Code" = field("Zone Code"), Code = field("Bin Code")));
            Editable = false;
            Caption = 'QA. Bin';
        }
    }
    keys
    {
        // Add changes to keys here
    }
    fieldgroups
    {
        // Add changes to field groups here
    }
    var
        myInt: Integer;
}
