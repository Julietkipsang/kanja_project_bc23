table 50038 "Sacco Salesperson"
{
    DataCaptionFields = "Salesperson ID", Name;
    DataClassification = ToBeClassified;
    // DrillDownPageId = "Sacoo Station LookUp";
    // LookupPageId = "Sacoo Station LookUp";
    fields
    {
        field(1; "Salesperson ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(2; "Salesperson No."; Code[20])
        {

        }
        field(3; Name; Text[130])
        {

        }
        field(4; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

        }
        field(5; "Telephone No."; Code[20])
        {

        }

        field(7; "Online Code"; Code[20])
        {
            //  Caption = 'Employer Code';
        }

        field(9; "Online/Factory"; Boolean)
        {
            // Editable = false;
        }
        field(10; "SAP Account"; Boolean)
        {

        }

        field(13; Address; Text[250])
        {

        }
        field(14; "City/Towm"; Text[250])
        {

        }
        field(15; "Receipient"; Text[250])
        {

        }
        field(16; "Non KTDA"; Boolean)
        {

        }
        field(17; "KTDA Account"; Boolean)
        {

        }
        field(18; "No. Series"; Code[20])
        {

        }

        field(20; "Old Station ID"; Code[20])
        {
            Editable = false;
        }
        field(21; "E-mail"; Code[90])
        {

        }
        field(22; "Phone No"; code[20])
        {


        }
    }

    keys
    {
        key(Key1; "Salesperson ID")
        {
            Clustered = true;
        }
        key(Key2; "Online Code", "Online/Factory")
        {
            Enabled = true;
        }
        key(Key3; "Online/Factory")
        {
            Enabled = true;
        }
        key(Key4; "Old Station ID")
        {
            Enabled = true;
        }

    }

    var
        NoSeriesMgt: Codeunit "No. Series";
        CbsSetup: Record "CBS Setup";

    trigger OnInsert()
    begin
        CbsSetup.Reset();
        CbsSetup.Get();
        CbsSetup.TestField("Member Nos.");
       // NoSeriesMgt.InitSeries(CbsSetup."Member Nos.", xRec."No. Series", 0D, "Salesperson ID", "No. Series");
        NoSeriesMgt.GetNextNo(CbsSetup."Member Nos.",Today,true)
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