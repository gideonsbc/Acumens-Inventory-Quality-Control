Codeunit 14304111 "AQD Acumens Quality Control AM"
{

    VAR
        Text001: Label 'You do not have license to access %1.';

    [EventSubscriber(ObjectType::Codeunit, 150, OnAfterLogin, '', false, false)]
    local procedure CU150_onafterlogin()
    var
        AcumensLicensing: Codeunit "AQD Acumens Licensing mgt";
    begin
        if not AcumensLicensing.Checkifappislicensed('5be74ffc-2a5c-4eaa-a4b6-6200b3536cd3', 'Acumens Quality Control Management') then
            DisableAppAccess(true, true);
    end;

    procedure DisableAppAccess(ShowMessage: Boolean; CalledFromLogin: Boolean): Boolean
    var
        AQDAcumensInventoryQCSetup: Record "AQD Acumens Inventory QC Setup";
    begin
        if AQDAcumensInventoryQCSetup.Get() and AQDAcumensInventoryQCSetup."AQD Enabled" then begin
            AQDAcumensInventoryQCSetup."AQD Enabled" := false;
            AQDAcumensInventoryQCSetup.Modify();
            Commit();
        end;

        if ShowMessage and not CalledFromLogin then
            Error(Text001, 'Acumens Quality Control Management');
    end;

    procedure CheckAppAccess(): Boolean
    var
        AcumensLicensing: Codeunit "AQD Acumens Licensing mgt";

    begin
        if not AcumensLicensing.Checkifappislicensed('5be74ffc-2a5c-4eaa-a4b6-6200b3536cd3', 'Acumens Quality Control Management') then
            DisableAppAccess(true, false)
    end;
}
