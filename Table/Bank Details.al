table 50009 BankDetails
{
    //DataClassification = ToBeClassified;

    fields
    {
        field(1; Nos; Integer)
        {
            AutoIncrement = true;

        }
        field(2; ApplicationNo; Code[100])
        {


        }
        field(3; BankNo; Code[100])
        {

            TableRelation = Banks;
            trigger
            OnValidate()
            begin
                banks.Reset();
                banks.SetRange("No.", BankNo);
                if banks.FindFirst() then begin
                    BankName := banks.Name;
                    paybillNumber := banks.paybillNumber;
                end;
            end;

        }
        field(4; BankName; Code[100])
        {

            Editable = false;

        }
        field(5; BankBranchCode; Code[100])
        {
            TableRelation = BranchCodes;
            trigger
            OnValidate()
            begin
                Branches.Reset();
                Branches.SetRange(Codes, BankBranchCode);
                if Branches.FindFirst() then begin
                    BankBranchName := Branches."Branch Name";
                end;

            end;


        }
        field(6; BankBranchName; Code[100])
        {
            // TableRelation = "Bank Branch";
            Editable = false;


        }
        field(7; AccounNo; Code[100])
        {

        }
        field(8; paybillNumber; Code[100])
        {
            Editable = false;

        }
    }


    keys
    {
        key(Key1; Nos, ApplicationNo)
        {
            Clustered = true;
        }
        key(key2; AccounNo)
        {
            Enabled = true;
        }
        key(key3; ApplicationNo)
        {
            Enabled = true;
        }
        key(key4; paybillNumber)
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
        banks: Record Banks;
        Branches: Record BranchCodes;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}