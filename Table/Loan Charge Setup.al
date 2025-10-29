table 50030 "Loan Charge Setup"
{
    // version TL2.0

    DrillDownPageID = "Loan Charge Setup";
    LookupPageID = "Loan Charge Setup";

    fields
    {
        field(1; "Code"; Code[20])
        {

        }
        field(2; "Charge Description"; Text[250])
        {

        }
        field(3; "Charge Type"; Option)
        {
            OptionMembers = Salesperson,Kanja,"Others","Sacco";
        }

    }

    keys
    {
        key(Key1; "Code")
        {

        }
    }

    fieldgroups
    {
        fieldgroup(dropDown; "Code", "Charge Description")
        {

        }
    }
}

