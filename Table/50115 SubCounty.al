table 50006 SubCounty
{
    fields
    {
        field(1; Code; Code[20])
        {
        }


        field(2; Description; Text[100])
        { }
        field(3; CountyCode; Code[20])
        {
            TableRelation = County.Code where(code = field(CountyCode));
        }

    }

    keys
    {
        key(Key1; Code)
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