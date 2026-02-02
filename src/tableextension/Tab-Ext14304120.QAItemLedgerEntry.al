tableextension 14304120 QAItemLedgerEntry extends "Item Ledger Entry"
{
    fields
    {
        field(14304104; "Restriction Code"; Code[40])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information"."Restriction Code" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));
            Editable = false;
        }
        field(14304105; "Restriction Status"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information"."Restriction Status" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));
            Editable = false;
        }
    }
}
