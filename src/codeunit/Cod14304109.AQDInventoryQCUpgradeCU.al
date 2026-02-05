codeunit 14304109 "AQD Inventory QC Upgrade CU"
{
    Subtype = Upgrade;

    var
        InventoryQCInstallMgt: Codeunit "AQD Inventory QC Install Mgt";
        Source: Option " ",Install,Upgrade,DefaultSetups;

    trigger OnUpgradePerCompany()
    var

    begin
        Clear(InventoryQCInstallMgt);
        Commit;
        InventoryQCInstallMgt.SetTriggerSourceCodeunit(Source::Upgrade);
        InventoryQCInstallMgt.Run;
        Commit;
    end;
}
