table 50021 DocumentTypesSetup
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Nos; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; EntityType; Enum EntityType)
        {
            
            

        }
        // field(3; DocumentType; Option)
        // {
        //     OptionCaption = 'Kra Pin,Sasra, BusinessPermits,Kanja Contracts,Other Compliance, Any other Doc';
        //     OptionMembers = "Kra Pin","Sasra","BusinessPermits","Kanja Contracts","Other Compliance","Any other Doc";

        // }
        // field(4; DocumentDescription; Text[250])
        // {
        //     Caption = 'Document Description';
        // }
        // field(5; RequiresAttachment; Boolean)
        // {

        // }
    }

    keys
    {
        key(Key1; Nos)
        {
            Clustered = true;
        }
        key(key2;EntityType)
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