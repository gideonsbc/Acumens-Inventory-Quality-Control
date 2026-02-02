page 14304111 "Restrict Lot"
{
    PageType = ConfirmationDialog;
    SourceTable = "Lot No. Information";
    RefreshOnActivate = true;

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
                TableRelation = "Warehouse Restriction Status".Code;

                trigger OnValidate()
                var
                    WarehouseRestrictionStatus: Record "Warehouse Restriction Status";
                    RestrictionUserSetup: Record "Restriction User Setup";
                begin
                    RestrictionUserSetup.Get(UserId);
                    if RestrictionUserSetup."Restriction Status Filter" <> '' then if StrPos(RestrictionUserSetup."Restriction Status Filter", RestrictionStatus) = 0 then WarehouseRestrictionStatus.FieldError(Code, RestrictionStatus);
                    WarehouseRestrictionStatus.SetFilter(Code, RestrictionStatus);
                    WarehouseRestrictionStatus.FindSet();
                    RestrictionCode := '';
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    WarehouseRestrictionStatus: Record "Warehouse Restriction Status";
                    RestrictionUserSetup: Record "Restriction User Setup";
                begin
                    RestrictionUserSetup.Get(UserId);
                    Rec.FilterGroup(2);
                    if RestrictionUserSetup."Restriction Status Filter" <> '' then WarehouseRestrictionStatus.SetFilter(Code, RestrictionUserSetup."Restriction Status Filter");
                    Rec.FilterGroup(0);
                    IF PAGE.RUNMODAL(PAGE::"Warehouse Restriction Status", WarehouseRestrictionStatus) = ACTION::LookupOK THEN BEGIN
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
                TableRelation = "Warehouse Restriction".Code;

                trigger OnValidate()
                var
                    WarehouseRestriction: Record "Warehouse Restriction";
                    RestrictionUserSetup: Record "Restriction User Setup";
                begin
                    RestrictionUserSetup.Get(UserId);
                    if RestrictionUserSetup."Restriction Code Filter" <> '' then if StrPos(RestrictionUserSetup."Restriction Code Filter", RestrictionCode) = 0 then WarehouseRestriction.FieldError(Code, RestrictionCode);
                    WarehouseRestriction.SetRange(Status, RestrictionStatus);
                    WarehouseRestriction.SetRange(Code, RestrictionCode);
                    WarehouseRestriction.FindSet();
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    WarehouseRestriction: Record "Warehouse Restriction";
                    RestrictionUserSetup: Record "Restriction User Setup";
                begin
                    RestrictionUserSetup.Get(UserId);
                    Rec.FilterGroup(2);
                    if RestrictionUserSetup."Restriction Code Filter" <> '' then WarehouseRestriction.SetFilter(Code, RestrictionUserSetup."Restriction Code Filter");
                    WarehouseRestriction.SetRange(Status, RestrictionStatus);
                    Rec.FilterGroup(0);
                    IF PAGE.RUNMODAL(PAGE::"Warehouse Restrictions", WarehouseRestriction) = ACTION::LookupOK THEN BEGIN
                        Text := WarehouseRestriction."Code";
                        RestrictionCode := WarehouseRestriction."Code";
                        EXIT(TRUE);
                    END;
                    EXIT(FALSE);
                end;
            }
            group(Current)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Inventory)
                {
                    ApplicationArea = All;
                    Editable = false;
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
        QAManagment: Codeunit "QA Management";
        QASingleInstance: Codeunit "QA Single Instance";
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
                BinContent.SetFilter("Zone Code", '<>%1', Location."QA. Zone");
                BinContent.SetRange("QA. Bin", false);
                BinContent.SetRange("Item No.", Rec."Item No.");
                BinContent.SetRange("Variant Code", Rec."Variant Code");
                BinContent.SetRange("Lot No. Filter", Rec."Lot No.");
                BinContent.SetFilter("Quantity (Base)", '<> 0');
                if BinContent.FindSet() then
                    repeat
                        Bin.Get(Location.Code, BinContent."Bin Code");
                        if not Bin."QA. Bin" then
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
        RestrictionUserSetup: Record "Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        RestrictionUserSetup.TestField("Allow Set Restriction");
    end;

    var
        RestrictionCode: Code[20];
        RestrictionStatus: Code[20];
        LCode: Code[20];
}
