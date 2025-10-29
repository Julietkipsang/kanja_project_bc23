table 50100 "FOSA Cue"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Code[250])
        {

            DataClassification = ToBeClassified;
        }
        field(2; "Sacco-Active"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Organisation);



        }

        field(3; "Registered members"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Members);

        }
        field(4; "Fintech"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Organisation where(Type = FILTER('Fintech')));

        }
        field(5; "Agents"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Organisation where(Type = FILTER('Acquirer')));
        }
        field(6; "Merchants"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Organisation where(Type = FILTER('Merchants')));

        }

        field(20; "TotalOrdinarySavings"; Decimal)
        {


        }
        field(21; "TotalDeposits"; Integer)
        {


        }
        field(22; "TotalLoans"; Decimal)
        {


        }

        field(23; "TotalShares"; Decimal)
        {


        }
        field(24; "TotalFixedDeposits"; Decimal)
        {


        }




    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }
}