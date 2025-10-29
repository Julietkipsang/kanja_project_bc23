table 50026 Fintechs
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; fintechCode; Code[100])
        {
            TableRelation = Organisation where(Type = filter('Fintech'));

            trigger
            OnValidate()
            begin
                Org.Reset();
                Org.SetRange("No.", fintechCode);
                if Org.FindFirst() then begin
                    FintechName := Org."Full Name";
                end;
            end;

        }
        field(2; applNo; Code[100])
        {

        }
        field(3; receiveDeposit; Boolean)
        {

        }
        field(4; orgCode; Code[100])
        {

        }
        field(5; FintechName; Code[100])
        {

        }
        field(6; "Fintech Type"; Enum "Fintech Type")
        {

        }
        field(7; EntryNo; Integer)

        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; EntryNo, applNo)
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
        Org: Record Organisation;

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