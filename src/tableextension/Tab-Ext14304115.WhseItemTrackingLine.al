tableextension 14304115 WhseItemTrackingLine extends "Whse. Item Tracking Line"
{
    fields
    {
        // modify("Lot No.")
        // {
        //     trigger OnBeforeValidate()
        //     var
        //         WhseSetup: Record "Warehouse Setup";
        //         ItemRestrictions: Record "Item Restrictions";
        //         WhseJnlLine: Record "Warehouse Journal Line";
        //         Location: Record Location;
        //         Bin: Record Bin;
        //         QABin: Record Bin;
        //         QAManagement: Codeunit "QA Management";
        //     begin
        //         WhseSetup.Get;
        //         if not WhseSetup."Allow Partial Release" then begin
        //             ItemRestrictions.SetRange("Item No.", "Item No.");
        //             ItemRestrictions.SetRange("Variant Code", "Variant Code");
        //             ItemRestrictions.SetRange("Lot No.", "Lot No.");
        //             ItemRestrictions.SetRange("Location Code", "Location Code");
        //             ItemRestrictions.SetRange(Open, true);
        //             ItemRestrictions.SetRange("Initial Entry", false);
        //             if ItemRestrictions.FindFirst() then
        //                 if WhseJnlLine.Get("Source Batch Name", "Source ID", "Location Code", "Source Ref. No.") then begin
        //                     Location.Get("Location Code");
        //                     Bin.Get("Location Code", WhseJnlLine."From Bin Code");
        //                     if not Bin."Restrict Item" then begin
        //                         if QABin.Get(WhseJnlLine."Location Code", WhseJnlLine."From Bin Code" + '-Q') then begin
        //                             WhseJnlLine."From Zone Code" := Location."QA. Zone";
        //                             WhseJnlLine."From Bin Code" += '-Q';
        //                             WhseJnlLine.Modify();
        //                         end;
        //                         if WhseJnlLine."To Zone Code" <> Location."QA. Zone" then begin
        //                             WhseJnlLine."To Zone Code" := Location."QA. Zone";
        //                             WhseJnlLine."To Bin Code" := QAManagement.CreateQABin(WhseJnlLine."Location Code", WhseJnlLine."To Bin Code");
        //                             WhseJnlLine.Modify();
        //                         end;
        //                     end;
        //                 end;
        //         end;
        //     end;
        // }
        field(14304104; Restricted; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Item Restrictions" where("Item No." = field("Item No."), "Variant Code" = field("Location Code"), "Lot No." = field("Lot No."), Open = const(true)));
            Editable = false;
        }
    }
}
