tableextension 14304112 QAWarehouseJournalLine extends "Warehouse Journal Line"
{
    fields
    {
        modify("Bin Code")
        {
            trigger OnAfterValidate()
            begin
                if ("To Bin Code" <> '') and ("Location Code" <> '') then Validate("To Bin Code");
            end;
        }
        modify("To Bin Code")
        {
            trigger OnBeforeValidate()
            var
                Location: Record Location;
                FromBin: Record Bin;
                ToBin: Record Bin;
                QAManagement: Codeunit "QA Management";
                QASingleInstance: Codeunit "QA Single Instance";
            begin
                if not QASingleInstance.GetReclass() then
                    if Location.Get("Location Code") then begin
                        FromBin.Get("Location Code", "From Bin Code");
                        if ToBin.Get("Location Code", "To Bin Code") then
                            if Location."QA. Zone" = FromBin."Zone Code" then begin
                                if ToBin."Zone Code" <> Location."QA. Zone" then begin
                                    "To Bin Code" := QAManagement.CreateQABin("Location Code", ToBin.Code);
                                end;
                            end;
                    end;
            end;
        }
        field(14304104; "QA. To Bin Code"; Code[20])
        {
            Caption = 'To Bin Code';
            TableRelation = if ("To Zone Code" = filter('')) Bin.Code where("Location Code" = field("Location Code"), "QA. Bin" = const(false))
            else if ("To Zone Code" = filter(<> '')) Bin.Code where("Location Code" = field("Location Code"), "Zone Code" = field("To Zone Code"), "QA. Bin" = const(false));

            trigger OnValidate()
            var
                Bin: Record Bin;
            begin
                Bin.SetRange("Location Code", Rec."Location Code");
                Bin.SetRange(Code, "QA. To Bin Code");
                if Rec."To Zone Code" <> '' then Bin.SetRange("Zone Code", Rec."To Zone Code");
                Bin.SetRange("QA. Bin", false);
                Bin.FindFirst();
                Validate("To Bin Code", "QA. To Bin Code");
            end;
        }
    }
}
