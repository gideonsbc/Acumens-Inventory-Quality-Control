Codeunit 14304111 "AQD Acumens Quality Control AM"
{
    var
        Text001: Label 'You do not have license to access %1.';

    [EventSubscriber(ObjectType::Codeunit, 150, OnAfterLogin, '', false, false)]
    local procedure CU150_onafterlogin()
    var
    begin
        if not AcumensLicensing.Checkifappislicensed(appid, appname) then
            DisableAppAccess(true, true);
    end;
    procedure DisableAppAccess(ShowMessage: Boolean; CalledFromLogin: Boolean): Boolean
    var
        AQAcumensDefectiveInventoryMgtSetup: Record "AQD Acumens Inventory QC Setup";
        UnlicensedAppusers: Record "AQD AL Unlicensed App Users";
    begin

        if AQAcumensDefectiveInventoryMgtSetup.Get() and AQAcumensDefectiveInventoryMgtSetup."AQD Enabled" then begin
            UnlicensedAppusers.reset();
            UnlicensedAppusers.SetRange("User ID", UserId);
            if not UnlicensedAppusers.FindFirst() then begin
                UnlicensedAppusers.Init();
                UnlicensedAppusers."User ID" := UserId;
                UnlicensedAppusers."App ID" := appid;
                UnlicensedAppusers."App Name" := appname;
                UnlicensedAppusers.Insert();
                Commit();
            end;

        end;
        if ShowMessage and not CalledFromLogin then
            Error(Text001, 'Acumens Defective Inventory Management');
    end;
    procedure enableAppAccess(ShowMessage: Boolean; CalledFromLogin: Boolean): Boolean
    var
        AQAcumensDefectiveInventoryMgtSetup: Record "AQD Acumens Inventory QC Setup";
        UnlicensedAppusers: Record "AQD AL Unlicensed App Users";
    begin
        if AQAcumensDefectiveInventoryMgtSetup.Get() and (AQAcumensDefectiveInventoryMgtSetup."AQD enabled") then begin
            UnlicensedAppusers.reset();
            UnlicensedAppusers.SetRange("User ID", UserId);
            UnlicensedAppusers.DeleteAll();
        end;

        //if ShowMessage and not CalledFromLogin then
        /// Error(Text002, 'Acumens e-Mailing');
    end;

    procedure CheckAppAccess(): Boolean
    var
    begin
        if not AcumensLicensing.Checkifappislicensed(appid, appname) then
            DisableAppAccess(true, false)
    end;
    var
        appid: Label '5be74ffc-2a5c-4eaa-a4b6-6200b3536cd3';
        appname: Label 'Acumens Defective Inventory Management';
        AcumensLicensing: Codeunit "AQD L Acumens Licensing Mgt";
}
