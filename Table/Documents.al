table 50019 DocumentTypes
{
    DataClassification = ToBeClassified;
    LookupPageId = DocumentsList;

    fields
    {
        field(1; Nos; Code[100])
        {
            DataClassification = ToBeClassified;


        }
        field(2; codes; Integer)
        {
            AutoIncrement = true;

        }
        field(3; DocumentType; Enum "Document Types")
        {
           // OptionCaption = ' ,Kra Pin,Sasra, BusinessPermits,Kanja Contracts,Other Compliance, Any other Doc';
           // OptionMembers = " ","Kra Pin","Sasra","BusinessPermits","Kanja Contracts","Other Compliance","Any other Doc";
            trigger
            OnValidate()
            begin
                DocumentDescription := Format(DocumentType);
            end;

        }
        field(4; DocumentDescription; Text[250])
        {
            Caption = 'Document Description';
            Editable = false;
        }
        field(5; RequiresAttachment; Boolean)
        {

        }
    }

    keys
    {
        key(Key1; DocumentType, codes)
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
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit "No. Series";

    trigger OnInsert()
    begin
        CBSSetup.Reset();
        CBSSetup.GET;

        Nos := NoSeriesManagement.GetNextNo(CBSSetup."MA Individual Nos.", Today, true);
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