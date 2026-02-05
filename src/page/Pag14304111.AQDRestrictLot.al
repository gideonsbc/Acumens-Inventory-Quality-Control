page 14304111 "AQD Restrict Lot"
{
    Caption = 'Restrict Lot';
    PageType = ConfirmationDialog;
    SourceTable = "Lot No. Information";
    RefreshOnActivate = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field("Location Code"; LCode)
            {
                Caption = 'Location Code';
                ApplicationArea = All;
                ShowMandatory = true;
                TableRelation = Location where("Use As In-Transit" = const(false));
                ToolTip = 'Specifies the value of the Location Code field.';

                trigger OnValidate()
                begin
                    Rec.SetRange("Location Filter", LCode);
                    CurrPage.Update();
                end;
            }
            field("Restriction Status to"; RestrictionStatus)
            {
                ApplicationArea = All;
                ShowMandatory = true;
                TableRelation = "AQD WarehouseRestrictionStatus".Code;
                Caption = 'RestrictionStatus';
                ToolTip = 'Specifies the value of the RestrictionStatus field.';

                trigger OnValidate()
                var
                    WarehouseRestrictionStatus: Record "AQD WarehouseRestrictionStatus";
                    RestrictionUserSetup: Record "AQD Restriction User Setup";
                begin
                    RestrictionUserSetup.Get(UserId);
                    if RestrictionUserSetup."Restriction Status Filter" <> '' then if StrPos(RestrictionUserSetup."Restriction Status Filter", RestrictionStatus) = 0 then WarehouseRestrictionStatus.FieldError(Code, RestrictionStatus);
                    WarehouseRestrictionStatus.SetFilter(Code, RestrictionStatus);
                    WarehouseRestrictionStatus.FindSet();
                    RestrictionCode := '';
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    WarehouseRestrictionStatus: Record "AQD WarehouseRestrictionStatus";
                    RestrictionUserSetup: Record "AQD Restriction User Setup";
                begin
                    RestrictionUserSetup.Get(UserId);
                    Rec.FilterGroup(2);
                    if RestrictionUserSetup."Restriction Status Filter" <> '' then WarehouseRestrictionStatus.SetFilter(Code, RestrictionUserSetup."Restriction Status Filter");
                    Rec.FilterGroup(0);
                    IF PAGE.RUNMODAL(PAGE::"AQD WarehouseRestrictionStatus", WarehouseRestrictionStatus) = ACTION::LookupOK THEN BEGIN
                        Text := WarehouseRestrictionStatus."Code";
                        RestrictionStatus := WarehouseRestrictionStatus."Code";
                        RestrictionCode := '';
                        EXIT(TRUE);
                    END;
                    EXIT(FALSE);
                end;
            }
            field("Restriction Code to"; RestrictionCode)
            {
                ApplicationArea = All;
                ShowMandatory = true;
                TableRelation = "AQD Warehouse Restriction".Code;
                Caption = 'RestrictionCode';
                ToolTip = 'Specifies the value of the RestrictionCode field.';

                trigger OnValidate()
                var
                    WarehouseRestriction: Record "AQD Warehouse Restriction";
                    RestrictionUserSetup: Record "AQD Restriction User Setup";
                begin
                    RestrictionUserSetup.Get(UserId);
                    if RestrictionUserSetup."Restriction Code Filter" <> '' then if StrPos(RestrictionUserSetup."Restriction Code Filter", RestrictionCode) = 0 then WarehouseRestriction.FieldError(Code, RestrictionCode);
                    WarehouseRestriction.SetRange(Status, RestrictionStatus);
                    WarehouseRestriction.SetRange(Code, RestrictionCode);
                    WarehouseRestriction.FindSet();
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    WarehouseRestriction: Record "AQD Warehouse Restriction";
                    RestrictionUserSetup: Record "AQD Restriction User Setup";
                begin
                    RestrictionUserSetup.Get(UserId);
                    Rec.FilterGroup(2);
                    if RestrictionUserSetup."Restriction Code Filter" <> '' then WarehouseRestriction.SetFilter(Code, RestrictionUserSetup."Restriction Code Filter");
                    WarehouseRestriction.SetRange(Status, RestrictionStatus);
                    Rec.FilterGroup(0);
                    IF PAGE.RUNMODAL(PAGE::"AQD Warehouse Restrictions", WarehouseRestriction) = ACTION::LookupOK THEN BEGIN
                        Text := WarehouseRestriction."Code";
                        RestrictionCode := WarehouseRestriction."Code";
                        EXIT(TRUE);
                    END;
                    EXIT(FALSE);
                end;
            }
            group(Current)
            {
                Caption = 'Current';
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies this number from the Tracking Specification table when a lot number information record is created.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Variant Code';
                    ToolTip = 'Specifies the variant of the item on the line.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Lot No.';
                    ToolTip = 'Specifies this number from the Tracking Specification table when a lot number information record is created.';
                }
                field(Quantity; Rec.Inventory)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Inventory';
                    ToolTip = 'Specifies the inventory quantity of the specified lot number.';
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        LotNo: Record "Lot No. Information";
        BinContent: Record "Bin Content";
        Location: Record Location;
        Bin: Record Bin;
        QAManagment: Codeunit "AQD QA Management";
        QASingleInstance: Codeunit "AQD QA Single Instance";
        ConLbl: Label 'Are you sure you want to Restrict item?';
        RestrictionCodeError: Label 'Restriction Code must not be blank.';
        RestrictionStatusError: Label 'Restriction Status must not be blank.';
    begin
        if CloseAction = CloseAction::Yes then begin
            if Confirm(ConLbl, true) then begin
                ClearLastError();
                Clear(QAManagment);
                LotNo.Copy(Rec);
                Location.Get(LCode);
                if RestrictionCode = '' then Error(RestrictionCodeError);
                if RestrictionStatus = '' then Error(RestrictionStatusError);
                QASingleInstance.SetQABin(true);
                BinContent.SetAutoCalcFields("Quantity (Base)", Quantity);
                BinContent.SetRange("Location Code", LCode);
                BinContent.SetFilter("Zone Code", '<>%1', Location."AQD QA. Zone");
                BinContent.SetRange("AQD QA. Bin", false);
                BinContent.SetRange("Item No.", Rec."Item No.");
                BinContent.SetRange("Variant Code", Rec."Variant Code");
                BinContent.SetRange("Lot No. Filter", Rec."Lot No.");
                BinContent.SetFilter("Quantity (Base)", '<> 0');
                if BinContent.FindSet() then
                    repeat
                        Bin.Get(Location.Code, BinContent."Bin Code");
                        if not Bin."AQD QA. Bin" then
                            if not QAManagment.RestrictItem(LotNo, BinContent.Quantity, BinContent."Quantity (Base)", RestrictionCode, RestrictionStatus, LCode, BinContent."Bin Code", BinContent."Unit of Measure Code") then begin
                                QASingleInstance.SetQARestriction(false);
                                Error(GetLastErrorText());
                            end;
                    until BinContent.Next() = 0;
            end;
            QASingleInstance.SetQARestriction(false);
        end;
    end;

    trigger OnOpenPage()
    var
        RestrictionUserSetup: Record "AQD Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        RestrictionUserSetup.TestField("Allow Set Restriction");
    end;

    var
        RestrictionCode: Code[20];
        RestrictionStatus: Code[20];
        LCode: Code[20];
}
