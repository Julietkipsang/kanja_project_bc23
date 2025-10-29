table 50014 "ChangeRequest"
{

    DataCaptionFields = "No.", "Full Name";
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


        field(4; "Date of Registration"; Date)
        {

        }
        field(5; "Phone No."; Code[30])
        {
            ExtendedDatatype = PhoneNo;
        }

        field(6; "Picture 1"; Media)
        {
        }
        field(7; "Picture 2"; Media)
        {
        }
        field(8; "Picture 3"; Media)
        {
        }
        field(9; "Picture 4"; Media)
        {
        }
        field(10; "Post code"; Code[20])
        {
        }
        field(11; Status; Enum "Entity Application Status")
        {
            Editable = false;
        }


        field(12; "Vision"; Code[250])
        {
        }
        field(13; "New PIN No."; Code[20])
        {

        }
        field(14; "Country of Residence"; Code[20])
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
        field(15; ContactPerson; Code[20])
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
        field(16; "E-mail"; Code[90])
        {

        }
        field(17; "Postal Address"; Code[50])
        {
        }
        field(18; "Physical Address"; Code[50])
        {
        }

        field(19; "Created By"; Code[100])
        {
            Editable = false;
        }
        field(20; "Created Date"; Date)
        {
            Editable = false;
        }
        field(21; "Approved By"; Code[100])
        {
            Editable = false;
        }
        field(22; "Approved Date"; Date)
        {
            Editable = false;
        }

        field(23; "Created Time"; Time)
        {
            Editable = false;
        }
        field(24; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(25; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(26; "Last Modified Time"; Time)
        {
            Editable = false;
        }
        field(27; "Last Modified By"; Code[30])
        {
            Editable = false;
        }
        field(28; "Created By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(29; "Created By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(30; "Created By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(31; "Last Modified By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(32; "Last Modified By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(33; "Last Modified By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(34; "Approved By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(35; "Approved By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(36; "Approved By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(37; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(38; "Website"; code[250])
        {
        }
        field(39; Mission; Text[250])
        {
        }

        field(40; "Branch Name"; Code[50])
        {

            CalcFormula = Lookup("Dimension Value".Name WHERE("Global Dimension No." = CONST(1),
                                                               Code = FIELD("Global Dimension 1 Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Full Name"; Code[150])
        {
            trigger OnValidate()
            var
                entityType: Enum EntityType;
            begin
            end;

        }


        field(42; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
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
        field(43; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Editable = false;
        }
        field(44; Town; Code[50])
        {
        }
        field(45; "Longitude"; Code[250])
        {
        }
        field(46; "Lattitude"; Code[250])
        {
        }
        field(47; "GPS Location Name"; Code[100])
        {
        }
        field(48; "Picture Path 1"; Code[250])
        {
        }
        field(49; "Picture Path 2"; Code[250])
        {
        }
        field(50; "Picture Path 3"; Code[250])
        {
        }
        field(51; "Picture Path 4"; Code[250])
        {
        }
        Field(52; "Contact Name"; Code[100])
        {
            Editable = false;
        }

        field(53; "Fintech Name"; text[100])
        {

        }
        field(54; "Agent Name"; text[100])
        {
            Editable = false;
        }

        field(55; "Type Of Sacco"; Option)
        {
            OptionMembers = Bosa,Fosa;

        }
        field(56; "Fintech Account"; Code[100])
        {
            TableRelation = Vendor Where("Vendor Type" = filter("Fintech Account"));
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.Get("Fintech Account") then begin
                    "Fintech Name" := Vendor.Name;
                end;

            end;

        }
        field(57; "Agent Account"; Code[100])
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
        field(58; "Activated By"; Code[100])
        {
            Editable = false;
        }
        field(59; "Activated Date"; Date)
        {
            Editable = false;
        }
        field(60; "Activated Time"; Time)
        {
            Editable = false;
        }

        field(61; "Activated By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(62; "Activated By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(63; "Activated By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(64; "Approver Comments"; Code[100])
        { }
        field(65; "Activator Comments"; Code[100])
        { }

        field(66; "Type"; Enum EntityType)
        {


            trigger OnValidate()
            var
                myInt: Integer;
            begin
                PostingGroup := format(Type);

            end;

        }

        field(67; "PostingGroup"; Code[50])
        {

        }



        field(68; "Approver Reset Comments"; Text[100])
        {

        }
        field(69; "Activator Reset Comments"; Text[100])
        {

        }


        field(70; "Bank Account No"; Code[20])
        {
        }
        field(71; "Bank Name"; Text[30])
        {


        }
        field(72; "Bank Branch Name"; Text[30])
        {


        }

        field(73; applicationNo; Code[100])
        {
            Editable = false;
        }
        field(74; merchantType; Option)
        {
            OptionMembers = "Kanja Merchant","Sacco Merchant";
            Editable = false;

        }
        field(75; MerchantSaccoNo; Code[100])
        {
            Editable = false;
        }

        field(76; MerchantSaccoName; Code[100])
        {
            Editable = false;
        }
        field(77; SaccoNo; Code[100])
        {
            Editable = false;
        }
        field(78; AgentAccount; Code[100])
        {
            Editable = false;
        }
        field(79; AgentName; Code[100])
        {
            Editable = false;
        }
        field(80; OrgCode; code[100])
        {
            TableRelation = Organisation where(Type = field(Type));
            trigger

            OnValidate()
            var
                Organization: Record Organisation;
                EntityServices: Record "Entity Service Subscripted";
                ChangeEntity: Record EntitySubscripted;
                CBSSetup: Record "CBS Setup";
                ChangeEntity1: Record EntitySubscripted;
                NoSeriesManagement: Codeunit "No. Series";
            begin

                ChangeEntity1.Reset();
                ChangeEntity1.DeleteAll();
                Organization.Reset();
                Organization.SetRange("No.", OrgCode);
                if Organization.FindFirst() then begin
                    oldNo := Organization."No.";
                    "Phone No." := Organization."Phone No.";
                    "Full Name" := Organization."Full Name";
                    "E-mail" := Organization."E-mail";
                    Website := Organization.Mission;
                    Vision := Organization.Vision;
                    Type := Organization.Type;
                    "Physical Address" := Organization."Physical Address";
                    County := Organization.County;
                    applicationNo := Organization.applicationNo;
                    "Country of Residence" := Organization."Country of Residence";
                    MerchantSaccoNo := Organization.MerchantSaccoNo;
                    MerchantSaccoName := Organization.MerchantSaccoName;
                    SaccoNo := Organization.SaccoNo;
                    merchantType := Organization.merchantType;
                end;
                EntityServices.Reset();
                EntityServices.SetRange(EntityNo, OrgCode);
                if EntityServices.FindSet() then begin
                    repeat
                        CBSSetup.Reset();
                        CBSSetup.Get();
                        ChangeEntity.Init();
                        ChangeEntity.Nos := NoSeriesManagement.GetNextNo(CBSSetup."MA Individual Nos.", Today, true);
                        ChangeEntity."Application No." := EntityServices."Application No.";
                        ChangeEntity."Account Type" := EntityServices."Account Type";
                        ChangeEntity.Description := EntityServices.Description;
                        ChangeEntity.EntityNo := EntityServices.EntityNo;
                        ChangeEntity.oldStatus := EntityServices.Status;
                        ChangeEntity.Amount := EntityServices.Amount;
                        ChangeEntity.oldMaximumAmount := EntityServices."Maximum Amount";
                        ChangeEntity.oldMinimumAmount := EntityServices."Minimum Amount";
                        ChangeEntity.oldMaximumDaily := EntityServices."Maximum Daily";
                        ChangeEntity."Maximum Amount" := EntityServices."Maximum Amount";
                        ChangeEntity."Minimum Amount" := EntityServices."Minimum Amount";
                        ChangeEntity."Maximum Daily" := EntityServices."Maximum Daily";
                        ChangeEntity.Insert();

                    until EntityServices.Next() = 0;
                end;
            end;
        }
        field(81; oldNo; Code[100])
        {

        }
        field(82; oldName; Code[100])
        {

        }
        field(83; oldKraPin; Code[100])
        {

        }
        field(84; oldPhoneNo; Code[100])
        {

        }
        field(85; oldEntityNo; Code[100])
        {

        }
        field(86; oldServiceCode; Code[100])
        {

        }
        field(87; oldStatus; enum "Service Type Status")
        {

        }
        field(88; newPhoneNo; Code[100])
        {
            ExtendedDatatype = PhoneNo;
            trigger OnValidate()
            var
                CbsSetup: Record "CBS Setup";
                position: Integer;
                FOSAManagement: Codeunit "FOSA Management";
            begin
                IF Rec.newPhoneNo <> '' THEN BEGIN
                    FOSAManagement.IsNumeric(newPhoneNo);
                    FOSAManagement.ValidatePhoneNo(newPhoneNo);
                end;
            END;

        }
        field(89; newEmail; Text[50])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField(newEmail);
            end;
        }
        field(90; NewName; code[100])
        {


        }
        field(91; newSaccoNumber; code[20])
        {

        }

        field(92; MerchantName; Text[100])
        {

        }



    }

    keys
    {
        key(Key1; "No.")
        {
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
           "No.":= NoSeriesManagement.GetNextNo(CBSSetup."MA Individual Nos.",Today,true);
        END;
        "Created By Host IP" := HostIP;
        "Created By Host MAC" := HostMac;
        "Created By Host Name" := HostName;
        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := UserId;
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

        Dimension: record Dimension;
        NoSeriesManagement: Codeunit "No. Series";

        HostMac: Code[50];
        HostName: Code[50];
        HostIP: Code[50];
        RecRef: RecordRef;
        XRecRef: RecordRef;
        UserSetup: Record "User Setup";
        "Trigger": Option OnCreate,OnModify;

        Text001: Label 'Identification Number has been used before for %1.Kindly check your No.';



    var
        CBSSetup: Record "CBS Setup";





}

