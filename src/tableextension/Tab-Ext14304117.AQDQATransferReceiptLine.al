tableextension 14304117 "AQD QATransferReceiptLine" extends "Transfer Receipt Line"
{
    fields
    {
        field(14304104; "AQD Restriction Code"; Code[40])
        {
            TableRelation = "AQD Warehouse Restriction"."Code" where(Status = field("AQD Restriction Status"));
            DataClassification = CustomerContent;
            Caption = 'Restriction Code';
        }
        field(14304105; "AQD Restriction Status"; Code[20])
        {
            TableRelation = "AQD WarehouseRestrictionStatus".Code;
            DataClassification = CustomerContent;
            Caption = 'Restriction Status';
        }
    }
}
