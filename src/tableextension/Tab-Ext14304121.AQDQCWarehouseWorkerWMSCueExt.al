
tableextension 14304121 "AQD QCWarehouseWorkerWMSCueExt" extends "Warehouse WMS Cue"
{
    fields
    {
        field(14304121; "AQD Warehouse Restriction"; Integer)
        {
            CalcFormula = count("AQD Warehouse Restriction");
            Caption = 'Warehouse Restriction';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14304122; "AQD Warehouse Item Restriction"; Integer)
        {
            CalcFormula = count("AQD Warehouse Item Restriction");
            Caption = 'Warehouse Inventory Restriction';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14304123; "AQD Item Restrictions"; Integer)
        {
            CalcFormula = count("AQD Item Restrictions");
            Caption = 'Inventory Restriction';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14304124; "AQD Item Restriction Entry"; Integer)
        {
            CalcFormula = count("AQD Item Restriction Entry");
            Caption = 'Inventory Restriction Entry';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14304125; "AQD WarehouseRestrictionStatus"; Integer)
        {
            CalcFormula = count("AQD WarehouseRestrictionStatus");
            Caption = 'Warehouse Restriction Status';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}