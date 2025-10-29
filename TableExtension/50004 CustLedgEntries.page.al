tableextension 50004 "Cust. Ledger Entry Ext" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50001; "Transaction Time"; Time)
        {

        }
        field(50002; "Posting Line Type"; Enum "Posting Line Type")
        {
            Editable = false;
        }
    }
    keys
    {
        key(ExtKey1; "Customer No.")
        {
            Enabled = true;
        }
        key(ExtKey2; "Customer No.", "Posting Date")
        {
            Enabled = true;
        }
        key(ExtKey3; "Customer No.", Reversed)
        {
            Enabled = true;
        }
        key(ExtKey4; "Posting Line Type")
        {
            Enabled = true;
        }
    }
}