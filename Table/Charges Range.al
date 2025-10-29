table 50016 "Charges Range"
{
    // version TL2.0



    fields
    {
        field(1; "Entry No."; Integer)
        {
            NotBlank = true;
            AutoIncrement = true;

        }
        field(2; "Minimum Amount"; Decimal)
        {


        }
        field(3; "Maximum Amount"; Decimal)
        {


        }
        field(4; "Value Amount"; Decimal)
        {


        }
        field(5; "Charge Code"; Code[50])
        {
            TableRelation = "Charges Table".Code;
        }
    }
    keys
    {
        key(Key1; "Entry No.", "Charge Code")
        {
            Clustered = true;

        }
        key(key2; "Charge Code")
        {

            Enabled = true;
        }

    }
}