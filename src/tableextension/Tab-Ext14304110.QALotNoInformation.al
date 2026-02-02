tableextension 14304110 QALotNoInformation extends "Lot No. Information"
{
    fields
    {
        field(14304104; "Qty. In QA. Bin"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Entry"."Qty. (Base)" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Location Code" = field("Location Filter"), "Lot No." = field("Lot No."), "QA. Bin" = const(true)));
            Editable = false;
        }
        field(14304105; "Qty. Restricted"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Restriction Entry"."Qty. (Base)" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));
            Editable = false;
        }
        field(14304106; "Last Split No."; Code[50])
        {
        }
        field(14304107; "Parent Lot No."; Code[50])
        {
        }
        field(14304108; "Restriction Code"; Code[40])
        {
            TableRelation = "Warehouse Restriction"."Code" where(Status = field("Restriction Status"));
            Editable = false;
        }
        field(14304109; "Restriction Status"; Code[10])
        {
            TableRelation = "Warehouse Restriction Status".Code;
            Editable = false;
        }
    }
}
