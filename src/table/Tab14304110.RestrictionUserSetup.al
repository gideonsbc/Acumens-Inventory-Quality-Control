table 14304110 "Restriction User Setup"
{
    DataClassification = ToBeClassified;

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
        field(2; "Admin"; Boolean)
        {
        }
        field(3; "Allow Release"; Boolean)
        {
        }
        field(4; "Allow Reclass"; Boolean)
        {
        }
        field(5; "Allow Set Restriction"; Boolean)
        {
        }
        field(6; "Allow Split - Merge Lot No."; Boolean)
        {
        }
        field(7; "Restriction Code Filter"; Text[1000])
        {
        }
        field(8; "Restriction Status Filter"; Text[1000])
        {
        }
        field(9; "Allow Scrap"; Boolean)
        {
        }
        field(10; "Allow Update From QA. Bins"; Boolean)
        {
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
