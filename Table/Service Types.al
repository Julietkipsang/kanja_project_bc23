table 50000 "Services Type"
{
    // version TL2.0

    LookupPageId = "Service Type List";
    DrillDownPageId = "Service Type List";
    fields
    {
        field(1; "Code"; Code[30])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Maximum Amount"; Decimal)
        {
        }
        field(4; "Maintenance Fee"; Decimal)
        {
        }

        field(5; Active; Boolean)
        {
        }
        field(6; "Minimum  Amount"; Decimal)
        {

        }
        field(7; "Maximum Daily  Amount"; Decimal)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if Rec."Maximum Daily  Amount" < rec."Maximum Amount" then
                    Error('Maximum Daily Cannot be Less than Maximum per transcation Amount');
            end;

        }
        field(8; "Open Automatically"; Boolean)
        {
        }
        field(9; "Withdrawals Per Year"; Integer)
        { }
        field(10; isWallet; Boolean)
        { }
        field(11; "Start Date"; Date)
        {
        

        }
        field(12; "End Date"; Date)
        {

        }


    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }

    }

    fieldgroups
    {
    }

    var
        Error000: Label 'Please select a different account';
}

