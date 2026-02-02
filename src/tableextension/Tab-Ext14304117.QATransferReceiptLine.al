tableextension 14304117 QATransferReceiptLine extends "Transfer Receipt Line"
{
    fields
    {
        field(14304104; "Restriction Code"; Code[40])
        {
            TableRelation = "Warehouse Restriction"."Code" where(Status = field("Restriction Status"));
        }
        field(14304105; "Restriction Status"; Code[20])
        {
            TableRelation = "Warehouse Restriction Status".Code;
        }
    }
}
