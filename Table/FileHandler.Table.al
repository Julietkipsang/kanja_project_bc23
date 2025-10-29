table 50025 "File Handler"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "File ID"; Code[90])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(2; "Document Source"; Enum "File Handler")
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "File Name"; Text[90])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "File Extension"; Text[90])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Attached Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; Content; Blob)
        {
            DataClassification = ToBeClassified;

        }


    }

    keys
    {
        key(Key1; "File ID", "Document Source")
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