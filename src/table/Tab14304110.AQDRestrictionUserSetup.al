table 14304110 "AQD Restriction User Setup"
{
    Caption = 'Restriction User Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;
        }
        field(2; Admin; Boolean)
        {
            Caption = 'Admin';
        }
        field(3; "Allow Release"; Boolean)
        {
            Caption = 'Allow Release';
        }
        field(4; "Allow Reclass"; Boolean)
        {
            Caption = 'Allow Reclass';
        }
        field(5; "Allow Set Restriction"; Boolean)
        {
            Caption = 'Allow Set Restriction';
        }
        field(6; "Allow Split - Merge Lot No."; Boolean)
        {
            Caption = 'Allow Split - Merge Lot No.';
        }
        field(7; "Restriction Code Filter"; Text[1000])
        {
            Caption = 'Restriction Code Filter';
        }
        field(8; "Restriction Status Filter"; Text[1000])
        {
            Caption = 'Restriction Status Filter';
        }
        field(9; "Allow Scrap"; Boolean)
        {
            Caption = 'Allow Scrap';
        }
        field(10; "Allow Update From QA. Bins"; Boolean)
        {
            Caption = 'Allow Update From QA. Bins';
        }
    }
    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }
}
