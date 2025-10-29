table 50029 KanjaSetUps
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Type; Enum "Kanja Setups")
        {
            DataClassification = ToBeClassified;


        }
        field(2; Description; Text[30])
        {

        }
    }

    keys
    {
        key(Key1; Type)
        {
            Clustered = true;
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