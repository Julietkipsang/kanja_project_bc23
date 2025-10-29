codeunit 50100 "FOSA Management"
{
    trigger OnRun()
    begin

    end;

    var
        CBSSetup: Record "CBS Setup";
        Vendor: Record Vendor;
        GenJournalAccountType: Enum "Gen. Journal Account Type";
        GenJournalLine: Record "Gen. Journal Line" temporary;
        InsufficientAccBalErr: Label 'Insufficient Account Balance';
        ReasonCode: Code[10];
        Indicator: Code[10];
        GLAccount: array[8] of Code[20];
        PostLine: Codeunit "Optimized Gen. Jnl.-Post Line";

        TEMPGenJournalLine: Record "Gen. Journal Line" temporary;
        LineNo: Integer;


    procedure CreateSaccoAccount(SaccoApp: Record "Sacco Application"; OrgCode: Code[20])
    var
        AcountType: Record "Account Type";
        AccountNo: Code[50];
        AccountNo2: Code[50];
        EntityType: Enum EntityType;
        fintech: Record Fintechs;

    begin
        Vendor.Init();
        if AcountType.Get(SaccoApp.PostingGroup) then begin
            if SaccoApp.Type = SaccoApp.Type::Sacco then begin
                AccountNo := OrgCode + SaccoApp."Fintech Account";
                Vendor."Vendor Type" := Vendor."Vendor Type"::"Sacco Account";
                Vendor."No." := AccountNo;
                Vendor.OrgCode := OrgCode;
                Vendor.Name := SaccoApp."Full Name" + ' Float Account';
                Vendor."Mobile Phone No." := SaccoApp."Phone No.";
                Vendor."Phone No." := SaccoApp."Phone No.";
                Vendor."E-Mail" := SaccoApp."E-mail";
                Vendor.Address := SaccoApp."Postal Address";
                Vendor."Address 2" := SaccoApp."Physical Address";
                Vendor.Contact := SaccoApp.ContactPerson;
                Vendor."Our Account No." := SaccoApp."No.";
                Vendor."Vendor Posting Group" := SaccoApp.PostingGroup;
                Vendor.FintechAccount := SaccoApp."Fintech Account";
                Vendor.AgentAccount := SaccoApp."Agent Account";
                Vendor.Status := Vendor.Status::Active;
                Vendor.Insert();
            end;
            if SaccoApp.Type = SaccoApp.Type::Fintech then begin
                AccountNo := OrgCode;
                Vendor."Vendor Type" := Vendor."Vendor Type"::"Fintech Account";
                Vendor.Commision := true;
                Vendor."No." := AccountNo;
                Vendor.OrgCode := OrgCode;
                Vendor.Name := SaccoApp."Full Name" + ' Commison Account';
                Vendor."Mobile Phone No." := SaccoApp."Phone No.";
                Vendor."Phone No." := SaccoApp."Phone No.";
                Vendor."E-Mail" := SaccoApp."E-mail";
                Vendor.Address := SaccoApp."Postal Address";
                Vendor."Address 2" := SaccoApp."Physical Address";
                Vendor.Contact := SaccoApp.ContactPerson;
                Vendor."Our Account No." := SaccoApp."No.";
                Vendor."Vendor Posting Group" := SaccoApp.PostingGroup;
                Vendor.FintechAccount := SaccoApp."Fintech Account";
                Vendor.AgentAccount := SaccoApp."Agent Account";
                Vendor.Status := Vendor.Status::Active;
                Vendor.Insert();
            end;
            if SaccoApp.Type = SaccoApp.Type::Merchant then begin
                if SaccoApp."Merchant Type" = SaccoApp."Merchant Type"::"Kanja Merchant" then begin
                    if SaccoApp."Agent Account" <> '' then begin
                        AccountNo := OrgCode + SaccoApp."Agent Account";
                    end else begin
                        AccountNo := OrgCode + SaccoApp."Merchant Sacco No";
                    end;
                    Vendor."Vendor Type" := Vendor."Vendor Type"::"Merchant Account";
                    Vendor."No." := AccountNo;
                    Vendor.OrgCode := OrgCode;
                    Vendor.Name := SaccoApp."Full Name" + ' Float Account';
                    Vendor."Mobile Phone No." := SaccoApp."Phone No.";
                    Vendor."Phone No." := SaccoApp."Phone No.";
                    Vendor."E-Mail" := SaccoApp."E-mail";
                    Vendor.Address := SaccoApp."Postal Address";
                    Vendor."Address 2" := SaccoApp."Physical Address";
                    Vendor.Contact := SaccoApp.ContactPerson;
                    Vendor."Our Account No." := SaccoApp."No.";
                    Vendor."Vendor Posting Group" := SaccoApp.PostingGroup;
                    Vendor.FintechAccount := SaccoApp."Fintech Account";
                    Vendor.AgentAccount := SaccoApp."Agent Account";
                    Vendor.Status := Vendor.Status::Active;
                    Vendor.Insert();
                end;
            end;
            if SaccoApp.Type = SaccoApp.Type::Acquirer then begin
                AccountNo := OrgCode;
                Vendor."Vendor Type" := Vendor."Vendor Type"::"Agent Account";
                Vendor.Commision := true;
                Vendor."No." := AccountNo;
                Vendor.OrgCode := OrgCode;
                Vendor.Name := SaccoApp."Full Name" + ' Commision Account';
                Vendor."Mobile Phone No." := SaccoApp."Phone No.";
                Vendor."Phone No." := SaccoApp."Phone No.";
                Vendor."E-Mail" := SaccoApp."E-mail";
                Vendor.Address := SaccoApp."Postal Address";
                Vendor."Address 2" := SaccoApp."Physical Address";
                Vendor.Contact := SaccoApp.ContactPerson;
                Vendor."Our Account No." := SaccoApp."No.";
                Vendor."Vendor Posting Group" := SaccoApp.PostingGroup;
                Vendor.FintechAccount := SaccoApp."Fintech Account";
                Vendor.AgentAccount := SaccoApp."Agent Account";
                // Vendor."Vendor Posting Group" := SaccoApp.Type;
                Vendor.Status := Vendor.Status::Active;
                //Error('jhjh');
                Vendor.Insert();
            end;
            if EntityType = EntityType::Banks then
                Vendor."Vendor Type" := Vendor."Vendor Type"::"Bank Account";
            if EntityType = EntityType::MFI then
                Vendor."Vendor Type" := Vendor."Vendor Type"::IMF;
        end;
        /////Float Account


        //Commision Accounts
        if AcountType.Get(SaccoApp.PostingGroup) then begin
            if (SaccoApp.Type = SaccoApp.Type::Sacco) then begin
                //  repeat
                AccountNo2 := OrgCode;
                Vendor."Vendor Type" := Vendor."Vendor Type"::"Sacco Account";
                Vendor."No." := AccountNo2;
                Vendor.OrgCode := OrgCode;
                Vendor.Name := SaccoApp."Full Name" + ' Commision Account';
                Vendor."Mobile Phone No." := SaccoApp."Phone No.";
                Vendor."Phone No." := SaccoApp."Phone No.";
                Vendor."E-Mail" := SaccoApp."E-mail";
                Vendor.Address := SaccoApp."Postal Address";
                Vendor."Address 2" := SaccoApp."Physical Address";
                Vendor.Contact := SaccoApp.ContactPerson;
                Vendor."Our Account No." := SaccoApp."No.";
                Vendor."Vendor Posting Group" := 'SACCOCOMM';
                Vendor.FintechAccount := SaccoApp."Fintech Account";
                Vendor.AgentAccount := SaccoApp."Agent Account";
                Vendor.Commision := true;
                Vendor.Status := Vendor.Status::Active;
                fintech.Reset();
                fintech.SetRange(applNo, SaccoApp."No.");
                fintech.SetRange(receiveDeposit, false);
                if fintech.FindFirst() then begin
                    Vendor.FintechAccount := fintech.fintechCode;
                end;
                Vendor.Insert();
                //  until
            end;

            if (SaccoApp.Type = SaccoApp.Type::Merchant) then begin
                AccountNo2 := OrgCode;
                Vendor."Vendor Type" := Vendor."Vendor Type"::"Merchant Account";
                Vendor."No." := AccountNo2;
                Vendor.OrgCode := OrgCode;
                Vendor.Name := SaccoApp."Full Name" + ' Commision Account';
                Vendor."Mobile Phone No." := SaccoApp."Phone No.";
                Vendor."Phone No." := SaccoApp."Phone No.";
                Vendor."E-Mail" := SaccoApp."E-mail";
                Vendor.Address := SaccoApp."Postal Address";
                Vendor."Address 2" := SaccoApp."Physical Address";
                Vendor.Contact := SaccoApp.ContactPerson;
                Vendor."Our Account No." := SaccoApp."No.";
                Vendor."Vendor Posting Group" := 'MERCHANTCOMM';
                Vendor.FintechAccount := SaccoApp."Fintech Account";
                Vendor.AgentAccount := SaccoApp."Agent Account";
                Vendor.Commision := true;
                Vendor.Status := Vendor.Status::Active;
                Vendor.Insert();


            end;
        end;

    end;

    procedure CreateSaccoFintechAccount(AccountApp: Record "Account Opening")
    var
        AcountType: Record "Account Type";
        AccountNo: Code[50];
        SaccoAppp: Record "Sacco Application";
    begin

        if AcountType.Get(AccountApp."Account Type") then
            AccountNo := AcountType."Account Prefix" + '-' + AccountApp."Sacco No." + AccountApp."Fintech Account";
        Vendor."No." := AccountNo;
        Vendor.Name := AccountApp."Sacco Name";
        if SaccoAppp.Get(AccountApp."Sacco No.") then
            Vendor."Phone No." := SaccoAppp."Phone No.";
        Vendor."Mobile Phone No." := SaccoAppp."Phone No.";
        Vendor."E-Mail" := SaccoAppp."E-mail";
        Vendor.Address := SaccoAppp."Postal Address";
        Vendor."Address 2" := SaccoAppp."Physical Address";
        Vendor.Contact := SaccoAppp.ContactPerson;
        Vendor."Our Account No." := SaccoAppp."No.";
        Vendor."Vendor Posting Group" := SaccoAppp.PostingGroup;
        Vendor.FintechAccount := AccountApp."Fintech Account";
        Vendor.AgentAccount := AccountApp."Fintech Account";
        // Vendor."Vendor Posting Group" := SaccoApp.Type;
        Vendor.Status := Vendor.Status::Active;
        if SaccoAppp.Type = SaccoAppp.Type::Sacco then
            Vendor."Vendor Type" := Vendor."Vendor Type"::"Sacco Account";
        Vendor.Insert();
        //  Message('Done');
    end;


    procedure PostToAccount(FloatManagement: Record "Float Management")
    var
        JournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        PostLine: Codeunit "Optimized Gen. Jnl.-Post Line";
        AccountType: Enum "Gen. Journal Account Type";
        BalAccountNo: Code[20];
        BranchCode: Code[20];
        cbsSetup: Record "CBS Setup";
        TemplateName: Code[30];
        BatchName: Code[30];
    begin
        cbsSetup.Get();
        TemplateName := cbsSetup."Kanja General Template Name";
        BatchName := cbsSetup."Kanja General Batch Name";
        CreateJournalLines(TemplateName, BatchName, FloatManagement."Receipt No", AccountType::"Bank Account", FloatManagement."Associated Bank Account", AccountType::"G/L Account", BalAccountNo, FloatManagement."Received Amount", FloatManagement."Transaction Description", BranchCode);
        CreateJournalLines(TemplateName, BatchName, FloatManagement."Receipt No", AccountType::Vendor, FloatManagement."Sacco No", AccountType::"G/L Account", BalAccountNo, (-1 * FloatManagement."Received Amount"), FloatManagement."Transaction Description", BranchCode);
        PostJournalLine();
    end;

    procedure PostToSaccoAccount(SaccoApp: Record "Sacco Transaction Management")
    var
        // JournalLine: Record "Gen. Journal Line" temporary;
        JournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        EntryNo: Integer;
        PostLine: Codeunit "Optimized Gen. Jnl.-Post Line";
        RemainingAmount: Decimal;
        ChargeAmount: Decimal;
        TotalChargeAmount: Decimal;
        LoanCharges: Record "Charges Table";
        ChargesRange: Record "Charges Range";
        ChargeDetails: Record " Charge Details";
        SaccoApplication: Record "Sacco Application";
        SendingFintech: code[50];
        vendorxxx: Record Vendor;
        ReceivingSaccoName: Text[100];
        SendingSacco: code[50];
        vendor2: Record Vendor;

    begin

        JournalLine.Reset();
        JournalLine.SetRange("Journal Template Name", 'GENERAL');
        JournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        if JournalLine.FindLast then
            LineNo := JournalLine."Line No."
        else
            LineNo := 0;

        /********************Insert header*************************/
        JournalLine.Init();
        JournalLine."Line No." := LineNo + 1;
        JournalLine."Journal Template Name" := 'GENERAL';
        JournalLine."Journal Batch Name" := 'DEFAULT';
        JournalLine."Posting Date" := Today;
        JournalLine."Document No." := SaccoApp."Receipt No";
        JournalLine."External Document No." := SaccoApp."Receipt No";
        JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
        JournalLine.Validate("Account No.", SaccoApp."Associated Bank Account");
        JournalLine.Validate(Amount, SaccoApp."Received Amount");
        JournalLine.Description := SaccoApp."Transaction Description";
        if (SaccoApp."Received Amount" <> 0) then begin
            JournalLine.Insert();
            //LineNo += 1000;
        end;
        /********************Insert header end************************/
        /********************Insert Charges Begin************************/
        LoanCharges.Reset();
        LoanCharges.SetFilter("Transaction Type", '<>%1', LoanCharges."Transaction Type"::"Member to Merchant");
        IF LoanCharges.FindSet then begin

            repeat
                IF LoanCharges."Calculation Mode" = LoanCharges."Calculation Mode"::"% of Transcation" then
                    ChargeAmount := SaccoApp."Received Amount" * LoanCharges.Value / 100;
                IF LoanCharges."Calculation Mode" = LoanCharges."Calculation Mode"::"Flat Amount" then
                    ChargeAmount := LoanCharges.Value;
                IF LoanCharges."Calculation Mode" = LoanCharges."Calculation Mode"::Range then begin

                    ChargesRange.Reset();
                    ChargesRange.SetRange("Charge Code", LoanCharges.Code);
                    if ChargesRange.FindSet then begin
                        repeat
                            if ((SaccoApp."Received Amount" >= ChargesRange."Minimum Amount") and (SaccoApp."Received Amount" <= ChargesRange."Maximum Amount")) then begin
                                ChargeAmount := ChargesRange."Value Amount";
                            end;

                        until ChargesRange.Next() = 0;
                    end;
                end;
                ChargeDetails.Reset();
                IF ChargeDetails.FindLast then
                    EntryNo := ChargeDetails.EntryNo
                else
                    EntryNo := 0;


                ChargeDetails.Init;
                ChargeDetails.EntryNo := EntryNo + 1;
                ChargeDetails.DocNo := SaccoApp."Receipt No";
                ChargeDetails."Charge Code" := LoanCharges.code;
                ChargeDetails."Calculation Mode" := LoanCharges."Calculation Mode";
                ChargeDetails.ChargeValue := ChargeAmount;
                ChargeDetails."Sending Sacco" := SaccoApp."Associated Bank Account";
                ChargeDetails."Receiving Sacco" := SaccoApp."Sacco No";
                ChargeDetails."Received Amount" := SaccoApp."Received Amount";
                if vendorxxx.Get(SaccoApp."Associated Bank Account") then begin
                    ChargeDetails.SalespersonCode := vendorxxx.FintechAccount;
                    SendingFintech := vendorxxx.FintechAccount;
                    ReceivingSaccoName := vendorxxx.Name;
                end;
                ChargeDetails.Insert;


                JournalLine.Init();
                JournalLine.Reset();
                JournalLine.SetRange("Journal Template Name", 'GENERAL');
                JournalLine.SetRange("Journal Batch Name", 'DEFAULT');
                if JournalLine.FindLast then
                    LineNo := JournalLine."Line No."
                else
                    LineNo := 0;
                JournalLine."Line No." := LineNo + 1;
                JournalLine."Journal Template Name" := 'GENERAL';
                JournalLine."Journal Batch Name" := 'DEFAULT';
                JournalLine."Posting Date" := Today;
                JournalLine."Document No." := SaccoApp."Receipt No";
                JournalLine."External Document No." := SaccoApp."Receipt No";
                if LoanCharges."Charge Type" = LoanCharges."Charge Type"::SENFintech then begin
                    JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
                    JournalLine.Validate("Account No.", SendingFintech);
                end;
                if LoanCharges."Charge Type" = LoanCharges."Charge Type"::SENSacco then begin
                    JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
                    vendorxxx.Reset();
                    vendorxxx.SetRange("No.", SaccoApp."Associated Bank Account");
                    if vendorxxx.FindFirst then begin
                        vendor2.Reset();
                        vendor2.SetRange(OrgCode, vendorxxx.OrgCode);
                        vendor2.SetRange(Commision, true);
                        if vendor2.FindFirst() then
                            SendingSacco := vendor2."No.";
                    end;


                    JournalLine.Validate("Account No.", SendingSacco);
                end;
                if LoanCharges."Charge Type" = LoanCharges."Charge Type"::Kanja then begin
                    JournalLine."Account Type" := JournalLine."Account Type"::"G/L Account";
                    JournalLine.Validate("Account No.", LoanCharges."Account No.");
                end;
                if LoanCharges."Charge Type" = LoanCharges."Charge Type"::RECFintech then begin
                    if vendorxxx.Get(SaccoApp."Sacco No") then begin
                        ChargeDetails.SalespersonCode := vendorxxx.FintechAccount;
                        SendingFintech := vendorxxx.FintechAccount;
                    end;
                    JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
                    JournalLine.Validate("Account No.", SendingFintech);
                end;
                if LoanCharges."Charge Type" = LoanCharges."Charge Type"::RECSacco then begin

                    JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
                    vendorxxx.Reset();
                    vendorxxx.SetRange("No.", SaccoApp."Sacco No");
                    if vendorxxx.FindFirst then begin
                        vendor2.Reset();
                        vendor2.SetRange(OrgCode, vendorxxx.OrgCode);
                        vendor2.SetRange(Commision, true);
                        if vendor2.FindFirst() then
                            SendingSacco := vendor2."No.";
                    end;

                    JournalLine.Validate("Account No.", SendingSacco);
                end;



                JournalLine.Validate(Amount, ChargeAmount * -1);
                JournalLine.Description := 'Charges from Sacco -' + '- ' + ReceivingSaccoName + '- ' + 'Member No';
                if (SaccoApp."Received Amount" <> 0) then begin
                    JournalLine.Insert();
                end;
                JournalLine.Init();
                JournalLine.Reset();
                JournalLine.SetRange("Journal Template Name", 'GENERAL');
                JournalLine.SetRange("Journal Batch Name", 'DEFAULT');
                if JournalLine.FindLast then
                    LineNo := JournalLine."Line No."
                else
                    LineNo := 0;
                JournalLine."Line No." := LineNo + 2;
                JournalLine."Journal Template Name" := 'GENERAL';
                JournalLine."Journal Batch Name" := 'DEFAULT';
                JournalLine."Posting Date" := Today;
                JournalLine."Document No." := SaccoApp."Receipt No";
                JournalLine."External Document No." := SaccoApp."Receipt No";
                JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
                JournalLine.Validate("Account No.", SaccoApp."Associated Bank Account");
                JournalLine.Validate(Amount, (ChargeAmount));
                JournalLine.Description := 'Charges for-' + LoanCharges.Code + '- ' + SendingFintech;
                if (SaccoApp."Received Amount" <> 0) then begin
                    JournalLine.Insert();
                    //LineNo += 1000;
                end;

                TotalChargeAmount += ChargeAmount;


            //LineNo += 1000;

            until LoanCharges.Next = 0;



        end;


        /********************Insert Charges end************************/


        RemainingAmount := SaccoApp."Received Amount" - TotalChargeAmount;

        /********************Insert Line*************************/
        JournalLine.Init();
        JournalLine.Reset();
        JournalLine.SetRange("Journal Template Name", 'GENERAL');
        JournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        if JournalLine.FindLast then
            LineNo := JournalLine."Line No."
        else
            LineNo := 0;
        JournalLine."Line No." := LineNo + 2;
        JournalLine."Journal Template Name" := 'GENERAL';
        JournalLine."Journal Batch Name" := 'DEFAULT';
        JournalLine."Posting Date" := Today;
        JournalLine."Document No." := SaccoApp."Receipt No";
        JournalLine."External Document No." := SaccoApp."Receipt No";
        JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
        JournalLine.Validate("Account No.", SaccoApp."Sacco No");
        JournalLine.Validate(Amount, (SaccoApp."Received Amount" * -1));
        JournalLine.Description := SaccoApp."Transaction Description";
        if (SaccoApp."Received Amount" <> 0) then begin
            JournalLine.Insert();
            //LineNo += 1000;
        end;
        /********************Insert Line end************************/
        PostLine.Run(JournalLine);

    end;

    procedure PostingSettlementTransaction(transactionId: Code[20])
    var
        Settlement: Record SettlementTable;
        settlementCharges: Record "Settlement Charges";
        settlementTypes: Record SettlementTypeCharges;
        TemplateName: Code[30];
        BatchName: code[30];
        Total: Decimal;
        ChargeAmount: Decimal;
        TransactionAmount: Decimal;
        settleTypes: text;
        TotalCharges: Decimal;
        AccountType: Enum "Gen. Journal Account Type";
        BalAccountNo: Code[20];
        BranchCode: Code[20];
        Vendor: Record Vendor;
        Balance: Decimal;
        chargesDescription: Code[100];
        MpesaCharges: Decimal;
        KanjaCharges: Decimal;

    begin
        Total := 0;
        ChargeAmount := 0;
        TemplateName := 'GENERAL';
        BatchName := 'SPOTCASH';
        LineNo := 1000;

        if Settlement.Get(transactionId) then begin
            settleTypes := Settlement.Types;
            if Settlement.Posted = true then
                Error('The document has been posted');
        end;

        Vendor.Reset();
        Vendor.SetRange("No.", Settlement.sourceAccountNumber);
        Vendor.SetRange(Commision, true);
        if Vendor.FindFirst() then begin
            Vendor.CalcFields(Balance);
            Balance := Vendor.Balance;
        end;
        TransactionAmount := Settlement."Received Amount";
        settlementCharges.Reset();
        settlementCharges.SetRange(settlementDescription, settleTypes);
        IF settlementCharges.FindSet() THEN begin
            repeat
                if (TransactionAmount >= settlementCharges."Minimum Amount") AND (TransactionAmount <= settlementCharges."Maximum Amount") then begin
                    TotalCharges := settlementCharges."Total Charge Amount";
                    MpesaCharges := settlementCharges."MPESA Charges";
                    KanjaCharges := settlementCharges.KanjaCharges;
                    chargesDescription := 'Settlement Charges';

                end;
            until settlementCharges.Next() = 0;
        END;
        IF TotalCharges + TransactionAmount > Balance then begin
            Error('Insufficient Balance');
            exit;
        end;
        if (settleTypes = 'BANK') OR (settleTypes = 'PAY_BILL') OR (settleTypes = 'PHONE') then begin
            CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::Vendor, Settlement.sourceAccountNumber, AccountType::"G/L Account", BalAccountNo, Settlement."Received Amount", Settlement."Transaction Description", BranchCode);
            CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::"Bank Account",
             Settlement.balAccount, AccountType::"G/L Account", BalAccountNo, (-1 * Settlement."Received Amount"), Settlement."Transaction Description", BranchCode);
        end;

        IF settleTypes = 'KANJA_ACCOUNT' then begin
            CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::Vendor, Settlement.sourceAccountNumber, AccountType::"G/L Account", BalAccountNo, Settlement."Received Amount", Settlement."Transaction Description", BranchCode);
            CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::Vendor,
             Settlement.toAccountNumber, AccountType::"G/L Account", BalAccountNo, (-1 * Settlement."Received Amount"), Settlement."Transaction Description", BranchCode);
        end;
        //charges
        CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::Vendor, Settlement.sourceAccountNumber, AccountType::"G/L Account", BalAccountNo, TotalCharges, chargesDescription, BranchCode);
        CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::"G/L Account", settlementCharges."Settlement Account No."
        , AccountType::"G/L Account", BalAccountNo, (-1 * TotalCharges), chargesDescription, BranchCode);



        PostJournalLine();
        Settlement.Posted := true;
        Settlement."Posted By" := UserId;
        Settlement.Status := Settlement.Status::Posted;
        if Settlement.Modify(true) then begin

            Message('Posted Succesfully');
            exit;
        end else begin

            Message('Posting Failed');
            exit;
        end

    end;





    Local procedure CreateJournalLines(TemplateName: Code[20]; BatchName: Code[20]; DocumentNo: Code[20]; AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20];
                                                                                                                               BalAccountType: Enum "Gen. Journal Account Type";
                                                                                                                               BalAccountNo: Code[20];
                                                                                                                               Amount: Decimal;
                                                                                                                               Description: Text[50];
                                                                                                                               BranchCode: Code[20])
    begin
        TEMPGenJournalLine.Init();
        TEMPGenJournalLine."Line No." := LineNo;
        TEMPGenJournalLine."Journal Template Name" := TemplateName;
        TEMPGenJournalLine."Journal Batch Name" := BatchName;
        TEMPGenJournalLine."Posting Date" := Today;
        TEMPGenJournalLine."Document No." := DocumentNo;
        TEMPGenJournalLine."Account Type" := AccountType;
        TEMPGenJournalLine.Validate("Account No.", AccountNo);
        TEMPGenJournalLine.Validate(Amount, Amount);
        TEMPGenJournalLine.Description := Description;
        TEMPGenJournalLine."Bal. Account Type" := BalAccountType;
        TEMPGenJournalLine.Validate("Bal. Account No.", BalAccountNo);
        TEMPGenJournalLine.Validate("Shortcut Dimension 1 Code", BranchCode);
        if (Amount <> 0) then begin
            TEMPGenJournalLine.Insert();
            LineNo += 1000;
        end;
    end;

    local procedure PostJournalLine()
    begin
        PostLine.Run(TEMPGenJournalLine)
    end;

    procedure PostToMerchantAccount(SaccoApp: Record "Sacco Transaction Management")
    var
        // JournalLine: Record "Gen. Journal Line" temporary;
        JournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        EntryNo: Integer;
        PostLine: Codeunit "Optimized Gen. Jnl.-Post Line";
        RemainingAmount: Decimal;
        ChargeAmount: Decimal;
        TotalChargeAmount: Decimal;
        LoanCharges: Record "Charges Table";
        ChargesRange: Record "Charges Range";
        ChargeDetails: Record " Charge Details";
        SaccoApplication: Record "Sacco Application";
        SendingFintech: code[50];
        vendorxxx: Record Vendor;
        ReceivingSaccoName: Text[100];
        SendingSacco: code[50];
        vendor2: Record Vendor;

    begin

        JournalLine.Reset();
        JournalLine.SetRange("Journal Template Name", 'GENERAL');
        JournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        if JournalLine.FindLast then
            LineNo := JournalLine."Line No."
        else
            LineNo := 0;

        /********************Insert header*************************/
        JournalLine.Init();
        JournalLine."Line No." := LineNo + 1;
        JournalLine."Journal Template Name" := 'GENERAL';
        JournalLine."Journal Batch Name" := 'DEFAULT';
        JournalLine."Posting Date" := Today;
        JournalLine."Document No." := SaccoApp."Receipt No";
        JournalLine."External Document No." := SaccoApp."Receipt No";
        JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
        JournalLine.Validate("Account No.", SaccoApp."Associated Bank Account");
        JournalLine.Validate(Amount, SaccoApp."Received Amount");
        JournalLine.Description := SaccoApp."Transaction Description";
        if (SaccoApp."Received Amount" <> 0) then begin
            JournalLine.Insert();
            //LineNo += 1000;
        end;
        /********************Insert header end************************/
        /********************Insert Charges Begin************************/
        LoanCharges.Reset();
        //LoanCharges.SetFilter("Transaction Type", '<>%1', LoanCharges."Transaction Type"::"Member to Merchant");
        IF LoanCharges.FindSet then begin

            repeat
                IF LoanCharges."Calculation Mode" = LoanCharges."Calculation Mode"::"% of Transcation" then
                    ChargeAmount := SaccoApp."Received Amount" * LoanCharges.Value / 100;
                IF LoanCharges."Calculation Mode" = LoanCharges."Calculation Mode"::"Flat Amount" then
                    ChargeAmount := LoanCharges.Value;
                IF LoanCharges."Calculation Mode" = LoanCharges."Calculation Mode"::Range then begin

                    ChargesRange.Reset();
                    ChargesRange.SetRange("Charge Code", LoanCharges.Code);
                    if ChargesRange.FindSet then begin
                        repeat
                            if ((SaccoApp."Received Amount" >= ChargesRange."Minimum Amount") and (SaccoApp."Received Amount" <= ChargesRange."Maximum Amount")) then begin
                                ChargeAmount := ChargesRange."Value Amount";
                            end;

                        until ChargesRange.Next() = 0;
                    end;
                end;
                ChargeDetails.Reset();
                IF ChargeDetails.FindLast then
                    EntryNo := ChargeDetails.EntryNo
                else
                    EntryNo := 0;


                ChargeDetails.Init;
                ChargeDetails.EntryNo := EntryNo + 1;
                ChargeDetails.DocNo := SaccoApp."Receipt No";
                ChargeDetails."Charge Code" := LoanCharges.code;
                ChargeDetails."Calculation Mode" := LoanCharges."Calculation Mode";
                ChargeDetails.ChargeValue := ChargeAmount;
                ChargeDetails."Sending Sacco" := SaccoApp."Associated Bank Account";
                ChargeDetails."Receiving Sacco" := SaccoApp."Sacco No";
                ChargeDetails."Received Amount" := SaccoApp."Received Amount";
                if vendorxxx.Get(SaccoApp."Associated Bank Account") then begin
                    ChargeDetails.SalespersonCode := vendorxxx.FintechAccount;
                    SendingFintech := vendorxxx.FintechAccount;
                    ReceivingSaccoName := vendorxxx.Name;
                end;
                ChargeDetails.Insert;


                JournalLine.Init();
                JournalLine.Reset();
                JournalLine.SetRange("Journal Template Name", 'GENERAL');
                JournalLine.SetRange("Journal Batch Name", 'DEFAULT');
                if JournalLine.FindLast then
                    LineNo := JournalLine."Line No."
                else
                    LineNo := 0;
                JournalLine."Line No." := LineNo + 1;
                JournalLine."Journal Template Name" := 'GENERAL';
                JournalLine."Journal Batch Name" := 'DEFAULT';
                JournalLine."Posting Date" := Today;
                JournalLine."Document No." := SaccoApp."Receipt No";
                JournalLine."External Document No." := SaccoApp."Receipt No";
                if LoanCharges."Charge Type" = LoanCharges."Charge Type"::SENFintech then begin
                    JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
                    JournalLine.Validate("Account No.", SendingFintech);
                    Message(SendingFintech);
                end;
                if LoanCharges."Charge Type" = LoanCharges."Charge Type"::SENSacco then begin
                    JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
                    vendorxxx.Reset();
                    vendorxxx.SetRange("No.", SaccoApp."Associated Bank Account");
                    if vendorxxx.FindFirst then begin
                        vendor2.Reset();
                        vendor2.SetRange(OrgCode, vendorxxx.OrgCode);
                        vendor2.SetRange(Commision, true);
                        if vendor2.FindFirst() then
                            SendingSacco := vendor2."No.";
                        Message(SendingSacco);
                    end;


                    JournalLine.Validate("Account No.", SendingSacco);
                end;
                if LoanCharges."Charge Type" = LoanCharges."Charge Type"::Kanja then begin
                    JournalLine."Account Type" := JournalLine."Account Type"::"G/L Account";
                    JournalLine.Validate("Account No.", LoanCharges."Account No.");
                    Message(LoanCharges."Account No.");
                end;
                ///////receving if tied to sacco
                vendorxxx.reset;
                vendorxxx.SetRange("No.", SaccoApp."Merchant No");
                if vendorxxx.FindFirst then begin
                    SaccoApplication.Reset();
                    SaccoApplication.SetRange("No.", vendorxxx."Our Account No.");
                    if SaccoApplication.FindFirst then begin
                        if SaccoApplication."Merchant Type" = SaccoApplication."Merchant Type"::"Sacco Merchant" then begin

                            if LoanCharges."Charge Type" = LoanCharges."Charge Type"::RECSacco then begin
                                vendorxxx.RESET;
                                vendorxxx.SetRange("Our Account No.", SaccoApplication."Merchant Sacco No");
                                vendorxxx.SetRange(Commision, true);
                                if vendorxxx.FindFirst() then begin
                                    ChargeDetails.SalespersonCode := vendorxxx."No.";
                                    SendingFintech := vendorxxx."No.";
                                    Message(SendingFintech);
                                end;
                                JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
                                JournalLine.Validate("Account No.", SendingFintech);
                            end;
                            if LoanCharges."Charge Type" = LoanCharges."Charge Type"::RECFintech then begin


                                vendorxxx.RESET;
                                vendorxxx.SetRange("Our Account No.", SaccoApplication."Merchant Sacco No");
                                vendorxxx.SetRange(Commision, true);
                                if vendorxxx.FindFirst() then begin
                                    ChargeDetails.SalespersonCode := vendorxxx.FintechAccount;
                                    SendingSacco := vendorxxx.FintechAccount;
                                    message(SendingSacco);
                                end;
                                JournalLine."Account Type" := JournalLine."Account Type"::Vendor;

                                JournalLine.Validate("Account No.", SendingSacco);
                            end;
                        end
                    end;
                end;
                ///////receving if tied to sacco
                if LoanCharges."Charge Type" = LoanCharges."Charge Type"::REAgent then begin

                    if vendorxxx.Get(SaccoApp."Merchant No") then begin
                        ChargeDetails.SalespersonCode := vendorxxx.AgentAccount;
                        SendingFintech := vendorxxx.AgentAccount;
                        Message(SendingFintech);
                    end;
                    JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
                    JournalLine.Validate("Account No.", SendingFintech);
                end;
                if LoanCharges."Charge Type" = LoanCharges."Charge Type"::REmerchant then begin

                    JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
                    vendorxxx.Reset();
                    vendorxxx.SetRange("No.", SaccoApp."Merchant No");
                    if vendorxxx.FindFirst then begin
                        vendor2.Reset();
                        vendor2.SetRange(OrgCode, vendorxxx.OrgCode);
                        vendor2.SetRange(Commision, true);
                        if vendor2.FindFirst() then
                            SendingSacco := vendor2."No.";
                        Message(SendingSacco);
                    end;

                    JournalLine.Validate("Account No.", SendingSacco);
                end;






                JournalLine.Validate(Amount, ChargeAmount * -1);
                JournalLine.Description := 'Charges from Sacco -' + '- ' + ReceivingSaccoName + '- ' + 'Member No';
                if (SaccoApp."Received Amount" <> 0) then begin
                    JournalLine.Insert();
                end;
                JournalLine.Init();
                JournalLine.Reset();
                JournalLine.SetRange("Journal Template Name", 'GENERAL');
                JournalLine.SetRange("Journal Batch Name", 'DEFAULT');
                if JournalLine.FindLast then
                    LineNo := JournalLine."Line No."
                else
                    LineNo := 0;
                JournalLine."Line No." := LineNo + 2;
                JournalLine."Journal Template Name" := 'GENERAL';
                JournalLine."Journal Batch Name" := 'DEFAULT';
                JournalLine."Posting Date" := Today;
                JournalLine."Document No." := SaccoApp."Receipt No";
                JournalLine."External Document No." := SaccoApp."Receipt No";
                JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
                JournalLine.Validate("Account No.", SaccoApp."Associated Bank Account");
                JournalLine.Validate(Amount, (ChargeAmount));
                JournalLine.Description := 'Charges for-' + LoanCharges.Code + '- ' + SendingFintech;
                if (SaccoApp."Received Amount" <> 0) then begin
                    JournalLine.Insert();
                    //LineNo += 1000;
                end;

                TotalChargeAmount += ChargeAmount;


            //LineNo += 1000;

            until LoanCharges.Next = 0;



        end;


        /********************Insert Charges end************************/


        RemainingAmount := SaccoApp."Received Amount" - TotalChargeAmount;

        /********************Insert Line*************************/
        JournalLine.Init();
        JournalLine.Reset();
        JournalLine.SetRange("Journal Template Name", 'GENERAL');
        JournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        if JournalLine.FindLast then
            LineNo := JournalLine."Line No."
        else
            LineNo := 0;
        JournalLine."Line No." := LineNo + 2;
        JournalLine."Journal Template Name" := 'GENERAL';
        JournalLine."Journal Batch Name" := 'DEFAULT';
        JournalLine."Posting Date" := Today;
        JournalLine."Document No." := SaccoApp."Receipt No";
        JournalLine."External Document No." := SaccoApp."Receipt No";
        JournalLine."Account Type" := JournalLine."Account Type"::Vendor;
        JournalLine.Validate("Account No.", SaccoApp."Sacco No");
        JournalLine.Validate(Amount, (SaccoApp."Received Amount" * -1));
        JournalLine.Description := SaccoApp."Transaction Description";
        if (SaccoApp."Received Amount" <> 0) then begin
            JournalLine.Insert();
            //LineNo += 1000;
        end;
        /********************Insert Line end************************/
        PostLine.Run(JournalLine);

    end;

    procedure ValidatePhoneNo("PhoneNo.": Code[30])
    var
        NotContainCharErr: Label 'Phone No. cannot contain characters.';
        ExceedCharErr: Label 'Phone No. cannot exceed %1 characters.';
        NotLessThanCharErr: Label 'Phone No. cannot be less than %1 characters.';
        Expected254CharErr: Label 'Phone No. should start with 2547********';
        Expected07CharErr: Label 'Phone No. should start with 07********';
    begin
        IF "PhoneNo." <> '' THEN BEGIN
            IF IsNumeric("PhoneNo.") > 0 THEN
                ERROR(NotContainCharErr);
            CBSSetup.Get;
            if CBSSetup."Phone No. Format" = CBSSetup."Phone No. Format"::"07XXXXXXXX" then begin
                IF STRLEN("PhoneNo.") > 10 THEN
                    ERROR(ExceedCharErr, 10);

                IF STRLEN("PhoneNo.") < 10 THEN
                    ERROR(NotLessThanCharErr, 10);

                if CopyStr("PhoneNo.", 1, 2) <> '07' then
                    Error(Expected07CharErr);

            end;
            if CBSSetup."Phone No. Format" = CBSSetup."Phone No. Format"::"2547XXXXXXXX" then begin
                IF STRLEN("PhoneNo.") > 12 THEN
                    ERROR(ExceedCharErr, 12);

                IF STRLEN("PhoneNo.") < 12 THEN
                    ERROR(NotLessThanCharErr, 12);

                if CopyStr("PhoneNo.", 1, 3) <> '254' then
                    Error(Expected254CharErr);
            end;
        END;
    end;

    procedure IsNumeric(Variant: Code[20]): Integer
    var
        j: Integer;
        i: Integer;
    begin
        FOR i := 1 TO STRLEN(Variant) DO BEGIN
            IF NOT (Variant[i] IN ['0' .. '9', '+']) THEN
                j += 1;
        END;
        EXIT(j);
    end;

    procedure Deletejournline()
    var
        // JournalLine: Record "Gen. Journal Line" temporary;
        JournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        JournalLine.Reset();
        JournalLine.SetRange("Journal Template Name", 'GENERAL');
        JournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        if JournalLine.FindSet() then begin
            JournalLine.DeleteAll();
        end;
    end;

    procedure CreateOrganisation(SaccoApp: Record "Sacco Application") OrgeCode: Code[20]
    var
        Organisation: Record Organisation;
        OrgNo: Code[20];
        NoSeriesManagement: Codeunit "No. Series";
    begin
        Organisation.Init;
        CBSSetup.Get();
        if SaccoApp.Type = SaccoApp.Type::Sacco then
            OrgNo := NoSeriesManagement.GetNextNo(CBSSetup.SaccoNo, TODAY, TRUE);
        if SaccoApp.Type = SaccoApp.Type::Fintech then
            OrgNo := NoSeriesManagement.GetNextNo(CBSSetup.FintechNo, TODAY, TRUE);
        if SaccoApp.Type = SaccoApp.Type::Merchant then
            OrgNo := NoSeriesManagement.GetNextNo(CBSSetup.MerchantNo, TODAY, TRUE);
        if SaccoApp.Type = SaccoApp.Type::Acquirer then
            OrgNo := NoSeriesManagement.GetNextNo(CBSSetup.AgentNo, TODAY, TRUE);
        Organisation."No." := OrgNo;
        Organisation."Full Name" := SaccoApp."Full Name";
        Organisation.Type := SaccoApp.Type;
        Organisation."Phone No." := SaccoApp."Phone No.";
        Organisation."PIN No." := SaccoApp."PIN No.";
        Organisation."Fintech Account" := SaccoApp."Fintech Account";
        Organisation."Agent Account" := SaccoApp."Agent Account";
        Organisation."E-mail" := SaccoApp."E-mail";
        Organisation."Postal Address" := SaccoApp."Postal Address";
        Organisation."Type Of Sacco" := SaccoApp."Type Of Sacco";
        Organisation.Website := SaccoApp.Website;
        Organisation.Mission := SaccoApp.Mission;
        Organisation.Vision := SaccoApp.Vision;
        Organisation.Town := SaccoApp.Town;
        Organisation."Physical Address" := SaccoApp."Physical Address";
        Organisation.ContactPerson := SaccoApp.ContactPerson;
        Organisation."Post code" := SaccoApp."Post code";
        Organisation."Country of Residence" := SaccoApp."Country of Residence";
        Organisation.County := SaccoApp.County;
        Organisation.Longitude := SaccoApp.Longitude;
        Organisation.applicationNo := SaccoApp."No.";
        Organisation.merchantType := SaccoApp."Merchant Type";
        Organisation.MerchantSaccoNo := SaccoApp."Merchant Sacco No";
        Organisation.MerchantSaccoName := SaccoApp."Merchant Sacco Name";
        Organisation.SaccoNo := SaccoApp."Sacco Account No";
        Organisation."Agent Account" := SaccoApp."Agent Account";
        Organisation."Agent Name" := SaccoApp."Agent Name";
        Organisation.Lattitude := SaccoApp.Lattitude;
        Organisation."GPS Location Name" := SaccoApp."GPS Location Name";
        Organisation.Status := SaccoApp.Status::Active;
        Organisation.AgencyTarget := SaccoApp.AgencyTarget;
        Organisation.Insert;
        UpdateSaccoServiceSubscription(SaccoApp, OrgNo);
        exit(OrgNo);


    end;

    procedure UpdateSaccoServiceSubscription(SaccoApp: Record "Sacco Application"; OrgNo: code[10])
    var
        EntityServiceSubscription: Record "Entity Service Subscription";
        EntityServiceSubscripted: Record "Entity Service Subscripted";
    begin

        EntityServiceSubscription.Reset();
        EntityServiceSubscription.SetRange("Application No.", SaccoApp."No.");
        if EntityServiceSubscription.FindSet() then begin
            repeat
                EntityServiceSubscripted.Init();
                EntityServiceSubscripted."Application No." := EntityServiceSubscription."Application No.";
                EntityServiceSubscripted."Account Type" := EntityServiceSubscription."Account Type";
                EntityServiceSubscripted.EntityNo := OrgNo;
                EntityServiceSubscripted.Description := EntityServiceSubscription.Description;
                EntityServiceSubscripted.Status := EntityServiceSubscription.Status;
                EntityServiceSubscripted."Maximum Amount" := EntityServiceSubscription."Maximum Amount";
                EntityServiceSubscripted."Minimum Amount" := EntityServiceSubscription."Minimum Amount";
                EntityServiceSubscripted.startDate := EntityServiceSubscription."Start Date";
                EntityServiceSubscripted.endDate := EntityServiceSubscription."End Date";
                EntityServiceSubscripted."Maximum Daily" := EntityServiceSubscription."Maximum Daily";
                EntityServiceSubscripted.EntityName := SaccoApp."Full Name";
                EntityServiceSubscripted.Insert();
            until EntityServiceSubscription.Next() = 0;
        end;
    end;

    procedure SendChangeRequestForApproval(ChangeNo: Code[20])
    var
        ChangeRequestHeader: Record ChangeRequest;
        DocEmail: Codeunit "Document & Email Management";
        MailSubject: Label 'Change Request for Member No: %1 Member Name: %2';
        MailBody: Label 'Dear Team,<br> A change request for Member No: %1 Member Name: %2 has been sent.<br> Below are the details changed: %3 <br><br> Regards, <br> Mentor Sacco Society Limited';
        ChangesDone: Text;
    begin
        if ChangeRequestHeader.Get(ChangeNo) then begin
            ChangeRequestHeader.Status := ChangeRequestHeader.Status::"Pending Approval";
            ChangeRequestHeader.Modify();
        end
    end;

    procedure ApproveChangeRequestForApproval(ChangeNo: Code[20])
    var
        ChangeRequestHeader: Record ChangeRequest;
        DocEmail: Codeunit "Document & Email Management";
        MailSubject: Label 'Change Request for Member No: %1 Member Name: %2';
        MailBody: Label 'Dear Team,<br> A change request for Member No: %1 Member Name: %2 has been sent.<br> Below are the details changed: %3 <br><br> Regards, <br> Mentor Sacco Society Limited';
        ChangesDone: Text;
    begin
        if ChangeRequestHeader.Get(ChangeNo) then begin
            ChangeRequestHeader.Status := ChangeRequestHeader.Status::Approved;
            ChangeRequestHeader.Modify();
        end
    end;


}