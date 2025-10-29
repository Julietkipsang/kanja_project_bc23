table 50042 "SettlementTable"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Receipt No", "Transaction Description";
    fields
    {
        field(1; "Receipt No"; Code[30])
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

                /*  FnClearLines();
                  RunBal1 := FnGetAutomaticLinesRegFee();
                  RunBal2 := FnGetAutomaticLinesInterest(RunBal1);
                  RunBal3 := FnGetAutomaticPrincipalRepayments(RunBal2);*/


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
        field(28; sourceAccountNumber; Code[100])
        {

        }
        field(29; toAccountNumber; Code[100])
        {

        }
        field(30; Type; Enum settlementType)
        {

        }
        field(31; "Externa Doc No"; Code[100])
        {

        }
        field(32; transactionDescription; Code[100])
        {

        }
        field(33; paybillNumber; Code[100])
        {

        }
        field(35; Types; Code[20])
        {

        }
        field(36; balAccount; Code[100])
        {
            TableRelation = "Bank Account";
        }
        field(37; entityCode; Code[100])
        {

        }
        field(38; isStagedToOwn; Boolean)
        {


        }
        field(39; kanjaWalletAccount; Code[20])
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