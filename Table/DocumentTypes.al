table 50020 ViewDocument
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Nos; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; ApplicationNo; Code[100])
        {

        }
        field(3; DocumentType; Code[100])
        {

        }
        field(4; DocumentPath; Code[100])
        {


        }
        field(5; DocumentId; Code[100])
        {

        }


    }

    keys
    {
        key(Key1; Nos)
        {
            Clustered = true;
        }
        key(key2; ApplicationNo, DocumentType)
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