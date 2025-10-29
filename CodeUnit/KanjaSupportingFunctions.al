codeunit 50503 kanjaFunctions

{
    trigger
    OnRun()
    begin

    end;

    var
        PostLine: Codeunit "Optimized Gen. Jnl.-Post Line";

        TEMPGenJournalLine: Record "Gen. Journal Line" temporary;
        LineNo: Integer;

        reversalID: Integer;




    procedure getKanjaSaccos(var serviceCode: code[100]): JsonArray
    var
        Details: List of [Text[250]];
        Continue: Boolean;
        Balance: Decimal;
        AccountNo: Code[20];
        VenOnj: JsonObject;
        VenArr: JsonArray;
        Total: Decimal;
        Vendor: Record Vendor;
        found: Boolean;
        EntityServiceSubscripted: Record "Entity Service Subscripted";
        Organisation: Record Organisation;
        saccoName: text[300];
    begin
        clear(VenArr);
        EntityServiceSubscripted.Reset();
        EntityServiceSubscripted.SetLoadFields(EntityNo);
        EntityServiceSubscripted.SetRange("Account Type", ServiceCode);
        EntityServiceSubscripted.SetRange(Status, EntityServiceSubscripted.Status::Active);
        if EntityServiceSubscripted.FindFirst then begin
            found := true;
            repeat
                Organisation.Reset();
                Organisation.SetLoadFields("Full Name");
                if Organisation.Get(EntityServiceSubscripted.EntityNo) then begin
                    saccoName := Organisation."Full Name";
                end;
                clear(VenOnj);
                VenOnj.Add('code', EntityServiceSubscripted.EntityNo);
                VenOnj.Add('name', saccoName);
                VenArr.Add(VenOnj);
            until EntityServiceSubscripted.Next() = 0;
        end;
        exit(VenArr);
    end;

    procedure getKanjaCommisionBalance(saccoCode: Code[100]): JsonArray
    var
        Vendor: Record Vendor;
        VenObj: JsonObject;
        VenArr: JsonArray;
    begin

        Vendor.Reset();
        Vendor.SetAutoCalcFields(Balance);
        Vendor.SetLoadFields("No.", Name, Balance);
        Vendor.SetRange(Commision, true);
        Vendor.SetRange("No.", SaccoCode);
        if Vendor.FindFirst then begin
            repeat
                Clear(VenObj);
                VenObj.Add('accountNo', Vendor."No.");
                VenObj.Add('accountName', Vendor.Name);
                VenObj.Add('Balance', Vendor.Balance);
                VenArr.Add(VenObj);
            until Vendor.Next() = 0;

        end;
        exit(VenArr);
    end;

    procedure getKanjaFloatBalance(saccoCode: Code[100]): JsonArray
    var
        Vendor: Record Vendor;
        VenObj: JsonObject;
        VenArr: JsonArray;
    begin
        Vendor.Reset();
        Vendor.SetAutoCalcFields(Balance);
        Vendor.SetLoadFields("No.", Name, Balance);
        Vendor.SetRange("No.", SaccoCode);
        if Vendor.FindFirst() then begin
            Vendor.CalcFields(Balance);
            repeat
                Clear(VenObj);
                VenObj.Add('accountNo', Vendor."No.");
                VenObj.Add('accountName', Vendor.Name);
                VenObj.Add('Balance', Vendor.Balance);
                VenArr.Add(VenObj);
            until Vendor.Next() = 0;

        end;
        exit(VenArr);
    end;

    procedure createSaccoEntries(sourceSaccoCode: Code[20]; destinationSaccoCode: Code[20]; sourceFintechCode: Code[20]; destinationFintechCode: Code[20]; serviceCode: code[20]; transactionAmount: Decimal; transactionId: CODE[20]; senderMsisdn: Code[20]; recipientMsisdn: Code[20]; recipientName: Code[100]; merchantCode: code[20]; VAR responseCode: Code[20]; VAR responseMessage: Text; VAR payload: Text): JsonObject
    var
        Details: List of [Text[250]];
        Continue: Boolean;
        Balance: Decimal;
        AccountNo: Code[20];
        Total: Decimal;
        Vendor: Record Vendor;
        found: Boolean;
        ChargesAmount: Decimal;
        DeductionAmount: Decimal;
        SaccoBalance: Decimal;
        SaccoTransactionManagement: Record "Sacco Transaction Management";
        receiptNo: code[20];
        CBSSetup: Record "Sales & Receivables Setup";
        NoSeriesManagement: Codeunit "No. Series";
        Organization: Record Organisation;
        SSaccoCode: code[20];
        RSaccoCode: code[20];
        sendSaccoName: Code[250];
        receiveSacconame: code[250];
        ServiceType: Record "Services Type";
        entityServices: Record "Entity Service Subscripted";
        saccoObj: JsonObject;
        DescriptionSetup: Record DescriptionSetUp;
        KanjaSetup: Record KanjaSetUps;
        Cbs: Record "CBS Setup";
        BalAccount: code[20];
        Members: Record Members;
        MemberDetails: Record MemberDetails;
        SenderMemberName: Code[100];
        ReeiverMemberName: Code[100];
        ServiceName: Code[30];
        SourceFintechMb: Code[30];
        SourceFintechCbs: Code[30];
        receivingFintechMb: Code[30];
        receivingFintechCbs: Code[30];

    begin
        Cbs.Get();
        ServiceType.Reset();
        ServiceType.SetLoadFields(Code);
        if not ServiceType.Get(serviceCode) then begin
            responseCode := '01';
            responseMessage := 'invalid service code';
            saccoObj.WriteTo(payload);
            exit;
        end;
        if ServiceType.Get(serviceCode) then begin
            if ServiceType.Active = false then begin
                responseCode := '01';
                responseMessage := 'service type is inactive';
                saccoObj.WriteTo(payload);
                exit;
            end;
            ServiceName := ServiceType.Description;
        end;
        entityServices.Reset();
        entityServices.SetRange("Account Type", serviceCode);
        entityServices.SetRange(EntityNo, sourceSaccoCode);
        if entityServices.FindFirst() then begin
            if transactionAmount > entityServices."Maximum Amount" then begin
                responseCode := '01';
                responseMessage := 'Transacted Amount is above limit';
                saccoObj.WriteTo(payload);
                exit;
            end;
        end;
        if recipientName = '' then begin
            recipientName := 'N/a';
        end;
        Members.Reset();
        Members.SetRange("Mobile Phone No", senderMsisdn);
        Members.SetRange(EntityCode, sourceSaccoCode);
        Members.SetRange(Status, Members.Status::Active);
        if not Members.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'Member not active';
            saccoObj.WriteTo(payload);
            exit;
        end;

        Members.Reset();
        Members.SetRange("Mobile Phone No", senderMsisdn);
        Members.SetRange(EntityCode, sourceSaccoCode);
        if not Members.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'Member not Subcribed to Kanja sacco';
            saccoObj.WriteTo(payload);
            exit;
        end else begin
            SenderMemberName := Members.firstName;
            ReeiverMemberName := Members.firstName;

        end;

        Organization.Reset();
        Organization.SetLoadFields("No.");
        if Organization.Get(sourceSaccoCode) then begin
            entityServices.Reset();
            entityServices.SetRange(EntityNo, Organization."No.");
            entityServices.SetRange("Account Type", serviceCode);
            if not entityServices.FindFirst() then begin
                responseCode := '01';
                responseMessage := 'Not Subscribed to the service';
                saccoObj.WriteTo(payload);
                exit;
            end;
        end;
        if KanjaSetup.Get(KanjaSetup.Type::M2B) then begin
            if serviceCode <> KanjaSetup.Description then begin
                Organization.Reset();
                if Organization.Get(destinationSaccoCode) then begin
                    entityServices.Reset();
                    entityServices.SetRange(EntityNo, Organization."No.");
                    entityServices.SetRange("Account Type", serviceCode);
                    if not entityServices.FindFirst() then begin
                        responseCode := '01';
                        responseMessage := 'Not Subscribed to the service';
                        saccoObj.WriteTo(payload);
                        exit;
                    end;
                end;
            END;
        END;

        SaccoTransactionManagement.Reset();
        SaccoTransactionManagement.SetLoadFields("Externa Doc No");
        SaccoTransactionManagement.SetRange("Externa Doc No", transactionId);
        if SaccoTransactionManagement.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'Duplicate Transaction';
            saccoObj.WriteTo(payload);
            exit;
        end;

        Vendor.Reset();
        Vendor.SetLoadFields(Name);
        Vendor.SetRange(OrgCode, sourceSaccoCode);
        Vendor.SetRange(Commision, false);
        if not Vendor.FindFirst() then begin
            ResponseCode := '01';
            responseMessage := 'The Sending Sacco Does not exist';
            saccoObj.WriteTo(payload);
            exit
        end else begin
            sendSaccoName := Vendor.Name;
        end;
        if KanjaSetup.Get(KanjaSetup.Type::MKM) then begin
            if serviceCode <> KanjaSetup.Description then begin
                if KanjaSetup.Get(KanjaSetup.Type::M2B) then begin
                    if serviceCode <> KanjaSetup.Description then begin
                        Vendor.Reset();
                        Vendor.SetLoadFields(Name, "No.");
                        Vendor.SetRange(OrgCode, destinationSaccoCode);
                        Vendor.SetRange(Commision, false);
                        if not Vendor.FindFirst() then begin
                            ResponseCode := '01';
                            responseMessage := 'The Receiving Sacco Does not exist';
                            saccoObj.WriteTo(payload);
                            exit
                        end else begin
                            receiveSacconame := Vendor.Name;
                            RSaccoCode := Vendor."No.";
                        end;
                    end;
                end;
            END;
        END;
        Vendor.Reset();
        Vendor.SetLoadFields(Balance, "No.");
        Vendor.SetRange(OrgCode, sourceSaccoCode);
        Vendor.SetRange(Commision, false);
        if Vendor.FindFirst() then begin
            Vendor.CalcFields(Balance);
            SaccoBalance := Vendor.Balance;
            SSaccoCode := Vendor."No.";
            if transactionAmount > Vendor.Balance then begin
                ResponseCode := '01';
                responseMessage := 'Insuffient Float Balance';
                saccoObj.WriteTo(payload);
                exit;
            end;
            if KanjaSetup.Get(KanjaSetup.Type::M2M) then begin
                if serviceCode = KanjaSetup.Description then begin
                    ChargesAmount := Getcharges(serviceCode, transactionAmount);
                    DeductionAmount := ChargesAmount + transactionAmount;
                    if DeductionAmount > SaccoBalance then begin
                        ResponseCode := '01';
                        responseMessage := 'Insuffient  Float Balance to cater for charges';
                        saccoObj.WriteTo(payload);
                        exit;
                    end;
                end;
            end;
            if KanjaSetup.Get(KanjaSetup.Type::M2B) then begin
                if serviceCode = KanjaSetup.Description then begin
                    ChargesAmount := Getcharges(serviceCode, transactionAmount);
                    DeductionAmount := ChargesAmount + transactionAmount;
                    BalAccount := Cbs."Settlement Bank Account";
                    if DeductionAmount > SaccoBalance then begin
                        ResponseCode := '01';
                        responseMessage := 'Insuffient  Float Balance to cater for charges';
                        saccoObj.WriteTo(payload);
                        exit;
                    end;
                end;
            end;
            Organization.Reset();
            Organization.SetRange("No.", merchantCode);
            Organization.SetRange(merchantType, Organization.merchantType::"Kanja Merchant");
            if Organization.FindFirst() then begin
                Vendor.Reset();
                Vendor.SetLoadFields("No.", Name);
                Vendor.SetRange(OrgCode, merchantCode);
                Vendor.SetRange(Commision, false);
                if Vendor.FindFirst() then begin
                    RSaccoCode := Vendor."No.";
                    receiveSacconame := Vendor.Name;
                end;
            end else begin
                Organization.Reset();
                Organization.SetRange("No.", merchantCode);
                Organization.SetRange(merchantType, Organization.merchantType::"Sacco Merchant");
                if Organization.FindFirst() then begin
                    Vendor.Reset();
                    Vendor.SetLoadFields("No.", Name, FintechAccount);
                    Vendor.SetRange(OrgCode, Organization.MerchantSaccoNo);
                    Vendor.SetRange(Commision, false);
                    if Vendor.FindFirst() then begin
                        RSaccoCode := Vendor."No.";
                        receiveSacconame := Vendor.Name;
                        destinationFintechCode := Vendor.FintechAccount;
                    end;
                end;

            end;
        end;
        Organization.Reset();
        if Organization.Get(RSaccoCode) then begin
            entityServices.Reset();
            entityServices.SetRange(EntityNo, Organization."No.");
            entityServices.SetRange("Account Type", serviceCode);
            if not entityServices.FindFirst() then begin
                responseCode := '01';
                responseMessage := 'Not Subscribed to the service';
                saccoObj.WriteTo(payload);
            end;
        end;
        //getsource and rceiving fintech cbs
        getSourceFintech(sourceSaccoCode, SourceFintechMb, SourceFintechCbs);
        getSourceFintech(destinationSaccoCode, receivingFintechMb, receivingFintechCbs);
        //Error('%1..%2..%3', sourceSaccoCode, SourceFintechMb, SourceFintechCbs);
        SaccoTransactionManagement.Init();
        CBSSetup.Reset();
        CBSSetup.get;
        receiptNo := NoSeriesManagement.GetNextNo(CBSSetup."Reminder Nos.", TODAY, TRUE);
        SaccoTransactionManagement."Receipt No" := receiptNo;
        SaccoTransactionManagement."Associated Bank Account" := SSaccoCode;
        // if DescriptionSetup.Get(DescriptionSetup.DocumentSource::"Sacco Entries Description") then
        //    SaccoTransactionManagement."Transaction Description" := StrSubstNo(DescriptionSetup.Description, receiveSacconame, sendSaccoName);
        SaccoTransactionManagement."Received Amount" := transactionAmount;
        if DescriptionSetup.Get(DescriptionSetup.DocumentSource::SendingSaccoDescription) then
            SaccoTransactionManagement."Transaction Description" := CopyStr(StrSubstNo(DescriptionSetup.Description, ServiceName, SenderMemberName, sendSaccoName, recipientName, receiveSacconame), 1, 100);
        if DescriptionSetup.Get(DescriptionSetup.DocumentSource::ReceivingSaccoDescription) then
            SaccoTransactionManagement."Receiving Sacco Description" := CopyStr(StrSubstNo(DescriptionSetup.Description, ServiceName, SenderMemberName, sendSaccoName, recipientName), 1, 100);
        SaccoTransactionManagement."Sacco No" := RSaccoCode;
        SaccoTransactionManagement."RecSaccoCode No" := destinationSaccoCode;
        SaccoTransactionManagement."Sacco Code" := sourceSaccoCode;
        SaccoTransactionManagement."Externa Doc No" := transactionId;
        SaccoTransactionManagement.SenderCode := senderMsisdn;
        SaccoTransactionManagement.MerchantCode := merchantCode;
        SaccoTransactionManagement."Sending Sacco Name" := sendSaccoName;
        SaccoTransactionManagement."Sacco Name" := receiveSacconame;
        SaccoTransactionManagement.RecepientCode := recipientMsisdn;
        SaccoTransactionManagement.ServiceCode := serviceCode;
        SaccoTransactionManagement.BalAccount := BalAccount;
        SaccoTransactionManagement."SendFintech Code" := sourceFintechCode;

        SaccoTransactionManagement."RecFintech Code" := destinationFintechCode;
        SaccoTransactionManagement."Intitiating Fintech Cbs" := SourceFintechCbs;
        SaccoTransactionManagement."Intitiating Fintech Mb" := SourceFintechMb;
        SaccoTransactionManagement."Receiving Fintech Mb" := receivingFintechMb;
        SaccoTransactionManagement."Receiving Fintech Cbs" := receivingFintechCbs;
        SaccoTransactionManagement."Created By" := UserId;
        SaccoTransactionManagement."Created Date" := Today;
        SaccoTransactionManagement."Created Time" := Time + 10800000;
        if SaccoTransactionManagement.Insert(true) then begin
            //Error('%1..%2', SaccoTransactionManagement."SendFintech Code", SaccoTransactionManagement."RecFintech Code");
            responsecode := '00';
            responseMessage := 'Success';
            saccoObj.Add('transactionRef', receiptNo);
            saccoObj.WriteTo(payload);
            EXIT;
        end else begin
            responseCode := '01';
            responseMessage := 'Unsuccessfull transaction';
            saccoObj.WriteTo(payload);
            exit;
        end;
        exit(saccoObj);
    end;

    procedure Getcharges(TransactionType: Code[20]; SendingAmount: Decimal) TotalChargeAmount: Decimal
    var
        Charges: Record "Charges Table";
        ChargesRange: Record "Charges Range";
        ChargeDetails: Record " Charge Details";
        ChargeAmount: Decimal;
        TransactionCharges: Record "Transaction Charge";
        TotalCharges: Decimal;
    begin

        TransactionCharges.Reset();
        TransactionCharges.SetRange(Code, TransactionType);
        IF TransactionCharges.FindSet() THEN begin
            repeat
                if (SendingAmount >= TransactionCharges."Minimum Amount") AND (SendingAmount <= TransactionCharges."Maximum Amount") then begin
                    TotalCharges := TransactionCharges."Total Charge Amount";

                end;
            until TransactionCharges.Next() = 0;
        END;
        Charges.Reset();
        Charges.SetRange(Code, TransactionType);
        IF Charges.FindSet then begin
            repeat
                IF Charges."Calculation Mode" = Charges."Calculation Mode"::"% of Transcation" then
                    ChargeAmount := TotalCharges * Charges.Value / 100;
                IF Charges."Calculation Mode" = Charges."Calculation Mode"::"Flat Amount" then
                    ChargeAmount := Charges.Value;
                IF Charges."Calculation Mode" = Charges."Calculation Mode"::Range then begin
                    ChargesRange.Reset();
                    ChargesRange.SetRange("Charge Code", Charges.Code);
                    if ChargesRange.FindSet then begin
                        repeat
                            if ((SendingAmount >= ChargesRange."Minimum Amount") and (SendingAmount <= ChargesRange."Maximum Amount")) then begin
                                ChargeAmount := ChargesRange."Value Amount";
                            end;
                        until ChargesRange.Next() = 0;
                    end;
                end;
                TotalChargeAmount += ChargeAmount;

            until Charges.Next = 0;

        end;




    end;

    procedure getSourceFintech(SourceSaccoCode: Code[30]; var SourceFintechCbs: Code[30]; var sourceFintechMb: Code[30])
    var
        Fintech: Record Fintechs;
        Organization: Record Organisation;
    begin
        if Organization.Get(SourceSaccoCode) then begin
            Fintech.Reset();
            Fintech.SetRange(applNo, Organization.applicationNo);
            if Fintech.FindSet() then begin
                repeat
                    if Fintech."Fintech Type" = Fintech."Fintech Type"::Cbs then
                        SourceFintechCbs := Fintech.fintechCode;
                    if Fintech."Fintech Type" = Fintech."Fintech Type"::"Mobile Banking" then
                        sourceFintechMb := Fintech.fintechCode
                until Fintech.Next() = 0;
            end;
        end;

    end;

    procedure CreateJournalLines(TemplateName: Code[20]; BatchName: Code[20]; DocumentNo: Code[20]; AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20];
                                                                                                                                BalAccountType: Enum "Gen. Journal Account Type";
                                                                                                                                BalAccountNo: Code[20];
                                                                                                                                Amount: Decimal;
                                                                                                                                Description: Text[250];
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

    procedure PostJournalLine(): Boolean

    begin

        if TEMPGenJournalLine.Count() > 0 then begin
            PostLine.Run(TEMPGenJournalLine);
            exit(true);
        end;
    end;

    local procedure PostGenJournalLine(): Boolean
    begin
        if TEMPGenJournalLine.Count > 0 then begin
            reversalID := PostLine.RunWithMobileBanking(TEMPGenJournalLine);
            exit(true);
        end else begin
            Error('Nothing to Post!');
        end;
    end;



    procedure postSaccoTransaction(transactionId: Code[20]; Post: Code[20]; VAR responseCode: Code[20]; VAR responseMessage: Text)

    var
        TemplateName: Code[20];
        BatchName: Code[20];
        AccountType: Enum "Gen. Journal Account Type";
        BalAccountNo: Code[20];
        BranchCode: Code[20];
        TRX: Record "Sacco Transaction Management";
        Charges: Record "Charges Table";
        ChargesRange: Record "Charges Range";
        ChargeDetails: Record " Charge Details";
        ChargeAmount: Decimal;
        SendingAmount: Decimal;
        ChargeAccountNo: code[20];
        employee: Record Employee;
        ChargeAccountType: Enum "Gen. Journal Account Type";
        vendorxxx: Record Vendor;
        ChargeDescription: text[100];
        Servicecode: code[20];
        Organisation: Record Organisation;
        exciseGl: Code[100];
        exciseAccountType: Code[100];
        exciseAmount: Decimal;
        exciseDescription: Code[100];
        Total: Decimal;
        TransactionCharges: Record "Transaction Charge";
        TransactionAmount: Decimal;
        TotalCharges: Decimal;
        vendor2: Record Vendor;
        DescriptionSetup: Record DescriptionSetUp;
        CbsSetup: Record "CBS Setup";
        KanjaFunc: Codeunit kanjaFunctions;
        KanjaSetup: Record KanjaSetUps;
        EntitiesPercent: Decimal;
        RemainingAmount: Decimal;
        ChargeAcc: Decimal;
        ChargesCbs: Record "CBS Charges Table";
        ReceivingAmount: Decimal;
    //SendingAmount: Decimal;


    begin
        CbsSetup.Get();
        Total := 0;
        ChargeAmount := 0;
        CbsSetup.TestField("Kanja General Batch Name");
        CbsSetup.TestField("Kanja General Template Name");
        TemplateName := CbsSetup."Kanja General Template Name";
        BatchName := CbsSetup."Kanja General Batch Name";
        IF Post = 'TRUE' THEN BEGIN
            LineNo := 1000;
            IF TRX.GET(TransactionID) THEN BEGIN
                Servicecode := TRX.ServiceCode;
                if trx.Posted = true then
                    Error('The document has been posted');
                TransactionAmount := TRX."Received Amount";
                TransactionCharges.Reset();
                TransactionCharges.SetLoadFields("Total Charge Amount");
                TransactionCharges.SetRange(Code, Servicecode);
                IF TransactionCharges.FindSet() THEN begin
                    repeat
                        if (TransactionAmount >= TransactionCharges."Minimum Amount") AND (TransactionAmount <= TransactionCharges."Maximum Amount") then begin
                            TotalCharges := TransactionCharges."Total Charge Amount";
                        end;
                    until TransactionCharges.Next() = 0;
                END;

                if KanjaSetup.Get(KanjaSetup.Type::M2B) then
                    if Servicecode = KanjaSetup.Description THEN BEGIN
                        CreateJournalLines(TemplateName, BatchName, Trx."Externa Doc No", AccountType::Vendor, Trx."Associated Bank Account", AccountType::"G/L Account", BalAccountNo, Trx."Received Amount", Trx."Transaction Description", BranchCode);
                        CreateJournalLines(TemplateName, BatchName, Trx."Externa Doc No", AccountType::"Bank Account", Trx.BalAccount
                        , AccountType::"G/L Account", BalAccountNo, -Trx."Received Amount", Trx."Transaction Description", BranchCode);
                        //KanjaFunc.createChargesEntries(TRX."Receipt No", TRX."Externa Doc No", Servicecode, TRX.SenderCode, TRX."Transaction Description", TRX."Received Amount", 0, TRX."Sacco Code");
                    END ELSE begin
                        CreateJournalLines(TemplateName, BatchName, Trx."Externa Doc No", AccountType::Vendor, Trx."Associated Bank Account", AccountType::"G/L Account", BalAccountNo, Trx."Received Amount", Trx."Transaction Description", BranchCode);
                        CreateJournalLines(TemplateName, BatchName, Trx."Externa Doc No", AccountType::Vendor, Trx."Sacco No", AccountType::"G/L Account", BalAccountNo, -Trx."Received Amount", Trx."Transaction Description", BranchCode);
                        //KanjaFunc.createChargesEntries(TRX."Receipt No", TRX."Externa Doc No", Servicecode, TRX.SenderCode, TRX."Transaction Description", TRX."Received Amount", 0, TRX."Sacco Code");
                    end;
                //sms charge
                // Error('%1..%2', TRX."SendFintech Code", TRX."Receiving Fintech Mb");
                if CbsSetup."Check Percentage" = true then begin
                    EntitiesPercent := (CbsSetup."Entities Percentage" * TotalCharges) / 100;
                    RemainingAmount := TotalCharges - EntitiesPercent;
                end else begin
                    EntitiesPercent := TotalCharges;
                    RemainingAmount := TotalCharges;
                end;
                Charges.Reset();
                Charges.SetLoadFields(Value);
                Charges.SetRange(Code, Servicecode);
                IF Charges.FindSet then begin
                    repeat
                        IF Charges."Calculation Mode" = Charges."Calculation Mode"::"Flat Amount" then
                            ChargeAmount := Charges.Value;
                        IF Charges."Calculation Mode" = Charges."Calculation Mode"::"% of Transcation" then
                            ChargeAmount := EntitiesPercent * Charges.Value / 100;
                        IF Charges."Calculation Mode" = Charges."Calculation Mode"::Range then begin
                            ChargesRange.Reset();
                            ChargesRange.SetLoadFields("Value Amount");
                            ChargesRange.SetRange("Charge Code", Charges.Code);
                            if ChargesRange.FindSet then begin
                                repeat
                                    if ((Trx."Received Amount" >= ChargesRange."Minimum Amount") and (Trx."Received Amount" <= ChargesRange."Maximum Amount")) then begin
                                        ChargeAmount := ChargesRange."Value Amount";
                                    end;
                                until ChargesRange.Next() = 0;
                            end;
                        end;
                        if Charges."Charge Type" = Charges."Charge Type"::Sms then begin
                            ChargeAcc := ChargeAmount;
                            TotalCharges := TotalCharges - ChargeAcc;
                        end;
                    until Charges.Next() = 0;

                end;


                Servicecode := TRX.ServiceCode;
                Charges.Reset();
                Charges.SetLoadFields(Value);
                Charges.SetRange(Code, Servicecode);
                IF Charges.FindSet then begin
                    repeat
                        if Charges."Applies to" = true then begin
                            IF Charges."Calculation Mode" = Charges."Calculation Mode"::"Flat Amount" then
                                ChargeAmount := Charges.Value;
                            IF Charges."Calculation Mode" = Charges."Calculation Mode"::"% of Transcation" then
                                ChargeAmount := EntitiesPercent * Charges.Value / 100;
                            IF Charges."Calculation Mode" = Charges."Calculation Mode"::Range then begin
                                ChargesRange.Reset();
                                ChargesRange.SetLoadFields("Value Amount");
                                ChargesRange.SetRange("Charge Code", Charges.Code);
                                if ChargesRange.FindSet then begin
                                    repeat
                                        if ((Trx."Received Amount" >= ChargesRange."Minimum Amount") and (Trx."Received Amount" <= ChargesRange."Maximum Amount")) then begin
                                            ChargeAmount := ChargesRange."Value Amount";
                                        end;
                                    until ChargesRange.Next() = 0;
                                end;
                            end;
                        end else begin
                            IF Charges."Calculation Mode" = Charges."Calculation Mode"::"Flat Amount" then
                                ChargeAmount := Charges.Value;
                            IF Charges."Calculation Mode" = Charges."Calculation Mode"::"% of Transcation" then
                                ChargeAmount := RemainingAmount * Charges.Value / 100;
                            IF Charges."Calculation Mode" = Charges."Calculation Mode"::Range then begin
                                ChargesRange.Reset();
                                ChargesRange.SetLoadFields("Value Amount");
                                ChargesRange.SetRange("Charge Code", Charges.Code);
                                if ChargesRange.FindSet then begin
                                    repeat
                                        if ((Trx."Received Amount" >= ChargesRange."Minimum Amount") and (Trx."Received Amount" <= ChargesRange."Maximum Amount")) then begin
                                            ChargeAmount := ChargesRange."Value Amount";
                                        end;
                                    until ChargesRange.Next() = 0;
                                end;
                            end;
                        end;
                        if Charges."Charge Type" = Charges."Charge Type"::Sms then begin
                            ChargeAccountNo := Charges."Account No.";
                            ChargeAccountType := Charges."Account Type";
                            ChargeDescription := Charges."Charge Description";
                        end;
                        if Charges."Charge Type" = Charges."Charge Type"::Ketsa then begin
                            ChargeAccountNo := Charges."Account No.";
                            ChargeAccountType := Charges."Account Type";
                            ChargeDescription := Charges."Charge Description";
                        end;
                        if Charges."Charge Type" = Charges."Charge Type"::Tl then begin
                            ChargeAccountNo := Charges."Account No.";
                            ChargeAccountType := Charges."Account Type";
                            ChargeDescription := Charges."Charge Description";
                        end;

                        if Charges."Charge Type" = Charges."Charge Type"::SENFintech then begin
                            SendingAmount := RemainingAmount;
                            // end;
                            IF TRX."Intitiating Fintech Cbs" = '' THEN begin
                                vendorxxx.Reset();
                                vendorxxx.SetLoadFields("No.");
                                if vendorxxx.Get(Trx."SendFintech Code") then begin
                                    ChargeAccountType := ChargeAccountType::Vendor;
                                    ChargeAccountNo := vendorxxx."No.";
                                    ChargeDescription := Charges."Charge Description" + ' ' + vendorxxx.Name;
                                    // Error('%1', ChargeAmount);
                                end;
                            end ELSE begin
                                //  Error('KJNKJ N');
                                ChargesCbs.Reset();
                                ChargesCbs.SetRange("Charge Type", Charges."Charge Type");
                                if ChargesCbs.FindSet() then begin
                                    repeat
                                        IF ChargesCbs."Calculation Mode" = ChargesCbs."Calculation Mode"::"% of Transcation" then
                                            ChargeAmount := SendingAmount * ChargesCbs.Value / 100;
                                        ChargeAccountType := ChargeAccountType::Vendor;
                                        //  ChargeDescription := ChargesCbs."Charge Description";
                                        if ChargesCbs."Fintech Type" = ChargesCbs."Fintech Type"::"Sending Fintech Cbs" then begin
                                            vendorxxx.Reset();
                                            vendorxxx.SetLoadFields("No.");
                                            if vendorxxx.Get(Trx."Intitiating Fintech Cbs") then begin
                                                // ChargeAccountType := ChargeAccountType::Vendor;
                                                ChargeAccountNo := vendorxxx."No.";
                                                ChargeDescription := Charges."Charge Description" + ' ' + vendorxxx.Name;
                                            end;
                                        end;
                                        if ChargesCbs."Fintech Type" = ChargesCbs."Fintech Type"::"Sending Fintech M-Banking" then begin
                                            vendorxxx.Reset();
                                            vendorxxx.SetLoadFields("No.");
                                            if vendorxxx.Get(Trx."Intitiating Fintech Mb") then begin
                                                // ChargeAccountType := ChargeAccountType::Vendor;
                                                ChargeAccountNo := vendorxxx."No.";
                                                ChargeDescription := Charges."Charge Description" + ' ' + vendorxxx.Name;
                                            end;
                                        end;
                                        KanjaFunc.createChargesEntries(TRX."Receipt No", TRX."Externa Doc No", Servicecode, TRX.SenderCode, ChargeDescription, TRX."Received Amount", ChargeAmount, ChargeAccountNo);
                                        CreateJournalLines(TemplateName, BatchName, Trx."Externa Doc No", ChargeAccountType, ChargeAccountNo, AccountType::"G/L Account", BalAccountNo, -ChargeAmount, ChargeDescription, BranchCode);
                                        Total += ChargeAmount;
                                    UNTIL ChargesCbs.Next() = 0;
                                END;
                                if ChargeAmount > 0 then begin
                                    ChargeAmount := 0;
                                end;
                            END;
                        end;
                        if Charges."Charge Type" = Charges."Charge Type"::SENSacco then begin
                            vendorxxx.Reset();
                            vendorxxx.SetLoadFields(OrgCode);
                            if vendorxxx.Get(TRX."Associated Bank Account") then begin
                                vendor2.Reset();
                                vendor2.SetLoadFields("No.");
                                vendor2.SetRange(OrgCode, vendorxxx.OrgCode);
                                vendor2.SetRange(Commision, true);
                                if vendor2.FindFirst() then begin
                                    ChargeAccountNo := vendor2."No.";
                                    ChargeAccountType := ChargeAccountType::Vendor;
                                    ChargeDescription := Charges."Charge Description" + ' ' + vendor2.Name;
                                end;
                            end;
                        end;
                        if Charges."Charge Type" = Charges."Charge Type"::REAgent then begin
                            Organisation.Reset();
                            Organisation.SetLoadFields("Agent Account");
                            if Organisation.Get(TRX.MerchantCode) then begin
                                ChargeAccountNo := Organisation."Agent Account";
                                ChargeAccountType := ChargeAccountType::Vendor;
                                ChargeDescription := Charges."Charge Description" + ' ' + Organisation."Full Name";
                            end;
                        end;
                        if Charges."Charge Type" = Charges."Charge Type"::REmerchant then begin
                            vendorxxx.Reset();
                            vendorxxx.SetLoadFields("No.");
                            if vendorxxx.Get(TRX.MerchantCode) then begin
                                ChargeAccountNo := vendorxxx."No.";
                                ChargeAccountType := ChargeAccountType::Vendor;
                                ChargeDescription := Charges."Charge Description" + ' ' + vendorxxx.Name;

                            end;
                        end;


                        if Charges."Charge Type" = Charges."Charge Type"::Kanja then begin
                            ChargeAccountNo := Charges."Account No.";
                            ChargeAccountType := ChargeAccountType::"G/L Account";
                            ChargeDescription := Charges."Charge Description";
                            exciseGl := Charges.ExciseGl;
                            //   Error('%1..%2', ChargeAccountNo, exciseGl);
                            exciseAmount := (Charges."% of transaction" * ChargeAmount) / 100;
                            exciseDescription := Charges."Excise Description";
                            CreateJournalLines(TemplateName, BatchName, Trx."Externa Doc No", AccountType::"G/L Account", ChargeAccountNo, AccountType::"G/L Account", BalAccountNo, exciseAmount, exciseDescription, BranchCode);
                            CreateJournalLines(TemplateName, BatchName, Trx."Externa Doc No", AccountType::"G/L Account", exciseGl, AccountType::"G/L Account", BalAccountNo, -exciseAmount, exciseDescription, BranchCode);
                        end;


                        if Charges."Charge Type" = Charges."Charge Type"::RECFintech then begin
                            ReceivingAmount := RemainingAmount;
                            IF TRX."Receiving Fintech Mb" = '' THEN begin
                                vendorxxx.Reset();
                                vendorxxx.SetLoadFields("No.");
                                if vendorxxx.Get(Trx."RecFintech Code") then begin
                                    ChargeAccountType := ChargeAccountType::Vendor;
                                    ChargeAccountNo := vendorxxx."No.";
                                    ChargeDescription := Charges."Charge Description" + ' ' + vendorxxx.Name;
                                    // Error('%1', ChargeAmount);
                                end;
                            end ELSE begin
                                //  Error('KJNKJ N');
                                ChargesCbs.Reset();
                                ChargesCbs.SetRange("Charge Type", Charges."Charge Type");
                                if ChargesCbs.FindSet() then begin
                                    repeat
                                        IF ChargesCbs."Calculation Mode" = ChargesCbs."Calculation Mode"::"% of Transcation" then
                                            ChargeAmount := ReceivingAmount * ChargesCbs.Value / 100;
                                        ChargeAccountType := ChargeAccountType::Vendor;
                                        //  ChargeDescription := ChargesCbs."Charge Description";
                                        if ChargesCbs."Fintech Type" = ChargesCbs."Fintech Type"::"Receiving Fintech CbS" then begin
                                            vendorxxx.Reset();
                                            vendorxxx.SetLoadFields("No.");
                                            if vendorxxx.Get(Trx."Receiving Fintech Cbs") then begin
                                                // ChargeAccountType := ChargeAccountType::Vendor;
                                                ChargeAccountNo := vendorxxx."No.";
                                                ChargeDescription := Charges."Charge Description" + ' ' + vendorxxx.Name;
                                            end;
                                        end;
                                        if ChargesCbs."Fintech Type" = ChargesCbs."Fintech Type"::"Receiving Fintech M-Banking" then begin
                                            vendorxxx.Reset();
                                            vendorxxx.SetLoadFields("No.");
                                            if vendorxxx.Get(Trx."Receiving Fintech Mb") then begin
                                                // ChargeAccountType := ChargeAccountType::Vendor;
                                                ChargeAccountNo := vendorxxx."No.";
                                                ChargeDescription := Charges."Charge Description" + ' ' + vendorxxx.Name;
                                            end;
                                        end;
                                        KanjaFunc.createChargesEntries(TRX."Receipt No", TRX."Externa Doc No", Servicecode, TRX.SenderCode, ChargeDescription, TRX."Received Amount", ChargeAmount, ChargeAccountNo);
                                        CreateJournalLines(TemplateName, BatchName, Trx."Externa Doc No", ChargeAccountType, ChargeAccountNo, AccountType::"G/L Account", BalAccountNo, -ChargeAmount, ChargeDescription, BranchCode);
                                        Total += ChargeAmount;
                                    UNTIL ChargesCbs.Next() = 0;
                                END;
                                if ChargeAmount > 0 then begin
                                    ChargeAmount := 0;
                                end;
                            end;

                        end;
                        if Charges."Charge Type" = Charges."Charge Type"::RECSacco then begin
                            ChargeAccountType := ChargeAccountType::Vendor;
                            vendorxxx.Reset();
                            if vendorxxx.Get(TRX."Sacco No") then begin
                                vendor2.Reset();
                                vendor2.SetLoadFields("No.");
                                vendor2.SetRange(OrgCode, vendorxxx.OrgCode);
                                vendor2.SetRange(Commision, true);
                                if vendor2.FindFirst() then
                                    ChargeAccountNo := vendor2."No.";
                                ChargeAccountType := ChargeAccountType::Vendor;
                                ChargeDescription := Charges."Charge Description" + ' ' + vendor2.Name;

                            end;
                        end;
                        if ChargeAmount > 0 then
                            KanjaFunc.createChargesEntries(TRX."Receipt No", TRX."Externa Doc No", Servicecode, TRX.SenderCode, ChargeDescription, TRX."Received Amount", ChargeAmount, ChargeAccountNo);

                        CreateJournalLines(TemplateName, BatchName, Trx."Externa Doc No", ChargeAccountType, ChargeAccountNo, AccountType::"G/L Account", BalAccountNo, -ChargeAmount, ChargeDescription, BranchCode);
                        Total += ChargeAmount;
                    until Charges.Next = 0;
                end;
                //Error('%1..%2', Total, TotalCharges + ChargeAcc);
                if Total > TotalCharges + ChargeAcc then begin
                    responseCode := '01';
                    responseMessage := StrSubstNo('Charge Amount cannt be greater than %1', TotalCharges);
                    // Error('Charge Amount cannt be greater than %1', TotalCharges);
                end;
                if DescriptionSetup.Get(DescriptionSetup.DocumentSource::"Total Withdrawable Charges") then
                    ChargeDescription := DescriptionSetup.Description;
                CreateJournalLines(TemplateName, BatchName, Trx."Externa Doc No", AccountType::Vendor, Trx."Associated Bank Account", AccountType::"G/L Account", BalAccountNo, Total, ChargeDescription, BranchCode);
                if PostGenJournalLine = true then
                    Trx.Posted := true;
                trx."Posted By" := UserId;
                TRX.Status := TRX.Status::Posted;
                TRX."Posting Date" := Today;
                // Error('%1', reversalID);
                TRX.TransId := reversalID;
                Trx.Modify;
                responseCode := '00';
                responseMessage := 'Posted Succesfully';
                exit;
            end else begin
                responseCode := '01';
                responseMessage := 'Posting Failed';
                exit;
            end;
        END;

        IF POST = 'FALSE' THEN begin
            IF TRX.GET(TransactionID) THEN BEGIN
                TRX.Status := TRX.Status::Reversed;
                if TRX.Modify(TRUE) then begin
                    responseCode := '00';
                    ResponseMessage := 'Reversed successfully ';
                END
                else BEGIN
                    responseCode := '01';
                    ResponseMessage := 'Reversal Failed';
                END;


            end;
        end;
    end;

    procedure calculateReceivingFintech("Charge Type": Enum "Charge Type")
    var
        Charges: Record "CBS Charges Table";
    begin
        Charges.Reset();
        Charges.SetRange("Charge Type", "Charge Type");
        if Charges.FindSet() then begin

            if Charges."Fintech Type" = Charges."Fintech Type"::"Receiving Fintech CbS" then begin

            end;
        end;

    end;

    procedure createMerchant(var name: text; var entityType: text; var merchantType: Text; var saccoCode: Text; var accountNo: Text; var physicalAddress: text; var officialEmail: text; var officialPhone: Text; var kraPin: text; var salesAgent: text; var country: text; var region: text; var subRegion: text; var postalAddress: text; var postalCode: text; var longitude: text; var latitude: Text; var gpsLocationName: text; var responseCode: text; var responseMessage: text; var payload: text)
    var
        DocumentsSetup: Record DocumentTypesSetup;
        MerchantsTable: Record "Sacco Application";
        EntityTypes: Option;
        applicationNo: Code[100];
        NoSeriesManagement: Codeunit "No. Series";
        CBSSetup: Record "CBS Setup";
        DocumentTypes: Record DocumentTypes;
        found: Boolean;
        ServiceTypes: Record "Services Type";
        Documents: Record DocumentTypes;
        EntityService: Record "Entity Service Subscription";
        jsonObj: JsonObject;
        jsonArray: JsonArray;
        jsonObj1: JsonObject;
        KanjaSetup: Record KanjaSetUps;

    begin
        if name = '' then begin
            responseCode := '01';
            responseMessage := 'name must be inputted';
            jsonObj1.WriteTo(payload);
            exit;
        end;
        if entityType = '' then begin
            responseCode := '01';
            responseMessage := 'entity type must be inputted';
            jsonObj1.WriteTo(payload);
            exit;
        end;
        MerchantsTable.Reset();
        MerchantsTable.SetRange("PIN No.", kraPin);
        if MerchantsTable.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'Kra Pin Already Exist';
            jsonObj1.WriteTo(payload);
            exit;
        end;
        CBSSetup.Get();
        MerchantsTable.Reset();
        MerchantsTable."No." := NoSeriesManagement.GetNextNo(CBSSetup."MA Individual Nos.", TODAY, true);
        applicationNo := MerchantsTable."No.";
        MerchantsTable."Full Name" := name;
        MerchantsTable."Physical Address" := physicalAddress;
        MerchantsTable."E-mail" := officialEmail;
        MerchantsTable."Phone No." := officialPhone;
        MerchantsTable."PIN No." := kraPin;
        MerchantsTable."Country of Residence" := country;
        MerchantsTable."Postal Address" := postalAddress;
        MerchantsTable.Longitude := longitude;
        MerchantsTable.Lattitude := latitude;
        MerchantsTable."GPS Location Name" := gpsLocationName;
        MerchantsTable."Merchant Sacco No" := salesAgent;
        if KanjaSetup.Get(KanjaSetup.Type::Merchant) then begin
            if entityType = KanjaSetup.Description then begin
                //if entityType = 'Merchant' then begin
                MerchantsTable.Type := MerchantsTable.Type::Merchant;
            end;
        end;
        MerchantsTable.PostingGroup := Format(MerchantsTable.Type);
        if KanjaSetup.Get(KanjaSetup.Type::kanjaMerchant) then begin
            if merchantType = KanjaSetup.Description then begin
                //if merchantType = 'kanjaMerchant' then begin
                MerchantsTable."Merchant Type" := MerchantsTable."Merchant Type"::"Kanja Merchant";
                EntityService.Reset();
                EntityService.SetLoadFields("Application No.");
                EntityService.SetRange("Application No.", applicationNo);
                if not EntityService.FindFirst() then begin
                    ServiceTypes.Reset();
                    ServiceTypes.SetRange(Code, 'MKM');
                    IF ServiceTypes.FindFirst() THEN begin
                        EntityService.Init();
                        EntityService."Account Type" := ServiceTypes.Code;
                        EntityService.Status := EntityService.Status::Active;
                        EntityService.EntityName := ServiceTypes.Code;
                        EntityService.Description := ServiceTypes.Description;
                        EntityService."Minimum Amount" := ServiceTypes."Minimum  Amount";
                        EntityService."Maximum Amount" := ServiceTypes."Maximum Amount";
                        EntityService."Maximum Daily" := ServiceTypes."Maximum Daily  Amount";
                        EntityService."Application No." := applicationNo;
                        EntityService.Insert();
                    end;
                end;
            end;
        end;
        if MerchantsTable.Insert() then begin
            DocumentsSetup.Reset();
            DocumentsSetup.SetLoadFields(EntityType);
            DocumentsSetup.SetRange(entityType, MerchantsTable.Type);
            if DocumentsSetup.FindFirst then begin
                DocumentTypes.Reset();
                DocumentTypes.SetLoadFields(DocumentType, RequiresAttachment);
                DocumentTypes.SetRange(codes, DocumentsSetup.Nos);
                if DocumentTypes.Findset() then begin
                    found := TRUE;
                    jsonObj1.Add('applicationNo', applicationNo);
                    REPEAT
                        Clear(jsonObj);
                        jsonObj.Add('code', Format(DocumentsSetup.EntityType));
                        jsonObj.Add('documentDescription', FORMAT(DocumentTypes.DocumentType));
                        jsonObj.Add('requireAttachment', Format(DocumentTypes.RequiresAttachment));
                        jsonArray.Add(jsonObj);

                    UNTIL DocumentTypes.NEXT = 0;
                    jsonObj1.Add('attachmentRequired', jsonArray);
                    jsonObj1.WriteTo(payload);
                    responseCode := '00';
                    responseMessage := 'Merchant Created Successfully';
                    exit;
                end;

            end;
        end else begin
            responseCode := '01';
            responseMessage := 'Merchant not created';
            payload := '{}';
            exit;
        end;

    end;


    procedure stageOwnSettlement(entityCode: Code[100]; fromAccountNumber: Code[100]; toAccountNumber: Code[100]; payBillNumber: code[100]; accountType: code[100]; transactionAmount: Decimal; description: Code[100]; transactionId: code[100]; var responseCode: Text; var responseMessage: text; var payload: text): JsonObject
    var
        SettlementTable: Record SettlementTable;
        CBSSetup: Record "Sales & Receivables Setup";
        receiptNo: Code[100];
        NoSeriesManagement: Codeunit "No. Series";
        Vendor: Record Vendor;
        BankDetails: Record BankDetails;
        orgCode: Code[100];
        Organization: Record Organisation;
        Paybill: Record Paybill;
        AccountTypes: Enum settlementType;
        Cbs: Record "CBS Setup";
        Balance: Decimal;
        settlementCharges: Record Settlement;
        settlementChargesSetup: Record "Settlement Charges";
        TotalCharges: Decimal;
        mpesaCharges: Decimal;
        kanjaCharges: Decimal;
        settleAmount: Decimal;
        transactAamount: Decimal;
        settlementSetup: Record SettlementTypeCharges;
        ChargeAmount: decimal;
        jsonObj: JsonObject;
        exciseDuty: Decimal;
        exciseGl: Code[100];
        exciseAmount: Decimal;
        TotalCharge: Decimal;
        SaccoNo: Code[20];
        DescriptionSetup: Record DescriptionSetUp;


    begin

        if (accountType <> '0') AND (accountType <> '1') AND (accountType <> '2') AND (accountType <> '3') AND (accountType <> '4') then begin
            responseCode := '01';
            responseMessage := 'Invalid accountType';
            jsonObj.WriteTo(payload);
            exit;
        end;
        SettlementTable.Reset();
        SettlementTable.SetRange("Externa Doc No", transactionId);
        if SettlementTable.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'Duplicate Transaction';
            jsonObj.WriteTo(payload);
            exit;
        end;
        Vendor.Reset();
        Vendor.SetRange("No.", entityCode);
        Vendor.SetRange(Commision, true);
        if not Vendor.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'invalid entity code';
            jsonObj.WriteTo(payload);
            exit;
        end;
        Vendor.Reset();
        Vendor.SetLoadFields("No.");
        Vendor.SetRange("No.", fromAccountNumber);
        Vendor.SetRange(Commision, true);
        if not Vendor.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'invalid source account number';
            jsonObj.WriteTo(payload);
            exit;
        end else begin
            orgCode := Vendor."No.";
        end;

        if accountType in ['0'] then begin
            AccountTypes := AccountTypes::BANK;
            BankDetails.Reset();
            BankDetails.SetRange(AccounNo, toAccountNumber);
            if not BankDetails.FindFirst() then begin
                responseCode := '01';
                responseMessage := 'invalid destination account number';
                jsonObj.WriteTo(payload);
                exit;
            end;
            BankDetails.Reset();
            BankDetails.SetRange(paybillNumber, payBillNumber);
            if not BankDetails.FindFirst() then begin
                responseCode := '01';
                responseMessage := 'invalid paybill number';
                jsonObj.WriteTo(payload);
                exit;
            end;

        end;
        if accountType in ['1'] then begin
            AccountTypes := AccountTypes::PHONE;
            Organization.Reset();
            Organization.SetRange("Phone No.", toAccountNumber);
            if not Organization.FindFirst() then begin
                responseCode := '01';
                responseMessage := 'invalid phone number';
                jsonObj.WriteTo(payload);
                exit;
            end;
        end;
        if accountType in ['2'] then begin
            AccountTypes := AccountTypes::PAY_BILL;
            Paybill.Reset();
            Paybill.SetRange(paybillNo, payBillNumber);
            if not Paybill.FindFirst() then begin
                responseCode := '01';
                responseMessage := 'invalid paybill number';
                jsonObj.WriteTo(payload);
                exit;
            end;
        end;

        if accountType in ['3'] then begin
            if fromAccountNumber = toAccountNumber then begin
                responseCode := '01';
                responseMessage := 'Source and destination account must not be the same';
                jsonObj.WriteTo(payload);
                exit;
            end;
            AccountTypes := AccountTypes::KANJA_ACCOUNT;
            Vendor.Reset();
            Vendor.SetRange("No.", toAccountNumber);
            Vendor.SetRange(Commision, false);
            if not Vendor.FindFirst() then begin
                responseCode := '01';
                responseMessage := 'invalid Kanja Account';
                jsonObj.WriteTo(payload);
                exit;
            end;
        end;
        if accountType in ['4'] then begin
            AccountTypes := AccountTypes::SACCO_ACCOUNT;
            Organization.Reset();
            Organization.SetLoadFields("No.");
            Organization.SetRange(SaccoNo, toAccountNumber);
            if Organization.FindFirst() then begin
                SaccoNo := Organization."No.";
            end ELSE begin
                responseCode := '01';
                responseMessage := 'invalid Sacco Account';
                jsonObj.WriteTo(payload);
                exit;
            end;
        end;

        Vendor.Reset();
        Vendor.SetAutoCalcFields(Balance);
        Vendor.SetLoadFields(Balance);
        Vendor.SetRange("No.", fromAccountNumber);
        Vendor.SetRange(Commision, true);
        if Vendor.FindFirst() then begin
            Balance := Vendor.Balance;
        end;
        if transactionAmount = 0 then begin
            if Balance > 0 then begin
                transactAamount := Balance;
            end;
        END ELSE begin
            transactAamount := transactionAmount;
        end;

        settlementChargesSetup.Reset();
        settlementChargesSetup.SetLoadFields("Excise %", "Excise G/L Account", "Deduct Excise Duty");
        settlementChargesSetup.SetRange(settlementTypes, AccountTypes);
        IF settlementChargesSetup.FindSet() THEN begin
            if settlementChargesSetup."Deduct Excise Duty" = true then begin
                exciseDuty := settlementChargesSetup."Excise %";
                exciseGl := settlementChargesSetup."Excise G/L Account";
                ChargeAmount := (transactAamount * exciseDuty);
            end;
            settlementSetup.Reset();
            settlementSetup.SetRange(settlementTypes, settlementChargesSetup.settlementTypes);
            if settlementSetup.Findset() then begin
                repeat
                    if settlementSetup."Calculation Method" = settlementSetup."Calculation Method"::"Based Flat Amount" then begin
                        ChargeAmount := settlementSetup.Value;
                    end;
                    if settlementSetup."Calculation Method" = settlementSetup."Calculation Method"::"Based on %" then begin
                        settlementCharges.Reset();
                        settlementCharges.SetRange(settlementTypes, settlementSetup.settlementTypes);
                        if settlementCharges.FindSet() then begin
                            repeat
                                if (transactAamount >= settlementCharges."Minimum Amount") AND (transactAamount <= settlementCharges."Maximum Amount") then begin
                                    ChargeAmount := (settlementCharges."Total Charge Amount") / 100 * transactAamount;
                                end;
                            until settlementCharges.Next() = 0;
                        end;
                    end;

                    if settlementSetup."Calculation Method" = settlementSetup."Calculation Method"::Range then begin
                        settlementCharges.Reset();
                        settlementCharges.SetRange(settlementTypes, settlementSetup.settlementTypes);
                        if settlementCharges.FindSet() then begin
                            repeat
                                if (transactAamount >= settlementCharges."Minimum Amount") AND (transactAamount <= settlementCharges."Maximum Amount") then begin
                                    ChargeAmount := settlementCharges."Total Charge Amount";
                                end;
                            until settlementCharges.Next() = 0;
                        end;
                    end;
                    TotalCharges += ChargeAmount;
                until settlementSetup.Next() = 0;
            end;
        end;

        if transactionAmount = 0 then begin
            transactAamount -= TotalCharges;
            IF transactAamount <= 0 then begin
                responseCode := '01';
                responseMessage := 'insufficient Balance';
                jsonObj.WriteTo(payload);
                exit;
            end;
        end;
        if transactionAmount <> 0 then begin
            IF TotalCharges + transactAamount > Balance then begin
                responseCode := '01';
                responseMessage := 'insufficient Balance';
                jsonObj.WriteTo(payload);
                exit;
            end;
        end;
        SettlementTable.Init();
        CBSSetup.Reset();
        CBSSetup.get;
        Cbs.Reset();
        Cbs.Get();
        receiptNo := NoSeriesManagement.GetNextNo(CBSSetup."Reminder Nos.", TODAY, TRUE);
        SettlementTable."Receipt No" := receiptNo;
        if DescriptionSetup.Get(DescriptionSetup.DocumentSource::"Stage Own") then
            SettlementTable."Transaction Description" := StrSubstNo(DescriptionSetup.Description, toAccountNumber, entityCode);
        SettlementTable."Received Amount" := transactAamount;
        SettlementTable."Externa Doc No" := transactionId;
        SettlementTable.sourceAccountNumber := fromAccountNumber;
        SettlementTable.toAccountNumber := toAccountNumber;
        SettlementTable.paybillNumber := payBillNumber;
        SettlementTable.Types := Format(AccountTypes);
        SettlementTable."Created By" := UserId;
        SettlementTable."Created Date" := Today;
        SettlementTable."Created Time" := Time + 10800000;
        SettlementTable.isStagedToOwn := true;
        SettlementTable.balAccount := Cbs."Settlement Bank Account";
        SettlementTable.entityCode := entityCode;
        if SettlementTable.Insert(true) then begin
            responsecode := '00';
            jsonObj.Add('transactionId', Format(receiptNo));
            jsonObj.WriteTo(payload);
            responseMessage := 'Settlement for amount Ksh: ' + Format(transactAamount) + ' initiated successfully';
        end else begin
            responseCode := '01';
            responseMessage := 'Unsuccessfull transaction';
            jsonObj.WriteTo(payload);
            exit;
        end;
    end;

    procedure stageOtherSettlement(entityCode: Code[100]; fromAccountNumber: Code[100]; toAccountNumber: Code[100]; payBillNumber: code[100]; accountType: code[100]; transactionAmount: Decimal; description: Code[100]; transactionId: code[100]; var responseCode: Text; var responseMessage: text; var payload: text): JsonObject
    var
        SettlementTable: Record SettlementTable;
        CBSSetup: Record "Sales & Receivables Setup";
        receiptNo: Code[100];
        NoSeriesManagement: Codeunit "No. Series";
        Vendor: Record Vendor;
        BankDetails: Record BankDetails;
        orgCode: Code[100];
        Organization: Record Organisation;
        Paybill: Record Paybill;
        AccountTypes: Enum settlementType;
        Cbs: Record "CBS Setup";
        Balance: Decimal;
        settlementCharges: Record Settlement;
        settlementChargesSetup: Record "Settlement Charges";
        TotalCharges: Decimal;
        mpesaCharges: Decimal;
        kanjaCharges: Decimal;
        settlementSetup: Record SettlementTypeCharges;
        ChargeAmount: Decimal;
        jsonObj: JsonObject;
        jsonArray: JsonArray;
        exciseDuty: Decimal;
        exciseGl: Code[100];
        exciseAmount: Decimal;
        TotalCharge: Decimal;
        DescriptionSetup: Record DescriptionSetUp;
        Members: Record Members;
        KanjaWalletAccount: Code[20];
    begin
        //add in setup
        if (accountType <> '0') AND (accountType <> '1') AND (accountType <> '2') AND (accountType <> '3') AND (accountType <> '4') AND (accountType <> '5') then begin
            responseCode := '01';
            responseMessage := 'Invalid accountType';
            jsonObj.WriteTo(payload);
            exit(jsonObj)
        end;
        SettlementTable.Reset();
        SettlementTable.SetRange("Externa Doc No", transactionId);
        if SettlementTable.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'Duplicate Transaction';
            jsonObj.WriteTo(payload);
            exit(jsonObj);
        end;

        Vendor.Reset();
        Vendor.SetRange("No.", entityCode);
        Vendor.SetRange(Commision, true);
        if not Vendor.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'invalid entity code';
            jsonObj.WriteTo(payload);
            exit(jsonObj);
        end;
        Vendor.Reset();
        Vendor.SetRange("No.", fromAccountNumber);
        Vendor.SetRange(Commision, true);
        if not Vendor.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'invalid source account number';
            jsonObj.WriteTo(payload);
            exit(jsonObj);
        end else begin
            orgCode := Vendor."No.";
        end;
        if accountType in ['0'] then begin
            AccountTypes := AccountTypes::BANK;

        end;
        if accountType in ['1'] then begin
            AccountTypes := AccountTypes::PHONE;
        end;
        if accountType in ['2'] then begin
            AccountTypes := AccountTypes::PAY_BILL;
        end;

        if accountType in ['3'] then begin
            if fromAccountNumber = toAccountNumber then begin
                responseCode := '01';
                responseMessage := 'Source account and destination account must not be the same';
                jsonObj.WriteTo(payload);

                exit(jsonObj);
            end;
            AccountTypes := AccountTypes::KANJA_ACCOUNT;
        end;
        if accountType in ['4'] then begin
            AccountTypes := AccountTypes::SACCO_ACCOUNT;
        end;
        if accountType in ['5'] then begin
            AccountTypes := AccountTypes::KANJA_WALLET;
            Members.Reset();
            if not Members.Get(toAccountNumber) then begin
                responseCode := '01';
                responseMessage := 'invalid Kanja id';
                jsonObj.WriteTo(payload);
                exit;
            end;
            //find the Wallet Account
            Members.Reset();
            if Members.Get(toAccountNumber) then begin
                Vendor.Reset();
                Vendor.SetRange("Vendor Type", Vendor."Vendor Type"::"Member Account");
                Vendor.SetRange(MemberNo, toAccountNumber);
                if Vendor.FindFirst() then begin
                    KanjaWalletAccount := Vendor."No.";
                end;
            end;
        end;
        Vendor.Reset();
        Vendor.SetAutoCalcFields(Balance);
        Vendor.SetLoadFields(Balance);
        Vendor.SetRange("No.", fromAccountNumber);
        Vendor.SetRange(Commision, true);
        if Vendor.FindFirst() then begin
            Balance := Vendor.Balance;
        end;
        TransactionAmount := transactionAmount;
        settlementChargesSetup.Reset();
        settlementChargesSetup.SetLoadFields("Excise %", "Excise G/L Account", "Deduct Excise Duty");
        settlementChargesSetup.SetRange(settlementTypes, AccountTypes);
        IF settlementChargesSetup.FindSet() THEN begin
            if settlementChargesSetup."Deduct Excise Duty" = true then begin
                exciseDuty := settlementChargesSetup."Excise %";
                exciseGl := settlementChargesSetup."Excise G/L Account";
                ChargeAmount := (transactionAmount * exciseDuty);
            end;
            settlementSetup.Reset();
            settlementSetup.SetRange(settlementTypes, settlementChargesSetup.settlementTypes);
            if settlementSetup.Findset() then begin
                repeat
                    if settlementSetup."Calculation Method" = settlementSetup."Calculation Method"::"Based Flat Amount" then begin
                        ChargeAmount := settlementSetup.Value;
                    end;
                    if settlementSetup."Calculation Method" = settlementSetup."Calculation Method"::"Based on %" then begin
                        ChargeAmount := (settlementSetup.Value * transactionAmount);
                        settlementCharges.Reset();
                        settlementCharges.SetRange(settlementTypes, settlementSetup.settlementTypes);
                        if settlementCharges.FindSet() then begin
                            repeat
                                if (TransactionAmount >= settlementCharges."Minimum Amount") AND (TransactionAmount <= settlementCharges."Maximum Amount") then begin
                                    ChargeAmount := (settlementCharges."Total Charge Amount") / 100 * TransactionAmount;
                                end;
                            until settlementCharges.Next() = 0;
                        end;

                    end;
                    if settlementSetup."Calculation Method" = settlementSetup."Calculation Method"::Range then begin
                        settlementCharges.Reset();
                        settlementCharges.SetRange(settlementTypes, settlementSetup.settlementTypes);
                        if settlementCharges.FindSet() then begin
                            repeat
                                if (TransactionAmount >= settlementCharges."Minimum Amount") AND (TransactionAmount <= settlementCharges."Maximum Amount") then begin
                                    ChargeAmount := settlementCharges."Total Charge Amount";
                                end;
                            until settlementCharges.Next() = 0;

                        end;
                    end;
                    TotalCharges += ChargeAmount;
                until settlementSetup.Next() = 0;
            end;
        end;
        IF TotalCharges + TransactionAmount > Balance then begin
            responseCode := '01';
            responseMessage := 'insufficient Balance';
            jsonObj.WriteTo(payload);

            exit(jsonObj);
        end;
        SettlementTable.Init();
        CBSSetup.Reset();
        CBSSetup.get;
        Cbs.Reset();
        Cbs.Get();
        receiptNo := NoSeriesManagement.GetNextNo(CBSSetup."Reminder Nos.", TODAY, TRUE);
        SettlementTable."Receipt No" := receiptNo;
        if DescriptionSetup.Get(DescriptionSetup.DocumentSource::"Stage Other") then
            SettlementTable."Transaction Description" := StrSubstNo(DescriptionSetup.Description, toAccountNumber, entityCode);
        SettlementTable."Received Amount" := transactionAmount;
        SettlementTable."Externa Doc No" := transactionId;
        SettlementTable.sourceAccountNumber := fromAccountNumber;
        SettlementTable.toAccountNumber := toAccountNumber;
        SettlementTable.paybillNumber := payBillNumber;
        SettlementTable.Types := Format(AccountTypes);
        SettlementTable."Created By" := UserId;
        SettlementTable."Created Date" := Today;
        SettlementTable."Created Time" := Time + 10800000;
        SettlementTable.isStagedToOwn := false;
        SettlementTable.kanjaWalletAccount := KanjaWalletAccount;
        SettlementTable.balAccount := Cbs."Settlement Bank Account";
        SettlementTable.entityCode := entityCode;
        if SettlementTable.Insert(true) then begin
            responsecode := '00';
            jsonObj.Add('transactionId', Format(receiptNo));
            jsonObj.WriteTo(payload);
            responseMessage := 'Transaction initiated successfully';
            EXIT(jsonObj);
        end else begin
            responseCode := '01';
            responseMessage := 'Transaction initiated unsuccessfully';
            jsonObj.WriteTo(payload);
            exit(jsonObj);
        end;

    end;

    procedure PostingSettlementTransaction(transactionId: Code[30]; Post: Code[20]; VAR responseCode: Code[20]; VAR responseMessage: Text)
    var
        Settlement: Record SettlementTable;
        settlementChargesSetup: Record "Settlement Charges";
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
        mpesaDescription: Code[100];
        kanjaDescription: Code[100];
        mpesaCommisionGl: Code[10];
        kanjaCommisonGl: Code[10];
        settlementCharges: Record Settlement;
        exciseDuty: Decimal;
        exciseGl: Code[100];
        kanjaGl: code[100];
        exciseDescription: Code[20];
        exciseAmount: Decimal;
        settlementSetup: Record SettlementTypeCharges;
        chargeAccNo: code[20];
        TotalC: Decimal;
        DescriptionSetup: Record DescriptionSetUp;
        CbsSetup: Record "CBS Setup";
        KanjaFunc: Codeunit kanjaFunctions;
    begin
        CbsSetup.Get();
        Total := 0;
        ChargeAmount := 0;
        CbsSetup.TestField("Kanja General Batch Name");
        CbsSetup.TestField("Kanja General Template Name");
        TemplateName := CbsSetup."Kanja General Template Name";
        BatchName := CbsSetup."Kanja General Batch Name";
        LineNo := 1000;
        IF Post = 'TRUE' THEN BEGIN
            if Settlement.Get(transactionId) then begin
                settleTypes := Settlement.Types;
                if Settlement.Posted = true then
                    Error('The document has been posted');
            end;
            Vendor.Reset();
            Vendor.SetAutoCalcFields(Balance);
            Vendor.SetLoadFields(Balance);
            Vendor.SetRange("No.", Settlement.sourceAccountNumber);
            Vendor.SetRange(Commision, true);
            if Vendor.FindFirst() then begin
                Balance := Vendor.Balance;
            end;
            KanjaFunc.createChargesEntries(Settlement."Receipt No", Settlement."Externa Doc No", settleTypes, '', Settlement."Transaction Description", Settlement."Received Amount", 0, Settlement.sourceAccountNumber);
            if (settleTypes = Format(Settlement.Type::BANK)) OR (settleTypes = Format(Settlement.Type::PAY_BILL)) OR (settleTypes = Format(Settlement.Type::PHONE)) OR (settleTypes = Format(Settlement.Type::SACCO_ACCOUNT)) then begin
                CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::Vendor, Settlement.sourceAccountNumber, AccountType::"G/L Account", BalAccountNo, Settlement."Received Amount", Settlement."Transaction Description", BranchCode);
                CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::"Bank Account",
                 Settlement.balAccount, AccountType::"G/L Account", BalAccountNo, (-1 * Settlement."Received Amount"), Settlement."Transaction Description", BranchCode);

            end;
            if (settleTypes = Format(Settlement.Type::KANJA_WALLET)) then begin
                CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::Vendor, Settlement.sourceAccountNumber, AccountType::"G/L Account", BalAccountNo, Settlement."Received Amount", Settlement."Transaction Description", BranchCode);
                CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::Vendor,
           Settlement.kanjaWalletAccount, AccountType::"G/L Account", BalAccountNo, (-1 * Settlement."Received Amount"), Settlement."Transaction Description", BranchCode);
            end;
            IF (settleTypes = Format(Settlement.Type::KANJA_ACCOUNT)) then begin
                CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::Vendor, Settlement.sourceAccountNumber, AccountType::"G/L Account", BalAccountNo, Settlement."Received Amount", Settlement."Transaction Description", BranchCode);
                CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::Vendor,
                 Settlement.toAccountNumber, AccountType::"G/L Account", BalAccountNo, (-1 * Settlement."Received Amount"), Settlement."Transaction Description", BranchCode);
            end;
            TransactionAmount := Settlement."Received Amount";
            settlementChargesSetup.Reset();
            settlementChargesSetup.SetLoadFields("Settlement Account No.", "Settlement Account No. (Saf)", "Excise %", "Excise G/L Account");
            settlementChargesSetup.SetRange(settlementDescription, settleTypes);
            IF settlementChargesSetup.FindSet() THEN begin
                if DescriptionSetup.Get(DescriptionSetup.DocumentSource::"Total Settlement Charges") then
                    chargesDescription := DescriptionSetup.Description;
                mpesaCommisionGl := settlementChargesSetup."Settlement Account No. (Saf)";
                kanjaCommisonGl := settlementChargesSetup."Settlement Account No.";
                if settlementChargesSetup."Deduct Excise Duty" = true then begin
                    exciseDuty := settlementChargesSetup."Excise %";
                    exciseGl := settlementChargesSetup."Excise G/L Account";
                    exciseDescription := settlementChargesSetup."Excise Discription";
                end;
                settlementSetup.Reset();
                settlementSetup.SetLoadFields(Value);
                settlementSetup.SetRange(settlementTypes, settlementChargesSetup.settlementTypes);
                if settlementSetup.Findset() then begin
                    repeat
                        if settlementSetup."Calculation Method" = settlementSetup."Calculation Method"::"Based Flat Amount" then begin
                            ChargeAmount := settlementSetup.Value;
                        end;
                        if settlementSetup."Calculation Method" = settlementSetup."Calculation Method"::"Based on %" then begin
                            ChargeAmount := (settlementSetup.Value * TransactionAmount) / 100;
                            settlementCharges.Reset();
                            settlementCharges.SetRange(settlementTypes, settlementSetup.settlementTypes);
                            if settlementCharges.FindSet() then begin
                                repeat
                                    if (TransactionAmount >= settlementCharges."Minimum Amount") AND (TransactionAmount <= settlementCharges."Maximum Amount") then begin
                                        ChargeAmount := (settlementCharges."Total Charge Amount") / 100 * TransactionAmount;
                                    end;
                                until settlementCharges.Next() = 0;
                            end;
                        end;

                        if settlementSetup."Calculation Method" = settlementSetup."Calculation Method"::Range then begin
                            settlementCharges.Reset();
                            settlementCharges.SetLoadFields("Total Charge Amount");
                            settlementCharges.SetRange(settlementTypes, settlementSetup.settlementTypes);
                            if settlementCharges.FindSet() then begin
                                repeat
                                    if (TransactionAmount >= settlementCharges."Minimum Amount") AND (TransactionAmount <= settlementCharges."Maximum Amount") then begin
                                        ChargeAmount := settlementCharges."Total Charge Amount";
                                    end;
                                until settlementCharges.Next() = 0;

                            end;
                        end;
                        if settlementSetup.Type = settlementSetup.Type::KanjaCharges then begin
                            exciseAmount := (exciseDuty * ChargeAmount) / 100;
                            chargeAccNo := kanjaCommisonGl;
                            chargesDescription := settlementSetup.settlementDescription;
                            CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::"G/L Account", exciseGl, AccountType::"G/L Account", BalAccountNo, -exciseAmount, exciseDescription, BranchCode);
                            CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::"G/L Account", chargeAccNo, AccountType::"G/L Account", BalAccountNo, exciseAmount, exciseDescription, BranchCode);
                        end;
                        IF settlementSetup.Type = settlementSetup.Type::ThirdPartyCharges then begin
                            chargeAccNo := mpesaCommisionGl;
                            chargesDescription := settlementSetup.settlementDescription;
                        end;
                        KanjaFunc.createChargesEntries(Settlement."Receipt No", Settlement."Externa Doc No", settleTypes, '', chargesDescription, Settlement."Received Amount", ChargeAmount, chargeAccNo);
                        CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::"G/L Account", chargeAccNo
                       , AccountType::"G/L Account", BalAccountNo, (-1 * ChargeAmount), chargesDescription, BranchCode);
                        Total += ChargeAmount;

                    until settlementSetup.Next() = 0;
                end;
            END;
            CreateJournalLines(TemplateName, BatchName, Settlement."Externa Doc No", AccountType::Vendor, Settlement.sourceAccountNumber, AccountType::"G/L Account", BalAccountNo, Total, 'Total settlement Charges', BranchCode);
            if PostJournalLine() then begin
                Settlement.Posted := true;
                Settlement."Posted By" := UserId;
                Settlement.Status := Settlement.Status::Posted;
                Settlement."Posting Date" := Today;
                Settlement.Modify();
                responseCode := '00';
                responseMessage := 'Posted Succesfully';
                exit;
            end else begin
                responseCode := '01';
                responseMessage := 'Posting Failed';
                exit;
            end;
        end;
        IF POST = 'FALSE' THEN begin
            IF Settlement.GET(transactionId) THEN BEGIN
                Settlement.Status := Settlement.Status::Reversed;
                if Settlement.Modify(TRUE) then begin
                    responseCode := '00';
                    ResponseMessage := 'Reversed successfully ';
                    exit;
                END
                else BEGIN
                    responseCode := '01';
                    ResponseMessage := 'Reversal Failed';
                    exit;
                END;
            end;
        end;
    end;

    procedure creatingAgency(var name: text; var entityType: text; var accountNo: Text; var physicalAddress: text; var officialEmail: text; var officialPhone: Text; var kraPin: text; var agencyTarget: Text; var salesAgent: text; var country: text; var region: text; var subRegion: text; var postalAddress: text; var postalCode: text; var longitude: text; var latitude: Text; var gpsLocationName: text; var responseCode: text; var responseMessage: text; var payload: text)
    var
        AgencyTable: Record "Sacco Application";
        applicationNo: Code[100];
        NoSeriesManagement: Codeunit "No. Series";
        CBSSetup: Record "CBS Setup";
        DocumentTypes: Record DocumentTypesSetup;
        Document: Record DocumentTypes;
        found: Boolean;
        jsonObj: JsonObject;
        jsonrray: JsonArray;
        jsonObj1: JsonObject;
        KanjaSetup: Record KanjaSetUps;
    begin
        if name = '' then begin
            responseCode := '01';
            responseMessage := 'name must be inputted';
            jsonObj1.WriteTo(payload);

        end;
        if entityType = '' then begin
            responseCode := '01';
            responseMessage := 'entity type must be inputted';
            jsonObj1.WriteTo(payload);
        end;
        AgencyTable.Reset();
        AgencyTable.SetLoadFields("PIN No.");
        AgencyTable.SetRange("PIN No.", kraPin);
        if AgencyTable.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'Kra Pin Already Exist';
            jsonObj1.WriteTo(payload);
            exit;
        end;
        CBSSetup.Get();
        AgencyTable.Reset();
        AgencyTable."No." := NoSeriesManagement.GetNextNo(CBSSetup."MA Individual Nos.", TODAY, true);
        applicationNo := AgencyTable."No.";
        AgencyTable."Full Name" := name;
        AgencyTable."Physical Address" := physicalAddress;
        AgencyTable."E-mail" := officialEmail;
        AgencyTable."Phone No." := officialPhone;
        AgencyTable."PIN No." := kraPin;
        AgencyTable."Country of Residence" := country;
        AgencyTable."Postal Address" := postalAddress;
        AgencyTable.Longitude := longitude;
        AgencyTable.Lattitude := latitude;
        AgencyTable."GPS Location Name" := gpsLocationName;
        AgencyTable.AgencyTarget := agencyTarget;
        if KanjaSetup.Get(KanjaSetup.Type::Agency) then begin
            if entityType = KanjaSetup.Description then begin
                AgencyTable.Type := AgencyTable.Type::Acquirer;
            end;
        end;
        AgencyTable.PostingGroup := Format(AgencyTable.Type);
        if AgencyTable.Insert() then begin
            DocumentTypes.Reset();
            DocumentTypes.SetLoadFields(EntityType);
            DocumentTypes.SetRange(EntityType, AgencyTable.Type);
            if DocumentTypes.FindFirst() then begin
                Document.Reset();
                Document.SetLoadFields(DocumentType, RequiresAttachment);
                Document.SetRange(codes, DocumentTypes.Nos);
                if Document.FindFirst() then begin
                    jsonObj1.Add('applicationNo', applicationNo);
                    REPEAT
                        Clear(jsonObj);
                        jsonObj.Add('code', FORMAT(DocumentTypes.EntityType));
                        jsonObj.Add('documentDescription', FORMAT(Document.DocumentType));
                        jsonObj.Add('requireAttachment', FORMAT(Document.RequiresAttachment));
                        jsonrray.Add(jsonObj);
                    UNTIL Document.NEXT = 0;
                    responseCode := '00';
                    responseMessage := 'Agency Created Successfully';
                    jsonObj1.Add('attachmentRequired', jsonrray);
                    jsonObj1.WriteTo(payload);
                end;
            end;

        end else begin
            responseCode := '01';
            responseMessage := 'Agency not created';
            jsonObj1.WriteTo(payload);
        end;

    end;

    procedure registerMember(idNo: Text[20]; firstName: Text[30]; middleName: Text[30]; lastName: Text[30]; email: code[80]; phoneNo: Code[20]; entityCode: Code[20]; gender: Text[100]; dob: Text[30]; kraPin: Code[20]; var memberNos: Code[20]; var accountNo: Code[20]; county: code[30]; nationality: code[30]; var responseCode: Text; var responseMessage: Text; var payload: Text)
    var
        Members: Record Members;
        DateOfBirth: Text;
        CbsSetup: Record "CBS Setup";
        NoSeriesManagemnt: Codeunit "No. Series";
        MemberNo: Code[20];
        MemberDetails: Record MemberDetails;
        Organization: Record Organisation;
        SaccoName: Code[30];
        usedKanjaId: Code[20];
        NoSeriesLine: Record "No. Series Line";
        prefix: Integer;
    begin
        Organization.Reset();
        Organization.SetLoadFields("No.");
        if not Organization.Get(entityCode) then begin
            responseCode := '01';
            responseMessage := 'Invalid entity Code';
            payload := '{}';
            exit;
        end else begin
            SaccoName := Organization."Full Name";

        end;
        if idNo = '' then begin
            responseCode := '01';
            responseMessage := 'Invalid ID';
            payload := '{}';
            exit;
        end;
        if phoneNo = '' then begin
            responseCode := '01';
            responseMessage := 'Invalid Phone Number';
            payload := '{}';
            exit;
        end;
        // if dob = '' then begin
        //     responseCode := '01';
        //     responseMessage := 'Invalid dob';
        //     payload := '{}';
        //     exit;
        // end;
        // if firstName = '' then begin
        //     responseCode := '01';
        //     responseMessage := 'Invalid first name';
        //     payload := '{}';
        //     exit;
        // end;
        // if lastName = '' then begin
        //     responseCode := '01';
        //     responseMessage := 'Invalid last name';
        //     payload := '{}';
        //     exit;
        // end;

        // Members.Reset();
        // Members.SetRange(IdNumber, idNo);
        // if Members.FindFirst() then begin
        //     responseCode := '01';
        //     responseMessage := 'Id Exists';
        //     payload := '{}';
        //     exit;
        // end;
        Members.Reset();
        Members.SetRange("Mobile Phone No", phoneNo);
        Members.SetRange(EntityCode, entityCode);
        if Members.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'Member has already subscribed to that entity';
            payload := '{}';
            exit;
        end;
        CbsSetup.Get();
        Members.Reset();
        Members.SetRange("Mobile Phone No", phoneNo);
        Members.SetRange(EntityCode, entityCode);
        if not Members.FindFirst() then begin
            Members.Init();
            usedKanjaId := getLastusedKanjaId();
            IF usedKanjaId = '999999' then begin
            end;
            Members."Kanja Id" := CbsSetup.Prefix + NoSeriesManagemnt.GetNextNo(CbsSetup."Member Nos.", Today, true);
            Members.IdNumber := idNo;
            Members.Email := email;
            Members.EntityCode := entityCode;
            Evaluate(Members.DateOfBirth, dob);
            Members.kraPin := kraPin;
            Members.firstName := firstName;
            Members.middleName := middleName;
            Members.surnameName := lastName;
            Members.accountNo := accountNo;
            Members.county := county;
            Members.nationality := nationality;
            Members.saccoMemberNo := memberNos;
            Members."Mobile Phone No" := phoneNo;
            Members.Gender := gender;
            Members."Date Registered" := Today;
            Members."Sacco Name" := SaccoName;
            Members."Time Regsitered" := Time + 10800000;
            Members.Status := Members.Status::Active;
            if Members.Insert() then begin
                createAccount(Members."Kanja Id", phoneNo, email);
            end;
            responseCode := '00';
            responseMessage := 'Member Registered Successfully';
            payload := '{}';
        end else begin
            responseCode := '01';
            responseMessage := 'Member is already registered to that entity';
            payload := '{}';
        end;
    end;

    procedure createAccount(var MemberNo: Code[20]; var PhoneNo: code[20]; var Email: Code[80])
    var
        Vendor: Record Vendor;
        AccountType: Record "Account Type";
        Member: Record Members;
    begin
        AccountType.Reset();
        AccountType.SetRange(AccountType."Open Automatically", true);
        if AccountType.FindFirst() then begin
            Vendor.Reset();
            Vendor.SetRange(MemberNo, MemberNo);
            if not Vendor.FindFirst() then begin
                Member.Get(MemberNo);
                Vendor.Init();
                Vendor."No." := MemberNo + AccountType."Account Prefix";
                Vendor.Name := AccountType.Description;
                Vendor.MemberNo := MemberNo;
                Vendor."Mobile Phone No." := PhoneNo;
                Vendor."Phone No." := PhoneNo;
                Vendor."E-Mail" := Email;
                Vendor.Status := Vendor.Status::Active;
                Vendor."Vendor Posting Group" := AccountType."Posting Group";
                Vendor."Vendor Type" := Vendor."Vendor Type"::"Member Account";
                Vendor.Insert();
            end;
        end;
    end;

    procedure validateMemberDetail(phoneNos: Code[20]; entityCode: Code[20]; var responseMessage: Text; var responseCode: Text; var payload: text)
    var
        Members: Record Members;
    begin
        Members.Reset();
        Members.SetLoadFields("Mobile Phone No", EntityCode);
        Members.SetRange("Mobile Phone No", phoneNos);
        Members.SetRange(EntityCode, entityCode);
        if Members.FindFirst() then begin
            responseCode := '00';
            responseMessage := 'Member Validated Successfully';
            payload := '{}';
            // exit;
        end else begin
            responseCode := '01';
            responseMessage := 'Invalid Member Details';
            payload := '{}';
            // exit;
        end;
    end;

    procedure validateKanjaDetails(kanjaId: Code[100]; entityCode: Code[100]; var responseCode: Text; var responseMessage: text; var payload: text)
    var
        Members: Record Members;
        MemberDetails: Record MemberDetails;
        Organization: Record Organisation;
    begin
        Members.Reset();
        if not Members.Get(kanjaId) then begin
            responseCode := '01';
            responseMessage := 'invalid Kanja Id';
            payload := '{}';
            exit;
        end;
        Organization.Reset();
        Organization.SetRange("No.", entityCode);
        if not Organization.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'invalid entity Code';
            payload := '{}';
            exit;
        end;
        Members.Reset();
        Members.SetRange("Kanja Id", kanjaId);
        Members.SetRange(EntityCode, entityCode);
        if Members.FindFirst() then begin
            responseCode := '00';
            responseMessage := 'Validated Successfully';

            payload := '{}';
            exit;
        end else begin
            responseCode := '01';
            responseMessage := 'Invalid Kanja Details';
            payload := '{}';
            exit;
        end;

    end;

    procedure createChargesEntries(receiptNo: Code[20]; docNo: Code[30]; service_code: Code[30]; phone_no: Code[20]; transac_Description: Code[100]; receivedAmount: Decimal; commissionAmount: Decimal; entityCode: Code[30])
    var
        ChargesEntries: Record " Charge Details";
    begin
        ChargesEntries.Init();
        // ChargesEntries.EntryNo += 1;
        ChargesEntries.ChargeValue := commissionAmount;
        ChargesEntries."Received Amount" := receivedAmount;
        ChargesEntries."Receipt No." := receiptNo;
        ChargesEntries.DocNo := docNo;
        ChargesEntries."Entity No." := entityCode;
        ChargesEntries."Transaction Description" := transac_Description;
        ChargesEntries."Charge Code" := service_code;
        ChargesEntries."Sender Phone No" := phone_no;
        ChargesEntries.transactionDate := Today;

        ChargesEntries.Insert();
    end;

    procedure ValidateKanjaMember(msisdn: Code[20]; entityCode: Code[20]; VAR responseCode: Text; VAR responseMessage: text; VAR payload: text)
    var
        Members: Record Members;
        MemberDetails: Record MemberDetails;
        Organization: Record Organisation;
        Json: JsonObject;
    begin
        Organization.Reset();
        Organization.SetRange("No.", entityCode);
        if not Organization.FindFirst() then begin
            responseCode := '01';
            responseMessage := 'invalid entity Code';
            payload := '{}';
            exit;
        end;
        Members.Reset();
        Members.SetRange("Mobile Phone No", msisdn);
        Members.SetRange(EntityCode, entityCode);
        if Members.FindFirst() then begin
            responseCode := '00';
            responseMessage := 'Validated Successfully';
            Json.Add('name', Members.firstName);
            Json.Add('kanjaId', Members."Kanja Id");
            Json.Add('status', UpperCase(Format(Members.Status)));
            Json.WriteTo(payload);
        end else begin
            responseCode := '01';
            responseMessage := 'Member not found';
            payload := '{}';
            exit;
        end;

    end;

    procedure fetchService(var serviceCode: Code[20]; entityCode: Code[20]; var responseCode: Text; var responseMessage: text; var payload: text)
    var
        ServiceType: Record "Services Type";
        Organization: Record Organisation;
        ServiceTypeSubscription: Record "Entity Service Subscripted";
        JsonObj: JsonObject;
    begin
        if not ServiceType.Get(serviceCode) then begin
            responseCode := '01';
            responseMessage := 'Invalid Service Code';
            payload := '{}';
            exit;
        end;
        if not Organization.Get(entityCode) then begin
            responseCode := '01';
            responseMessage := 'Invalid Entity Code';
            payload := '{}';
            exit;
        end;
        ServiceTypeSubscription.Reset();
        ServiceTypeSubscription.SetRange("Account Type", serviceCode);
        ServiceTypeSubscription.SetRange(EntityNo, entityCode);
        if ServiceTypeSubscription.FindFirst() then begin
            responseCode := '00';
            responseMessage := 'Validated Succesffuly';
            JsonObj.Add('minimumAmount', ServiceTypeSubscription."Minimum Amount");
            JsonObj.Add('maximumAmount', ServiceTypeSubscription."Maximum Amount");
            JsonObj.Add('maximumDaily', ServiceTypeSubscription."Maximum Daily");
            JsonObj.WriteTo(payload);

        end else begin
            responseCode := '01';
            responseMessage := 'Not Subscribed to the service';
            payload := '{}';
            exit;
        end;

    end;

    procedure processReversal(var RequestID: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: Text; var payload: Text)
    var
        Entries: Record "Sacco Transaction Management";
        Reversal: Codeunit "Reversal Entry";
        GLReg: Record "G/L Register";
    begin
        Entries.Reset();
        Entries.SetRange("Externa Doc No", RequestID);
        if Entries.FindFirst() then begin
            if (Entries.Posted = true) and (Entries.Reversed = false) then begin
                if Entries.TransId > 0 then begin
                    GLReg.Reset();
                    if GLReg.Get(Entries.TransId) then begin
                        if GLReg.Reversed then begin
                            ResponseCode := '01';
                            ResponseMessage := StrSubstNo('Transaction with Request ID:-%1 has been reversed', RequestID);
                            payload := '{}';
                            exit;
                        end else begin
                            if Reversal.ReverseEntries(Entries.TransId) then begin
                                Entries.Reversed := true;
                                Entries.Modify();
                                ResponseCode := '00';
                                ResponseMessage := StrSubstNo('Successfully Reversed %1', RequestID);
                                payload := '{}';
                                exit;
                            end else begin
                                ResponseCode := '01';
                                ResponseMessage := StrSubstNo('%1-%2!', RequestID, GetLastErrorText());
                                payload := '{}';
                                exit;
                            end;
                        end;
                    end else begin
                        ResponseCode := '01';
                        ResponseMessage := StrSubstNo('Transaction with Request ID:-%1 do not exists', RequestID);
                        payload := '{}';
                        exit;
                    end;
                end;
            end else begin
                ResponseCode := '01';
                ResponseMessage := StrSubstNo('Document No: %1 not Found!', RequestID);
                payload := '{}';
                exit;
            end;
        end else begin
            ResponseCode := '01';
            ResponseMessage := StrSubstNo('Document No: %1 not Found!', RequestID);
            payload := '{}';
            exit;
        end;
    end;

    procedure getLastusedKanjaId(): Code[20]
    var
        Members: Record Members;
        Position: Integer;
        KanjaId: code[50];
    begin
        Members.Reset();
        if Members.FindLast() then begin
            Position := StrPos(Members."Kanja Id", '-');
            if Position > 0 then begin
                KanjaId := CopyStr(Members."Kanja Id", Position + 1);
            end;
            exit(KanjaId);
        end;

    end;


    // [EventSubscriber(ObjectType::Table, DATABASE::"Gen. Journal Line", 'OnAfterValidateEvent', 'Amount', true, true)]
    // local procedure OnAfterValidateMemberNoOnLoanRepaymentCardEvent(var Rec: Record "Gen. Journal Line")
    // var
    //     amt1: Decimal;
    // begin
    //     // GetMemberNotification(Rec."Member No.");
    //     // OnBValidateMemberNoOnLoanRepaymentCardEvent(Rec);
    //     // Message(Format(Rec.Amount));
    //     // Rec.Amount := genAmt;
    //     // OnValidateMemberNoOnLoanRepaymentCardEvent(amt1);
    //     Message(Format(GeJournal.Amount));
    //     //Message('test%1', genAmt);
    //     //  Message('afterrr%1', Format(genAmt));
    // end;


    // [EventSubscriber(ObjectType::Table, DATABASE::"Gen. Journal Line", 'OnBeforeValidateEvent', 'Amount', true, true)]
    // local procedure OnBValidateMemberNoOnLoanRepaymentCardEvent(var Rec: Record "Gen. Journal Line")
    // begin
    //     // GetMemberNotification(Rec."Member No.");
    //     //  Message('before...%1', Format(Rec.Amount));
    //     // genAmt := Rec.Amount;
    //     OnValidateMemberNoOnLoanRepaymentCardEvent(rec, GeJournal);
    //     //  Message('%1', genAmt);

    //     GeJournal.Amount := Rec.Amount;
    //     // Message('gvhnvhv h%1', Format(GeJournal.Amount));
    // end;



    // procedure OnValidateMemberNoOnLoanRepaymentCardEvent(Gen1: Record "Gen. Journal Line"; var GeJournal: Record "Gen. Journal Line")
    // begin
    //     // GetMemberNotification(Rec."Member No.");

    //     // genAmt := amt;
    //     // Message(Format(genAmt));
    //     GeJournal := Gen1;

    // end;


    var
        genAmt: Decimal;
        amtgen: Decimal;
        GeJournal: Record "Gen. Journal Line";
}
