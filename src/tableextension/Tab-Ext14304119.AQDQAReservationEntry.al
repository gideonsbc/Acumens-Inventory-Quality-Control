tableextension 14304119 "AQD QAReservationEntry" extends "Reservation Entry"
{
    fields
    {
        field(14304104; "AQD Blocked"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Lot No. Information".Blocked where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));
            Editable = false;
            Caption = 'Blocked';
        }
        field(14304105; "AQD Restriction Code"; Code[40])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("AQD Item Restrictions"."Restriction Code" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No."), "Location Code" = field("Location Code"), Open = const(true)));
            Editable = false;
            Caption = 'Restriction Code';
        }
        field(14304106; "AQD Restriction Status"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("AQD Item Restrictions"."Restriction Status" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No."), "Location Code" = field("Location Code"), Open = const(true)));
            Editable = false;
            Caption = 'Restriction Status';
        }
        field(14304107; "AQD ILE Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Ledger Entry"."Expiration Date" WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD("Variant Code"), "Lot No." = FIELD("Lot No."), Positive = CONST(true), Open = CONST(true)));
            Editable = false;
        }
    }
}
