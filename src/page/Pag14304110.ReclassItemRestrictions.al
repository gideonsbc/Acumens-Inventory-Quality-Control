page 14304110 "Reclass Item Restrictions"
{
    PageType = ConfirmationDialog;
    SourceTable = "Item Restrictions";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            field("Restriction Status to"; RestrictionStatus)
            {
                ApplicationArea = All;
                TableRelation = "Warehouse Restriction Status".Code;

                trigger OnValidate()
                var
                    WarehouseRestrictionStatus: Record "Warehouse Restriction Status";
                    RestrictionUserSetup: Record "Restriction User Setup";
                begin
                    RestrictionUserSetup.Get(UserId);
                    if RestrictionUserSetup."Restriction Status Filter" <> '' then if StrPos(RestrictionUserSetup."Restriction Status Filter", RestrictionStatus) = 0 then WarehouseRestrictionStatus.FieldError(Code, RestrictionStatus);
                    WarehouseRestrictionStatus.SetRange(Code, RestrictionStatus);
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
                TableRelation = "Warehouse Restriction"."Code";

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
            field("Change Release Bin Code"; FromBinCode)
            {
                Caption = 'Release Bin Code';
                ApplicationArea = All;

                trigger OnLookup(var Text: Text): Boolean
                var
                    Bin: Record "Bin";
                begin
                    Bin.SetRange("Location Code", Rec."Location Code");
                    Bin.SetRange("QA. Bin", false);
                    IF PAGE.RUNMODAL(PAGE::"Bin List", Bin) = ACTION::LookupOK THEN BEGIN
                        Text := Bin.Code;
                        FromBinCode := Bin.Code;
                        EXIT(TRUE);
                    END;
                    EXIT(FALSE);
                end;

                trigger OnValidate()
                begin
                    BinCode := FromBinCode + '-Q';
                end;
            }
            field("Change QA. Bin Code"; BinCode)
            {
                Caption = 'QA. Bin Code';
                ApplicationArea = All;
                Editable = false;
            }
            field("Qty. to Reclass"; Rec."Qty. to Handle")
            {
                ApplicationArea = All;
                Caption = 'Qty. to Reclass';

                trigger OnValidate()
                var
                    ErrLbl: Label 'Qty. to Release must not be grater than Remaining Qty."';
                begin
                    Rec.CalcFields("Remaining Qty.");
                    if Rec."Remaining Qty." < Rec."Qty. to Handle" then Error(ErrLbl);
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
                field("Restriction Code"; Rec."Restriction Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Restriction Status"; Rec."Restriction Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Release Bin Code"; Rec."Release Bin Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QA. Bin Code"; Rec."QA. Bin Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Qty."; Rec."Remaining Qty.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ItemRestrictions: Record "Item Restrictions";
        QAManagment: Codeunit "QA Management";
        ConLbl: Label 'Are you sure you want to Reclass item restriction?';
    begin
        if CloseAction = CloseAction::Yes then begin
            if Confirm(ConLbl, true) then begin
                Clear(QAManagment);
                ItemRestrictions.Get(Rec."Restriction ID");
                if Rec."Qty. to Handle" <> 0 then QAManagment.RegisterReclass(ItemRestrictions, RestrictionCode, RestrictionStatus, FromBinCode, ItemRestrictions."QA. Bin Code", BinCode);
            end;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if BinCode = '' then begin
            RestrictionCode := Rec."Restriction Code";
            RestrictionStatus := Rec."Restriction Status";
            FromBinCode := Rec."Release Bin Code";
            BinCode := Rec."QA. Bin Code";
        end;
    end;

    trigger OnOpenPage()
    var
        RestrictionUserSetup: Record "Restriction User Setup";
    begin
        RestrictionUserSetup.Get(UserId);
        AllowReclass := RestrictionUserSetup."Allow Reclass";
    end;

    var
        AllowReclass: Boolean;
        RestrictionCode: Code[20];
        RestrictionStatus: Code[20];
        FromBinCode: Code[20];
        BinCode: Code[20];
}
