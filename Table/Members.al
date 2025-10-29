table 50031 Members
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Kanja Id"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; IdNumber; code[20])
        {

        }
        field(3; Email; Code[80])
        {

        }
        field(4; EntityCode; code[20])
        {

        }
        field(5; Gender; Text[20])
        {


        }
        field(6; DateOfBirth; Date)
        {

        }
        field(7; kraPin; Code[30])
        {

        }
        field(8; alternativePhoneNo; code[20])
        {

        }
        field(9; "Mobile Phone No"; code[20])
        {

        }
        field(10; firstName; code[100])
        {

        }
        field(11; "Date Registered"; Date)
        {

        }
        field(12; "Time Regsitered"; Time)
        {

        }
        field(13; "Sacco Name"; Code[30])
        {


        }
        field(14; Status; Enum "Member Status")
        {

        }
        field(15; surnameName; code[100])
        {

        }
        field(17; accountNo; code[100])
        {

        }
        field(18; "saccoMemberNo"; code[100])
        {

        }
        field(19; middleName; code[100])
        {

        }
        field(20; county; code[100])
        {

        }
        field(21; nationality; code[100])
        {

        }
        field(22; "Confirmed Terms"; Boolean)
        {

        }

    }

    keys
    {
        key(Key1; "Kanja Id")
        {
            Clustered = true;
        }
        key(Key2; IdNumber)
        {
            Enabled = true;
        }
        key(key3; "Mobile Phone No", EntityCode)
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