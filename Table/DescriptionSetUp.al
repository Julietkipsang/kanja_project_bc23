table 50018 DescriptionSetUp
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; DocumentSource; Enum DocumentSource)
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[250])
        {

        }
        field(3; ResponseCode; Code[20])
        {

        }
    }

    keys
    {
        key(Key1; DocumentSource)
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