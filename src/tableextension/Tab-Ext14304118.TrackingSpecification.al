tableextension 14304118 TrackingSpecification extends "Tracking Specification"
{
    fields
    {
        field(14304104; "Blocked"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information".Blocked where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));
            Editable = false;
        }
        field(14304105; "Restriction Code"; Code[40])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Restrictions"."Restriction Code" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No."), "Location Code" = field("Location Code"), Open = const(true)));
            Editable = false;
        }
        field(14304106; "Restriction Status"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Restrictions"."Restriction Status" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No."), "Location Code" = field("Location Code"), Open = const(true)));
            Editable = false;
        }
    }
}
