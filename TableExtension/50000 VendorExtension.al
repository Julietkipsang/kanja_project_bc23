tableextension 50000 VendorExt extends Vendor
{
    // LookupPageId = "Vendor Accounts";
    // DrillDownPageId = "Vendor Accounts";
    fields
    {
        // Add changes to table fields here
        field(50001; OrgCode; Code[50])
        {
            Caption = 'Org Code ';
            TableRelation = Organisation."No.";
            Editable = false;

        }
        field(50002; AgentAccount; Code[50])
        {
            Caption = 'Fintech Account';
            TableRelation = Vendor."No.";
            Editable = false;

        }
        field(50003; FintechAccount; Code[50])
        {
            Caption = 'Fintech Account';
            TableRelation = Vendor."No.";
            Editable = false;

        }
        field(50004; "Vendor Type"; Enum "Customer-Vendor Account Types")
        {
            Caption = 'Vendor Type';

        }
        field(50005; Status; Enum "Ven/Cust Account Status")
        {
            Caption = 'Account Status';

        }
        field(50007; "Source Code"; Code[20])
        {
        }


        //Proc added
        field(50011; "Bank Account"; Code[20])
        {
            //TableRelation b
        }
        field(50012; Checked; Boolean)
        {

        }
        field(50013; "Type"; Option)
        {
            OptionMembers = Sacco,Merchants;
        }
        field(50014; Commision; Boolean)
        { }

        field(50015; MemberNo; code[20])
        {

        }

    }
    keys
    {
        key(keyExt1; Commision)
        {
            Enabled = true;
        }
        key(KeyExt2; OrgCode, Commision)
        {
            Enabled = true;
        }
        key(KeyExt3; OrgCode, Commision, "Vendor Type")
        {
            Enabled = true;
        }
        key(KeyExt4; MemberNo, "Vendor Type")
        {
            Enabled = true;
        }
        key(KeyExt5; MemberNo)
        {
            Enabled = true;
        }

    }



}