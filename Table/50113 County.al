table 50005 County
{
    fields
    {
        field(1; Code; Code[20])
        {
        }

        field(2; Description; Text[100])
        { }
        field(3; CountryCode; Code[20])
        {
            TableRelation = "Country/Region".Code where(code = field(CountryCode));
        }

    }

    keys
    {
        key(Key1; Code, CountryCode)
        {
            Clustered = true;
        }
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