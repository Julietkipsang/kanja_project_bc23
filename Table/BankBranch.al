table 50011 "Bank Branch"
{
    // version TL2.0


    fields
    {
        field(1; "Codes"; Code[10])
        {
            TableRelation = BranchCodes;
        }

        field(2; "Branch Name"; Text[100])
        {
        }

        field(3; "Bank Name"; Text[100])
        {
        }
        field(4; Banks; Text[150])
        {
            TableRelation = Banks.Name where(Name = field(Banks));
        }
    }

    keys
    {
        key(Key1; Codes, Banks)
        {
        }

    }



    var
        Banks: Record Banks;
}

