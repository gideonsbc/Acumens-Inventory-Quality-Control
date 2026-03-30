page 14304113 "AQD AboutAcumensQualityCMgt"
{
    Caption = 'About Acumens Quality Control Management';
    Editable = false;
    LinksAllowed = false;
    ShowFilter = false;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(AppVersion)
            {
                Caption = 'App Version';
                field(BCAppversion; GetBCAppversion)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Editable = false;
                }
            }
            group(About)
            {
                Caption = 'About the App';
                field(AboutApp; AboutAppTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    MultiLine = true;
                }
            }
            group(Features)
            {
                Caption = 'Quality Control Management Capabilities';
                field(WarehouseRestrictionsTxtVar; WarehouseRestrictionsTxtVar)
                {
                    ApplicationArea = All;
                    //MultiLine = true;
                    ShowCaption = false;
                }
                field(WarehouseItemRestrictionsTxtVar; WarehouseItemRestrictionsTxtVar)
                {
                    ApplicationArea = All;
                    //MultiLine = true;
                    ShowCaption = false;
                }
                field(LotRestrictionQualityControlTxtVar; LotRestrictionQualityControlTxtVar)
                {
                    ApplicationArea = All;
                    //MultiLine = true;
                    ShowCaption = false;
                }
                field(SplitMergeLotNoTxtVar; SplitMergeLotNoTxtVar)
                {
                    ApplicationArea = All;
                    //MultiLine = true;
                    ShowCaption = false;
                }
                field(ItemRestrictionsTxtVar; ItemRestrictionsTxtVar)
                {
                    ApplicationArea = All;
                    //MultiLine = true;
                    ShowCaption = false;
                }
                field(ReclassItemRestrictionsTxtVar; ReclassItemRestrictionsTxtVar)
                {
                    ApplicationArea = All;
                    //MultiLine = true;
                    ShowCaption = false;
                }
            }
            group(Copyright)
            {
                ShowCaption = false;
                field(GetCopyright; GetStartAndCurrentYear)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Editable = false;
                }
            }
            group("Dynamics 365 Business Central")
            {
                Caption = 'Dynamics 365 Business Central / NAV';
                group(Control605000002)
                {
                    ShowCaption = false;
                    grid(A)
                    {
                        ShowCaption = false;
                        field(BCVersion; GetBCVersion)
                        {
                            Caption = 'Version';
                            ApplicationArea = All;
                            ShowCaption = true;
                            Editable = false;
                            ToolTip = 'Specifies the value of the Version field.';
                        }
                        field(Platform; GetBCPlatformBuild)
                        {
                            Caption = 'Platform';
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the value of the Platform field.';
                        }
                    }
                    grid(B)
                    {
                        ShowCaption = false;
                        field(BCAppBuild; GetBCAppBuild)
                        {
                            Caption = 'Build';
                            ShowCaption = true;
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the value of the Build field.';
                        }
                        field(Application; GetBCApplicationBuild)
                        {
                            Caption = 'Application';
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the value of the Application field.';
                        }
                    }
                }
            }
        }
    }

    var
        Appl: Codeunit "Application System Constants";
        AboutAppTxt: Text;
        WarehouseRestrictionsTxtVar: Text;
        WarehouseItemRestrictionsTxtVar: Text;
        LotRestrictionQualityControlTxtVar: Text;
        VersionTxt: Text;
        ItemRestrictionsTxtVar: Text;
        ReclassItemRestrictionsTxtVar: Text;
        SplitMergeLotNoTxtVar: Text;

    local procedure GetBCVersion(): Text
    begin
        exit(StrSubstNo(Appl.ApplicationVersion));
    end;

    local procedure GetBCAppBuild(): Text
    begin
        exit(StrSubstNo(Appl.ApplicationBuild));
    end;

    local procedure GetBCPlatformBuild(): Text
    begin
        exit(StrSubstNo(Appl.PlatformFileVersion()));
    end;

    local procedure GetBCApplicationBuild(): Text
    begin
        exit(StrSubstNo(Appl.ApplicationBuild()));
    end;

    local procedure GetStartAndCurrentYear(): Text
    var
        StartYear: Integer;
        CurrentYear: Integer;
        CopyrightTxt: Text;
    begin
        StartYear := 2019;
        CurrentYear := Date2DMY(Today, 3);

        if StartYear = CurrentYear then
            CopyrightTxt := StrSubstNo('© %1 SBC Dynamics ERP', CurrentYear)
        else
            CopyrightTxt := StrSubstNo('© %1-%2 SBC Dynamics ERP', StartYear, CurrentYear);

        exit(CopyrightTxt);
    end;

    local procedure GetBCAppversion(): Text
    var
        NavAppInstalledApp: Record "NAV App Installed App";
        Info: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(Info);

        VersionTxt :=
            Format(Info.AppVersion.Major) + '.' +
            Format(Info.AppVersion.Minor) + '.' +
            Format(Info.AppVersion.Build);

        exit(VersionTxt);
    end;

    trigger OnOpenPage()
    begin
        AboutAppTxt :=
          'Acumens Quality Control Management is an app designed to embed quality control processes into inventory management within Business Central. ' +
          'This feature enforces structured quality inspections, record critical metrics, and ensure supplier and manufacturing processes meet compliance and performance standards. ' +
          'It is designed to optimize decision-making and drive continuous improvement across the supply chain.';

        WarehouseRestrictionsTxtVar := '* Warehouse Restrictions';
        WarehouseItemRestrictionsTxtVar := '* Warehouse Item Restrictions';
        LotRestrictionQualityControlTxtVar := '* Lot Restrictions';
        SplitMergeLotNoTxtVar := '* Split - Merge Lot';
        ItemRestrictionsTxtVar := '* Item Restrictions';
        ReclassItemRestrictionsTxtVar := '* Reclass Item Restrictions';
    end;
}

