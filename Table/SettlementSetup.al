table 50041 "SettlementTypeCharges"
{

    fields
    {

        field(1; "Code"; Enum settlementType)
        {

        }

        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Calculation Method"; Option)
        {
            OptionMembers = "Based Flat Amount","Based on %",Range;
        }
        field(4; settlementTypes; Enum settlementType)
        {


        }

        field(5; settlementDescription; Text[100])
        {


        }
        field(6; Value; Decimal)
        {

        }
        field(7; Type; Option)
        {
            OptionCaption = ',KanjaCharges,ThirdPartyCharges';
            OptionMembers = ,KanjaCharges,ThirdPartyCharges;


        }
    }

    keys
    {
        key(Key1; "Line No.", settlementTypes)
        {
            Clustered = true;
        }

        key(key3; settlementTypes)
        {
            Enabled = true;
        }
        //  

    }

    fieldgroups
    {
    }

    var
        Error000: Label 'Please select a different account';
}

