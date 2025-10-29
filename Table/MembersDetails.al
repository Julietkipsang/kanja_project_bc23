table 50032 MemberDetails
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Nos; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; MemberNo; Code[30])
        {
            DataClassification = ToBeClassified;

        }
        field(3; EntityCode; code[20])
        {

        }
        field(4; PhoneNo; code[20])
        {

        }
    }

    keys
    {
        key(Key1; Nos)
        {
            Clustered = true;
        }
        key(key2; MemberNo, EntityCode)
        {
            Enabled = true;
        }
        key(key3; PhoneNo, EntityCode)
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