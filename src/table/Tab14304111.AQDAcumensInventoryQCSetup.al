table 14304111 "AQD Acumens Inventory QC Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Acumens Inventory Quality Control Setup';

    fields
    {
        field(1; "AQD Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "AQD Enabled"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'SBC';
            Caption = 'Enabled';
        }
        field(3; "AQD Log To History"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Log To History';
        }
        field(4; "AQD Setup Deleted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Setup Deleted By';
        }
        field(5; "AQD Setup Initialized By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Setup Initialized By';
        }
    }

    keys
    {
        key(Key1; "AQD Primary Key")
        {
        }
    }
}

