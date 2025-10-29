table 50007 "Account Opening"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[30])
        {
            Editable = false;
            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; "Account Type"; Code[20])
        {
            TableRelation = "Account Type".Code where(Type = filter(Sacco));

            trigger OnValidate()
            begin
                AccountType.RESET;
                AccountType.GET("Account Type");
                Description := AccountType.Description;


            end;
        }
        field(3; Description; Code[100])
        {
            // Editable = false;
        }
        field(4; "Sacco No."; Code[30])
        {
            TableRelation = "Sacco Application"."No." where(Type = filter(Sacco));

            trigger OnValidate()
            var
                SaccoApp: Record "Sacco Application";
            begin
                SaccoApp.RESET;
                SaccoApp.SETRANGE("No.", "Sacco No.");
                IF SaccoApp.FINDFIRST THEN BEGIN
                    "Sacco Name" := SaccoApp."Full Name";

                    //ValidateAccountType();
                END;

            end;
        }
        field(5; "Sacco Name"; Text[40])
        {
            Editable = false;
        }
        field(6; "Account No."; Code[30])
        {
            Editable = false;
        }
        field(7; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(8; "Created By"; Code[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                CLEAR(RecRef);
                CLEAR(XRecRef);
                RecRef.GETTABLE(Rec);
                XRecRef.GETTABLE(xRec);

            end;
        }
        field(9; "Created Date"; Date)
        {
            Editable = false;
        }
        field(10; "Created Time"; Time)
        {
            Editable = false;
        }
        field(26; "Global Dimension 1 Code"; Code[20])
        {
            Editable = false;
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));


        }
        field(11; "No. Series"; code[50])
        {

        }
        field(12; "Approved Date"; Date)
        {

        }
        field(13; "Approved Time"; Time)
        {

        }
        field(27; "Fintech Account"; Code[50])
        {
            TableRelation = Vendor."No." where("Vendor Type" = filter('Fintech Account'));
            trigger OnValidate()
            var
                vendor: Record Vendor;
            begin
                if (vendor.Get("Fintech Account")) then
                    "Fintech Name" := Vendor.Name;
            end;
        }

        field(28; "Fintech Name"; Text[100])
        {
            Editable = false;
        }

        field(29; "Create Float Account"; Boolean)
        {

        }




    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;

        }

    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CBSSetup.GET;
        IF "No." = '' THEN BEGIN
           "No.":= NoSeriesManagement.GetNextNo(CBSSetup."Account Opening Nos.", TODAY, true)
        END;
        // GetHostInfo;

    end;

    trigger OnModify()
    begin

    end;






    var
        NoSeriesManagement: Codeunit "No. Series";
        FOSAManagement: Codeunit "FOSA Management";
        CBSSetup: Record "CBS Setup";
        AccountType: Record "Account Type";

        AccountNo: Code[20];
        Vendor: Record Vendor;
        Text004: Label 'Account %1 has been created.';
        InsuffBalanceErr: Label '%1 cannot exceed %2';
        NotSavingsAccErr: Label '%1 must be a Savings Account';
        RecRef: RecordRef;
        XRecRef: RecordRef;
        "Trigger": Option OnCreate,OnModify;
        "No. Of Days": DateFormula;

        HostMac: Text[50];
        HostName: Text[50];
        HostIP: Text[50];

}

