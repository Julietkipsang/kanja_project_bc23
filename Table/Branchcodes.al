table 50012 BranchCodes
{
    // version TL2.0


    fields
    {
        field(1; "Codes"; Code[10])
        {
        }

        field(2; "Branch Name"; Text[100])
        {
        }
        field(3; "BranchCode"; Code[30])
        {

        }

    }

    keys
    {
        key(Key1; Codes, BranchCode)
        {
        }


    }



    var
        Banks: Record Banks;
}

