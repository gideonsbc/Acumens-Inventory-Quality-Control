tableextension 14304111 QAWarehouseEntry extends "Warehouse Entry"
{
    fields
    {
        field(14304104; "QA. Bin"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Bin."QA. Bin" where("Location Code" = field("Location Code"), "Zone Code" = field("Zone Code"), Code = field("Bin Code")));
            Editable = false;
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
