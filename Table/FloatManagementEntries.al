table 50027 "Float Management"
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

            TableRelation = "Bank Account";

            trigger OnValidate()
            var
            // BankEntries: Record "Unreceipted Bank Entries";
            begin

            end;
        }
        field(3; "Sacco Code"; Code[20])
        {
            TableRelation = Organisation where(Type = filter(Sacco));
            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin

                SaccoA.Reset();
                SaccoA.Get("Sacco Code");
                "Sacco Name" := SaccoA."Full Name";

                Vend.Reset();
                Vend.SetRange(OrgCode, "Sacco Code");
                Vend.SetRange(Commision, false);
                if Vend.FindFirst() then begin
                    "Sacco No" := Vend."No.";
                end;

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
        field(7; "Transaction Description"; Text[50])
        {

        }
        field(8; "Created By"; Code[120])
        {
            Editable = false;
        }
        field(9; "Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Posted,Rejected,Archived';
            OptionMembers = Open,"Pending Approval",Approved,Posted,Rejected,Archived;
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
        field(13; "Cheque No"; Code[20])
        {

        }
        field(14; "Sacco No"; Code[20])
        {

            // TableRelation = Vendor where("Vendor Type" = filter("Sacco Account"), Commision = CONST(FALSE));

            Editable = false;
            trigger OnValidate()
            var
                SaccoApp: Record Vendor;

            begin
                if SaccoApp.get("Sacco No") then
                    "Sacco Name" := SaccoApp.Name;
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

        field(18; "Transaction Type"; Option)
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
        field(24; Difference; Decimal)
        {

        }
        field(25; Posted; Boolean)
        {
            Editable = false;

        }
        field(26; "Approved By"; Text[30])
        {
            Editable = false;

        }
        field(27; "Approved Date"; date)
        {
            Editable = false;
        }
        field(28; "Approved Time"; time)
        {
            Editable = false;

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

        }
    }

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";

        SaccoA: Record Organisation;
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
            //NoSeriesMgt.InitSeries(SalesSetup."Reminder Nos.", xRec."No. Series", 0D, "Receipt No", "No. Series");
            "Receipt No" := NoSeriesMgt.GetNextNo(SalesSetup."Reminder Nos.", Today, true)
        end;
        "Created By" := UserId;
        "Created Date" := Today;
        "Transaction Description" := 'Receipt from Bank';
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