tableextension 50003 "G/L Register Ext" extends "G/L Register"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Computer Posted From"; Code[50])
        {

        }
        field(50001; "Computer IP"; Code[30])
        {

        }
        field(50002; "Mac Address"; Code[50])
        {

        }
        field(50004; "Posting Date"; Date)
        {

        }
        field(50005; "Posting Time"; Time)
        {

        }

    }
    keys
    {
        key(ExtKey; "Journal Batch Name")
        {
            Enabled = true;
        }

        key(ExtKey3; "From Entry No.", "To Entry No.")
        {
            Enabled = true;
        }
    }

}