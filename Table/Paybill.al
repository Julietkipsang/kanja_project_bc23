table 50034 Paybill
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Nos; Integer)
        {
            AutoIncrement = true;

        }
        field(2; applNo; Code[100])
        {

        }
        field(3; paybillNo; Code[100])
        {

        }
        field(4; accountNo; Code[100])
        {

        }
        field(5; paybillName; Code[100])
        {

        }
    }

    keys
    {
        key(Key1; Nos, applNo)
        {
            Clustered = true;
        }
        key(Key2; applNo)
        {
            Enabled = true;
        }
        key(key3; paybillNo)
        {
            Enabled = true;
        }
    }

    fieldgroups
    {

    }

    var
        myInt: Integer;

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