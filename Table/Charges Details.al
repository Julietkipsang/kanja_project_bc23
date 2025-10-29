table 50015 " Charge Details"
{
    // version TL2.0


    fields
    {

        field(1; "EntryNo"; Integer)
        {
            NotBlank = true;
            AutoIncrement = true;

        }
        field(3; "Charge Code"; Code[50])
        {
            //Editable = false;
        }

        field(4; "Calculation Mode"; Option)
        {
            OptionCaption = '% of Transcation,Flat Amount,Range';
            OptionMembers = "% of Transcation","Flat Amount",Range;
        }
        field(5; ChargeValue; Decimal)
        {
        }
        field(6; "Received Amount"; Decimal)
        {

        }

        field(7; DocNo; code[50])
        {

        }
        field(8; "Sending Sacco"; Code[50])
        {

        }
        field(9; "Receiving Sacco"; Code[50])
        {

        }
        field(10; "Transaction Description"; Text[100])
        {

        }
        field(11; "Sender Phone No"; Code[15])
        {

        }
        field(12; "Entity No."; Code[20])
        {

        }
        field(13; "Receipt No."; Code[20])
        {

        }
        field(14; SalespersonCode; Code[20])
        {

        }
        field(15; transactionDate; Date)
        {

        }
        field(16; transactionTime; Time)
        {

        }


    }

    keys
    {
        key(Key1; EntryNo, "Charge Code")
        {
            Clustered = true;
        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "Charge Code")
        {
        }
    }

    var
        LoanChargeSetup1: Record "Loan Charge Setup";
}

