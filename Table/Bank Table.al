table 50010 Banks
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[100])
        {

        }
        field(2; Name; Text[150])
        {
        }
        field(3; "Global Dimension 1 Code"; Text[150])
        {
        }
        field(4; paybillNumber; Code[100])
        {

        }
        field(5; "Bank Branches"; Code[50])
        {

        }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }

    }

    fieldgroups
    {
        //    fieldgroup(DropDown; "No.", Name)
        //    {
        //    }
    }
}

