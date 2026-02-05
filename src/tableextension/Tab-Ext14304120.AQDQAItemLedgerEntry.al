tableextension 14304120 "AQD QAItemLedgerEntry" extends "Item Ledger Entry"
{
    fields
    {
        field(14304104; "AQD Restriction Code"; Code[40])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information"."AQD Restriction Code" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));
            Editable = false;
            Caption = 'Restriction Code';
        }
        field(14304105; "AQD Restriction Status"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information"."AQD Restriction Status" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));
            Editable = false;
            Caption = 'Restriction Status';
        }
    }
}
