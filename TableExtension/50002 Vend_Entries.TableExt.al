tableextension 50002 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        field(500001; "Transaction Time"; Time)
        {

        }
        field(50002; "Posting Line Type"; Enum "Posting Line Type")
        {
            Editable = false;
        }
    }
  
        // Add changes to table fields here
    keys
    {
        
        // Add changes to keys here
        key(ExtKey1; "Vendor No.", "Posting Date")
        {
            Enabled = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}