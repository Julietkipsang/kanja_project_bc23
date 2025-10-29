table 50037 "Sacco Application"
{
    // version TL2.0

    DataCaptionFields = "No.", "Full Name";
    DrillDownPageId = "Approved Sacco List";
    LookupPageId = "Approved Sacco List";

    fields
    {
        field(1; "No."; Code[10])
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

        field(4; "Merchant Sacco No"; code[50])
        {
            TableRelation = Organisation."No." where(Type = filter(Sacco));
        }


        field(5; "Date of Registration"; Date)
        {

        }
        field(6; "Merchant Sacco Name"; Text[100])
        {
            Editable = false;
        }
        field(7; "Phone No."; Code[30])
        {
            ExtendedDatatype = PhoneNo;
            trigger OnValidate()
            var
                CbsSetup: Record "CBS Setup";
                position: Integer;
                FOSAManagement: Codeunit "FOSA Management";
            // SubcategoryType: Record "Member Subcategory Type";
            begin
                IF Rec."Phone No." <> '' THEN BEGIN
                    FOSAManagement.IsNumeric("Phone No.");
                    FOSAManagement.ValidatePhoneNo("Phone No.");
                end;
            END;
        }

        field(8; Picture1; Blob)
        {
            Subtype = Bitmap;
        }
        field(9; Picture2; Blob)
        {
            Subtype = Bitmap;
        }


        field(10; "Picture3"; Media)
        {
        }

        field(11; "Post code"; Code[20])
        {
        }
        field(12; Status; Enum "Entity Application Status")
        {
            Editable = false;
        }


        field(13; "Vision"; Code[250])
        {
        }
        field(14; "PIN No."; Code[20])
        {

        }
        field(15; "Country of Residence"; Code[20])
        {

            TableRelation = "Country/Region".Code;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                County := '';
                SubCounty := '';
            end;

        }
        field(16; ContactPerson; Code[20])
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
        field(17; "E-mail"; Text[90])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;


            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-mail");
            end;
        }
        field(18; "Postal Address"; Code[50])
        {
        }
        field(19; "Physical Address"; Code[50])
        {
        }

        field(20; "Created By"; Code[100])
        {
            Editable = false;
        }
        field(21; "Created Date"; Date)
        {
            Editable = false;
        }
        field(22; "Approved By"; Code[100])
        {
            Editable = false;
        }
        field(23; "Approved Date"; Date)
        {
            Editable = false;
        }

        field(24; "Created Time"; Time)
        {
            Editable = false;
        }
        field(25; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(26; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(27; "Last Modified Time"; Time)
        {
            Editable = false;
        }
        field(28; "Last Modified By"; Code[30])
        {
            Editable = false;
        }
        field(29; "Created By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(30; "Created By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(31; "Created By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(32; "Last Modified By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(33; "Last Modified By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(34; "Last Modified By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(35; "Approved By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(36; "Approved By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(37; "Approved By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(38; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(39; "Website"; code[250])
        {
        }
        field(40; Mission; Text[250])
        {
        }


        field(41; "Branch Name"; Code[50])
        {

            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = CONST(1),
                                                               Code = FIELD("Global Dimension 1 Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; "Full Name"; Code[150])
        {
            trigger OnValidate()
            var

            begin


                "Full Name" := UpperCase("Full Name");
            end;

        }


        field(43; "Global Dimension 1 Code"; Code[20])
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
        field(44; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Editable = false;
        }



        field(45; Town; Code[50])
        {
        }
        field(46; "Longitude"; Code[250])
        {
        }
        field(47; "Lattitude"; Code[250])
        {
        }

        field(48; "Sacco Account No"; Code[50])
        {
        }

        field(49; "GPS Location Name"; Code[100])
        {
        }

        field(50; "Picture 1Path"; Code[250])
        {
        }
        field(51; "Picture  2 Path"; Code[250])
        {
        }
        field(52; "Picture3 Path"; Code[250])
        {
        }
        field(53; "Picture  4 Path"; Code[250])
        {
        }


        Field(54; "Contact Name"; Code[100])
        {
            Editable = false;
        }



        field(55; "Fintech Name"; text[100])
        {
            // TableRelation = Salutation;e
        }
        field(56; "Agent Name"; text[100])
        {
            Editable = false;
        }


        field(57; "Type Of Sacco"; Option)
        {
            OptionMembers = Bosa,Fosa;

        }
        field(58; "Fintech Account"; Code[100])
        {
            TableRelation = Organisation Where(Type = filter("Fintech"));
            Editable = false;
            trigger OnValidate()
            var
                Organization: Record Organisation;
            begin
                if Organization.Get("Fintech Account") then begin
                    "Fintech Name" := Organization."Full Name";
                end;
            end;

        }
        field(59; "Agent Account"; Code[100])
        {
            TableRelation = Vendor Where("Vendor Type" = filter("Agent Account"));
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.Get("Agent Account") then begin
                    "Agent Name" := Vendor.Name;

                end;

            end;
        }



        field(60; "Activated By"; Code[100])
        {
            Editable = false;
        }
        field(62; "Activated Date"; Date)
        {
            Editable = false;
        }
        field(63; "Activated Time"; Time)
        {
            Editable = false;
        }

        field(64; "Activated By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(65; "Activated By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(66; "Activated By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(67; "Approver Comments"; Code[100])
        { }
        field(68; "Activator Comments"; Code[100])
        { }

        field(69; Type; Enum EntityType)
        {

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                PostingGroup := format(Type);

            end;

        }

        field(70; "PostingGroup"; Code[50])
        {

        }

        field(71; "Approver Reset Comments"; Text[100])
        {

        }
        field(72; "Activator Reset Comments"; Text[100])
        {

        }


        field(74; "Merchant Type"; Option)
        {
            OptionMembers = "Kanja Merchant","Sacco Merchant";
            //OptionCaption = 'Kanja Merchant','Sacco Merchant';

        }


        field(75; AgencyTarget; Code[100])
        {

        }
        field(76; settlementType; Enum settlementType)
        {

        }
        field(77; MerchantName; Text[100])
        {

        }
        field(78; "Bank Account No"; Code[20])
        {
        }
        field(79; "Bank Name"; Text[30])
        {


        }
        field(80; "Bank Branch Name"; Text[30])
        {

        }
        field(81; "Alterntive Phone No."; Code[20])
        {
            ExtendedDatatype = PhoneNo;
            trigger OnValidate()
            var
                CbsSetup: Record "CBS Setup";
                position: Integer;
                FOSAManagement: Codeunit "FOSA Management";
            // SubcategoryType: Record "Member Subcategory Type";
            begin
                IF Rec."Phone No." <> '' THEN BEGIN
                    FOSAManagement.IsNumeric("Alterntive Phone No.");
                    FOSAManagement.ValidatePhoneNo("Alterntive Phone No.");
                end;
            END;

        }
        field(82; "CEO Name"; Text[40])
        {

        }
        field(83; "Chairmans Name"; Text[50])
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
        key(key3; "PIN No.")
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
        "Created By" := UserId;
        "Date of Registration" := Today;

        if UserSetup.Get(UserId) then begin
            if Dimension.Get("Global Dimension 1 Code") then
                "Branch Name" := Dimension.Name;

        end;
        Validate("Global Dimension 1 Code");
        CalcFields("Branch Name");
        EntitySubscription.Init();
        EntitySubscription."Application No." := "No.";
        EntitySubscription.Insert();

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
        Dimension: record Dimension;
        NoSeriesManagement: Codeunit "No. Series";
        HostMac: Code[50];
        HostName: Code[50];
        HostIP: Code[50];
        RecRef: RecordRef;
        XRecRef: RecordRef;
        UserSetup: Record "User Setup";
        EntitySubscription: Record "Entity Service Subscription";
        "Trigger": Option OnCreate,OnModify;
        Text001: Label 'Identification Number has been used before for %1.Kindly check your No.';

    var
        CBSSetup: Record "CBS Setup";





}

