tableextension 14304110 "AQD QALotNoInformation" extends "Lot No. Information"
{
    fields
    {
        field(14304104; "AQD Qty. In QA. Bin"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Entry"."Qty. (Base)" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Location Code" = field("Location Filter"), "Lot No." = field("Lot No."), "AQD QA. Bin" = const(true)));
            Editable = false;
            Caption = 'Qty. In QA. Bin';
        }
        field(14304105; "AQD Qty. Restricted"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("AQD Item Restriction Entry"."Qty. (Base)" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No.")));
            Editable = false;
            Caption = 'Qty. Restricted';
        }
        field(14304106; "AQD Last Split No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Last Split No.';
        }
        field(14304107; "AQD Parent Lot No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Parent Lot No.';
        }
        field(14304108; "AQD Restriction Code"; Code[40])
        {
            TableRelation = "AQD Warehouse Restriction"."Code" where(Status = field("AQD Restriction Status"));
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Restriction Code';
        }
        field(14304109; "AQD Restriction Status"; Code[10])
        {
            TableRelation = "AQD WarehouseRestrictionStatus".Code;
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Restriction Status';
        }
    }
}
