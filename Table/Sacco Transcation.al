table 50039 "Sacco Transaction Management"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Receipt No", "Transaction Description";
    fields
    {
        field(1; "Receipt No"; Code[20])
        {
            Editable = false;

        }
        field(2; "Associated Bank Account"; Code[20])
        {

            TableRelation = Vendor where("Vendor Type" = FILTER('Sacco Account'), Commision = const(false));
            trigger OnValidate()
            var
                vendor: Record Vendor;
            begin
                vendor.Reset();
                vendor.Get("Associated Bank Account");
                "Sending Sacco Name" := vendor.Name;
            end;
        }
        field(3; "Sacco Code"; Code[20])
        {
            TableRelation = Organisation;
            trigger OnValidate()
            var
                Organisation: Record Organisation;

            begin
                if Organisation.Get("Sacco Code") then
                    "Sacco Name" := SaccoA."Full Name";
                //UpdateReceiptLines();
            end;
        }
        field(4; "Sacco Name"; Text[150])
        {
            Editable = false;
        }
        field(5; "Received Amount"; Decimal)
        {
            trigger OnValidate()
            begin

            enD;

        }
        field(6; "No. Series"; Code[20])
        {
            Editable = false;
        }
        field(7; "Transaction Description"; Text[250])
        {

        }
        field(8; "Created By"; Code[120])
        {
            Editable = false;
        }
        field(9; "Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Posted,Reversed,Archived';
            OptionMembers = Open,"Pending Approval",Approved,Posted,Reversed,Archived;
        }
        field(10; "Posted By"; Code[120])
        {
            Editable = false;
        }
        field(11; "From Insurance-For Deceased"; Boolean)
        {
            trigger OnValidate()
            begin

            end;
        }
        field(12; "Application No."; Code[20])
        {

        }
        field(13; "RecSaccoCode No"; Code[20])
        {

        }
        field(14; "Sacco No"; Code[20])
        {

            TableRelation = Vendor where(Commision = const(false));
            trigger OnValidate()
            var
                SaccoApp: Record Vendor;


            begin
                if SaccoApp.get("Sacco No") then
                    "Sacco Name" := SaccoApp.Name;
                IF "Sacco No" = "Associated Bank Account" then
                    ERROR('You Cannot transact with the same Sacco');
            end;

        }
        field(15; "Posting Date"; Date)
        {
            // Editable = false;
        }
        field(16; "Created Date"; Date)
        {
            Editable = false;
        }

        field(18; "Transaction Type1"; Option)
        {
            OptionCaption = 'Receipt,Cheque';
            OptionMembers = Receipt,Cheque;
        }

        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(24; "Created Time"; Time)
        {

        }
        field(25; Posted; Boolean)
        {

        }
        field(26; "Sending Sacco Name"; Text[150])
        {
            Editable = false;
        }
        field(27; "Transaction Type"; Option)
        {
            OptionMembers = Both,"Member to Member","Member to Merchant";
        }
        field(28; "Merchant No"; Code[20])
        {

            TableRelation = Vendor where("Vendor Type" = FILTER('Merchant Account'), Commision = const(false));
            trigger OnValidate()
            var
                SaccoApp: Record Vendor;


            begin
                if SaccoApp.get("Merchant No") then
                    "Merchant Name" := SaccoApp.Name;

            end;

        }
        field(29; "Merchant Name"; Text[150])
        {
            Editable = false;
        }
        field(30; "Externa Doc No"; code[20])
        {
            Editable = false;
        }
        field(31; "ServiceCode"; code[20])
        {
            Editable = false;
        }
        field(32; "RecepientCode"; code[20])
        {
            Editable = false;
        }
        field(33; "SenderCode"; code[20])
        {
            Editable = false;
        }
        field(34; "SendFintech Code"; Code[20])
        {
            TableRelation = Organisation;

        }
        field(35; "RecFintech Code"; Code[20])
        {
            TableRelation = Organisation;

        }
        field(36; MerchantCode; Code[20])
        {
            TableRelation = Organisation;

        }
        field(37; BalAccount; code[20])
        {
            TableRelation = "Bank Account";
        }
        field(38; "Sending Sacco Description"; Text[1024])
        {

        }
        field(39; "Receiving Sacco Description"; Text[1024])
        {

        }
        field(40; TransId; Integer)
        {

        }
        field(41; Reversed; Boolean)
        {

        }
        field(42; "Intitiating Fintech Cbs"; Code[30])
        {

        }
        field(43; "Receiving Fintech Cbs"; Code[30])
        {

        }
        field(44; "Intitiating Fintech Mb"; Code[30])
        {

        }
        field(45; "Receiving Fintech Mb"; Code[30])
        {

        }




    }

    keys
    {
        key(Key1; "Receipt No")
        {
            Clustered = true;
        }
        key(Key2; Status)
        {
            Enabled = true;
        }
        key(key3; "Externa Doc No")
        {
            Enabled = true;
        }
    }

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";

        SaccoA: Record "Sacco Application";
        RunBal: Decimal;
        RunBal1: Decimal;
        RunBal2: Decimal;
        RunBal3: Decimal;


    trigger OnInsert()
    var
        UserSetup: record "User Setup";
    begin
        if "Receipt No" = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("Reminder Nos.");
            // NoSeriesMgt.InitSeries(SalesSetup."Reminder Nos.", xRec."No. Series", 0D, "Receipt No", "No. Series");
            NoSeriesMgt.GetNextNo(SalesSetup."Reminder Nos.", Today, true)
        end;
        "Created By" := UserId;
        "Created Date" := Today;
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











    var
        //  ReceiptLine: Record "Bank Receipt Lines";
        TotalPaid: Decimal;
        GlAccount: Record "G/L Entry";
        LineNo: Integer;
        Totalshares: Decimal;
        DepositAmount: Decimal;
        MaxShares: Decimal;
        SharesAcc: Record Vendor;
        // ObjLoanReg: Record "Loan Application";
        LoanBal: Decimal;
        GenJnlLine: Record "Gen. Journal Line";
        vendor1: Record vendor;
        Custledg: Record "Detailed Cust. Ledg. Entry";
        CountOfInterest: Integer;
        LoanIntRep: Decimal;
        TotalmonthRepaymment: Decimal;
        LoanPriRep: Decimal;

        EntryNo: Integer;
        ContributedAmount: Decimal;
        PercentageOffset: Decimal;

        LoanInsRep: Decimal;
        ObjVend: Record Vendor;
        Sourcecodesetup: Record "Source Code Setup";

        LoanRemainingAmount: Decimal;
        InsuranceFee: Decimal;
        InterestFee: Decimal;
        cust: record Customer;
        ID: Code[20];
        CBSsetup: Record "CBS Setup";
        Regfee: Decimal;



}