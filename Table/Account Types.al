table 50008 "Account Type"
{
    // version TL2.0

    LookupPageId = "Account Type List";
    DrillDownPageId = "Account Type List";
    fields
    {
        field(1; "Code"; Code[30])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Minimum Balance"; Decimal)
        {
        }
        field(4; "Account Prefix"; Code[20])
        {
        }
        field(5; Type; Enum EntityType)
        {

        }

        field(6; "Posting Group"; Code[30])
        {
            TableRelation = "Vendor Posting Group";

        }

        field(7; "Open Automatically"; Boolean)
        {
        }






    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }

        key(Key2; Type)
        {
            Enabled = true;
        }
        key(key3; "Open Automatically")
        {
            Enabled = true;
        }

    }
    fieldgroups
    {
    }

    var
        Error000: Label 'Please select a different account';
}

