table 50033 "Organisation"
{
    DataCaptionFields = "No.", "Full Name";
    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; County; Code[20])
        {
            TableRelation = County.Code where(CountryCode = field("Country of Residence"));
            trigger OnValidate()
            var
            begin
                SubCounty := '';
                IF Rec."Country of Residence" = '' then
                    Error('Kindly Provide Country code');
            end;

        }
        field(3; "SubCounty"; Code[20])
        {
            TableRelation = SubCounty.Code where(CountyCode = field(County));
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if Rec.County = '' then
                    Error('Kindly Provide County code');
            end;
        }
        field(4; "Date of Registration"; Date)
        {

        }

        field(5; "Phone No."; Code[30])
        {
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            var
            // SubcategoryType: Record "Member Subcategory Type";
            begin
                IF Rec."Phone No." <> '' THEN BEGIN

                end;
            END;
            // end;
        }


        field(6; Picture1; Media)
        {
        }
        field(7; Picture2; Media)
        {
        }
        field(8; "Picture3"; Media)
        {
        }
        field(9; "Post code"; Code[20])
        {
        }
        field(10; Status; Enum "Entity Application Status")
        {
            Editable = false;
        }


        field(11; "Vision"; Code[250])
        {
        }
        field(12; "PIN No."; Code[20])
        {

        }
        field(13; "Country of Residence"; Code[20])
        {
            InitValue = Kenya;
            TableRelation = "Country/Region".Code;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                County := '';
                SubCounty := '';
            end;
        }
        field(14; ContactPerson; Code[20])
        {
            TableRelation = Contact."No.";
            trigger OnValidate()
            var
                contact: Record Contact;
            begin
                if contact.get(ContactPerson) then
                    "Contact Name" := contact.Name;
            end;
        }
        field(15; "E-mail"; Code[90])
        {
            ExtendedDatatype = EMail;
            trigger OnValidate()
            var

            begin
                IF "E-mail" <> '' THEN BEGIN

                END;
            end;
        }
        field(16; "Postal Address"; Code[50])
        {
        }
        field(17; "Physical Address"; Code[50])
        {
        }

        field(18; "Created By"; Code[100])
        {
            Editable = false;
        }
        field(19; "Created Date"; Date)
        {
            Editable = false;
        }
        field(20; "Approved By"; Code[100])
        {
            Editable = false;
        }
        field(21; "Approved Date"; Date)
        {
            Editable = false;
        }

        field(22; "Created Time"; Time)
        {
            Editable = false;
        }
        field(23; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(24; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(25; "Last Modified Time"; Time)
        {
            Editable = false;
        }
        field(26; "Last Modified By"; Code[30])
        {
            Editable = false;
        }
        field(27; "Created By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(28; "Created By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(29; "Created By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(30; "Last Modified By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(31; "Last Modified By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(32; "Last Modified By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(33; "Approved By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(34; "Approved By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(35; "Approved By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(36; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(37; "Website"; code[250])
        {
        }
        field(38; Mission; Text[250])
        {
        }


        field(39; "Branch Name"; Code[50])
        {

            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = CONST(1),
                                                               Code = FIELD("Global Dimension 1 Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Full Name"; Code[150])
        {
            trigger OnValidate()
            var

            begin
                // IF Rec.Type = Rec.Type::" " then
                Error('Kindly Select Application Type');
                "Full Name" := UpperCase("Full Name");
            end;

        }


        field(41; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            //  Editable = false;

            trigger OnValidate()
            var
                DimValue: Record "Dimension Value";
                Error000: Label 'No member can be registered to this branch code!';
            begin
                DimValue.Reset();
                DimValue.SetRange("Global Dimension No.", 1);
                DimValue.SetRange(Code, "Global Dimension 1 Code");
                if DimValue.FindFirst() then begin
                    if "Global Dimension 1 Code" = '01' then
                        Error(Error000);
                    "Branch Name" := DimValue.Name;
                end;
            end;
        }
        field(42; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Editable = false;
        }


        field(43; Town; Code[50])
        {
        }
        field(44; "Longitude"; Code[250])
        {
        }
        field(45; "Lattitude"; Code[250])
        {
        }
        field(46; "Picture Path 1"; Code[250])
        {
        }
        field(47; "Picture Path 2"; Code[250])
        {
        }
        field(48; "Picture Path 3"; Code[250])
        {
        }

        Field(49; "Contact Name"; Code[100])
        {
            Editable = false;
        }
        field(50; "GPS Location Name"; Text[30])
        {

        }

        field(51; "Fintech Name"; text[100])
        {
            // TableRelation = Salutation;e
        }
        field(52; "Agent Name"; text[100])
        {
            Editable = false;
        }

        field(53; "Type Of Sacco"; Option)
        {
            OptionMembers = Bosa,Fosa;

        }
        field(54; "Fintech Account"; Code[100])
        {
            TableRelation = Vendor Where("Vendor Type" = filter('Fintech Account'));
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.Get("Fintech Account") then begin
                    "Fintech Name" := Vendor.Name;
                end;

            end;

        }
        field(55; "Agent Account"; Code[100])
        {
            TableRelation = Vendor Where("Vendor Type" = filter('Agent Account'));
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.Get("Agent Account") then begin
                    "Agent Name" := Vendor.Name;

                end;

            end;


        }




        field(56; "Activated By"; Code[100])
        {
            Editable = false;
        }
        field(57; "Activated Date"; Date)
        {
            Editable = false;
        }
        field(58; "Activated Time"; Time)
        {
            Editable = false;
        }

        field(59; "Activated By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(60; "Activated By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(61; "Activated By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(62; "Approver Comments"; Code[100])
        { }
        field(63; "Activator Comments"; Code[100])
        { }

        field(64; "Type"; Enum EntityType)
        {

            //OptionMembers = " ",Sacco,Fintech,Merchant,Agency,MFI,Banks;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                PostingGroup := format(Type);

            end;

        }

        field(65; "PostingGroup"; Code[50])
        {

        }


        field(66; "Approver Reset Comments"; Text[100])
        {

        }
        field(67; "Activator Reset Comments"; Text[100])
        {

        }

        field(68; "Bank Account No"; Code[20])
        {
        }
        field(69; "Bank Name"; Text[30])
        {


        }
        field(70; "Bank Branch Name"; Text[30])
        {

        }
        field(71; applicationNo; Code[100])
        {

        }
        field(72; merchantType; Option)
        {
            OptionMembers = "Kanja Merchant","Sacco Merchant";

        }
        field(73; MerchantSaccoNo; Code[100])
        {

        }
        field(74; MerchantSaccoName; Code[100])
        {

        }
        field(75; SaccoNo; Code[100])
        {

        }
        field(76; AgentAccount; Code[100])
        {

        }
        field(77; AgentName; Code[100])
        {

        }
        field(78; AgencyTarget; Code[200])
        {

        }
        field(79; MerchantName; Text[100])
        {

        }



    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Full Name")
        {
            Enabled = true;
        }
        key(key3; merchantType, "No.")
        {
            Enabled = true;
        }
        key(key4; Type, "No.")
        {
            Enabled = true;
        }
        key(key5; "Phone No.")
        {
            Enabled = true;
        }
        key(key6; SaccoNo)
        {
            Enabled = true;
        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Full Name", "Global Dimension 1 Code")
        {
        }
    }

    trigger OnInsert()
    begin
        CBSSetup.Reset();
        CBSSetup.GET;
        IF "No." = '' THEN BEGIN
           // NoSeriesManagement.InitSeries(CBSSetup."MA Individual Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
            "No.":=NoSeriesManagement.GetNextNo(CBSSetup."MA Individual Nos.",Today,true)
        END;
        "Created By Host IP" := HostIP;
        "Created By Host MAC" := HostMac;
        "Created By Host Name" := HostName;
        "Created Date" := TODAY;
        "Created Time" := TIME;
        if UserSetup.Get(UserId) then begin
            if Dimension.Get("Global Dimension 1 Code") then
                "Branch Name" := Dimension.Name;

        end;
        Validate("Global Dimension 1 Code");
        CalcFields("Branch Name");
    end;

    trigger OnModify()
    begin
        "Last Modified By Host IP" := HostIP;
        "Last Modified By Host MAC" := HostMac;
        "Last Modified By Host Name" := HostName;
        "Last Modified Date" := TODAY;
        "Last Modified Time" := TIME;
    end;

    var
        //  Member: Record Member;
        Dimension: record Dimension;
        NoSeriesManagement: Codeunit "No. Series";
        //CBSSetup: Record "CBS Setup";
        HostMac: Code[50];
        HostName: Code[50];
        HostIP: Code[50];
        RecRef: RecordRef;
        XRecRef: RecordRef;
        UserSetup: Record "User Setup";
        "Trigger": Option OnCreate,OnModify;
        // B/anks: Record Banks;
        // BankBranch: Record "Bank Branch";

        Text001: Label 'Identification Number has been used before for %1.Kindly check your No.';
    // FOSAManagement: Codeunit "FOSA Management";


    var
        CBSSetup: Record "CBS Setup";





}

