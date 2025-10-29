codeunit 50501 "Kanja Transactions test"
{
    trigger OnRun()
    begin
        //  GetKanjaSaccos(ResponseMsg, ResponseCode);

    end;

    var
        ResponseCode: Code[10];
        ResponseMsg: Text[150];
        Success: Boolean;
        Status: Boolean;
        vendor2: Record Vendor;
        ResponseMessage: text;
        phone: Code[10];
        PostLine: Codeunit "Optimized Gen. Jnl.-Post Line";

        TEMPGenJournalLine: Record "Gen. Journal Line" temporary;
        LineNo: Integer;
        KanjaFunctions: Codeunit kanjaFunctions;



    procedure GetKanjaSaccos(ServiceCode: code[20]; VAR responseCode: Code[20]; var responseMessage: Text; VAR payload: Text)
    var
        VenObj: JsonObject;
        EntityServiceSubscripted: Record "Entity Service Subscripted";
        found: Boolean;
        Details: List of [Text[250]];
        Continue: Boolean;
        Balance: Decimal;
        AccountNo: Code[20];
        VenOnj: JsonObject;
        VenArr: JsonArray;
        Total: Decimal;
        Vendor: Record Vendor;
        Organisation: Record Organisation;
        saccoName: text[300];

    begin
        EntityServiceSubscripted.Reset();
        EntityServiceSubscripted.SetRange("Account Type", ServiceCode);
        if EntityServiceSubscripted.FindFirst() then begin
            VenObj.Add('saccos', KanjaFunctions.getKanjaSaccos(ServiceCode));
            responseCode := '00';
            responseMessage := 'sucess';
            VenObj.WriteTo(payload);
            exit;
        end else begin
            responseCode := '01';
            responseMessage := 'Service code invalid';
            payload := '{}';
            exit;
        end;
    end;

    procedure GetKanjaSaccosCommisionBalance(SaccoCode: Code[20]; VAR responseMessage: Text; VAR responsecode: Code[20])
    var
        VenObj: JsonObject;
        Vendor: Record Vendor;
        VenArr: JsonArray;
    begin
        Vendor.Reset();
        if Vendor.Get(SaccoCode) then begin
            IF Vendor.Commision = true then
                VenObj.Add('saccosCommisionBalance', KanjaFunctions.getKanjaCommisionBalance(SaccoCode));
            responseCode := '00';
            VenObj.WriteTo(responseMessage);
            exit;
        end else begin
            responseCode := '01';
            responseMessage := 'Invalid Sacco Code';
            responseMessage := '{}';
            exit;
        end;

    end;

    procedure GetKanjaSaccosFloatBalance(SaccoCode: Code[20]; VAR responseMessage: Text; VAR responsecode: Code[20])
    var
        VenObj: JsonObject;
        Vendor: Record Vendor;
        VenArr: JsonArray;
    begin
        Vendor.Reset();
        if Vendor.Get(SaccoCode) then begin
            IF Vendor.Commision = false then
                VenObj.Add('saccoFloatBalance', KanjaFunctions.getKanjaFloatBalance(SaccoCode));
            responseCode := '00';
            VenObj.WriteTo(responseMessage);
            exit;
        end else begin
            responseCode := '01';
            responseMessage := 'Invalid Sacco Code';
            responseMessage := '{}';
            exit;
        end;

    end;

    procedure CreateSaccoTransactionEntry(sourceSaccoCode: Code[20]; destinationSaccoCode: Code[20]; sourceFintechCode: Code[20]; destinationFintechCode: Code[20]; serviceCode: code[20]; transactionAmount: Decimal; transactionId: CODE[20]; senderMsisdn: Code[20]; recipientMsisdn: Code[20]; recipientName: Code[100]; merchantCode: code[20]; VAR responseCode: Code[20]; VAR responseMessage: Text; VAR payload: Text)
    begin
        KanjaFunctions.createSaccoEntries(sourceSaccoCode, destinationSaccoCode, sourceFintechCode, destinationFintechCode, serviceCode, transactionAmount, transactionId, senderMsisdn, recipientMsisdn, recipientName, merchantCode, responseCode, responseMessage, payload);
    end;

    procedure createMerchants(var name: text; var entityType: text; var merchantType: Text; var saccoCode: Text; var accountNo: Text; var physicalAddress: text; var officialEmail: text; var officialPhone: Text; var kraPin: text; var salesAgent: text; var country: text; var region: text; var subRegion: text; var postalAddress: text; var postalCode: text; var longitude: text; var latitude: Text; var gpsLocationName: text; var responseCode: text; var responseMessage: text; var payload: text)
    var
    begin

        KanjaFunctions.createMerchant(name, entityType, merchantType, saccoCode, accountNo, physicalAddress, officialEmail, officialPhone, kraPin, salesAgent, country, region, subRegion, postalAddress, postalCode, longitude, latitude, gpsLocationName, responseCode, responseMessage, payload);

    end;

    procedure validateMerchant(var merchantCode: Code[100]; var responseCode: Text; var responseMessage: Text; var payload: Text)
    var
        Organization: Record Organisation;
        Organization2: Record Organisation;
        merchantType: Text;
        sacco: Record "Sacco Application";
        saccoCode: Code[100];
        accountNo: Code[100];
        Found: Boolean;
        EntityService: Record "Entity Service Subscripted";
        EntityServices: Record "Entity Service Subscripted";
        applNo: Code[100];
        fintechCode: Code[100];
        SaccoCodes: Code[100];
        jsonObj: JsonObject;
        KanjaSetup: Record KanjaSetUps;

    begin
        Organization.Reset();
        Organization.SetLoadFields("No.", "Full Name", SaccoNo, MerchantSaccoNo, "Fintech Account");
        if Organization.Get(merchantCode) then begin
            SaccoCodes := Organization.MerchantSaccoNo;
            if Organization2.get(SaccoCodes) then begin
                fintechCode := Organization2."Fintech Account";
            end;
            IF Organization.merchantType = Organization.merchantType::"Kanja Merchant" then begin
                if KanjaSetup.Get(KanjaSetup.Type::KANJA_MERCHANT) then
                    merchantType := KanjaSetup.Description;
            end;
            IF Organization.merchantType = Organization.merchantType::"Sacco Merchant" then begin
                if KanjaSetup.Get(KanjaSetup.Type::SACCO_MERCHANT) then
                    merchantType := KanjaSetup.Description;
            end;

            if merchantType <> '' then begin
                jsonObj.Add('code', Organization."No.");
                jsonObj.Add('storeName', Organization."Full Name");
                jsonObj.Add('type', merchantType);
                jsonObj.Add('msisdn', Organization."Phone No.");
                jsonObj.Add('accountNumber', Organization.SaccoNo);
                jsonObj.Add('saccoCode', Organization.MerchantSaccoNo);
                // jsonObj.Add('fintechCode', fintechCode);
                jsonObj.WriteTo(payload);
                responseCode := '00';
            end;
        end else begin
            responseCode := '01';
            responseMessage := 'Merchant Code is invalid';
            jsonObj.WriteTo(payload);
            exit;
        end;

    end;

    procedure uploadDocument(var referenceNumber: Text; var documentId: Code[100]; var type: Text; var responseCode: Text; var responseMessage: Text; VAR payload: Text)
    var
        uploadedDoc: Record ViewDocument;
        uploadedDoc1: Record ViewDocument;
        SaccoAppl: Record "Sacco Application";
        OrgCode: Code[100];
        FosaManagement: Codeunit "FOSA Management";
        DocumentTypes: Record DocumentTypes;
        DocumentDetails: Record "Document Attachment";
        DocumentDetails2: Record "Document Attachment";
        webservice: Record "Web Service Aggregate";
        CbsSetUp: Record "CBS Setup";
    begin
        CbsSetUp.Get();
        uploadedDoc1.Reset();
        uploadedDoc1.SetRange(ApplicationNo, referenceNumber);
        uploadedDoc1.SetRange(DocumentType, type);
        if not uploadedDoc1.FindFirst() then begin
            uploadedDoc.Init();
            uploadedDoc.ApplicationNo := referenceNumber;
            uploadedDoc.DocumentType := type;
            uploadedDoc.DocumentId := documentId;
            //ADD A SETUP FOR EDMS URL.
            uploadedDoc.DocumentPath := CbsSetUp.EdmsPath + '{' + documentId + '}';
            if uploadedDoc.Insert() then begin
                DocumentDetails.Reset();
                DocumentDetails.SetLoadFields("No.", Type);
                DocumentDetails.SetRange("No.", referenceNumber);
                DocumentDetails.SetRange(Type, type);
                if not DocumentDetails.FindFirst() then begin
                    DocumentDetails.Init();
                    DocumentDetails.Validate("No.", referenceNumber);
                    DocumentDetails."Table ID" := Database::"Sacco Application";
                    DocumentDetails.Type := type;
                    DocumentDetails."No." := referenceNumber;
                    DocumentDetails.Validate("No.", referenceNumber);
                    DocumentDetails.EdmsPath := uploadedDoc.DocumentPath;
                    DocumentDetails.Insert();
                end;
                responseCode := '00';
                responseMessage := 'Document Uploaded Successfully';
                payload := '{}';
            end else begin
                responseCode := '01';
                responseMessage := 'Document not uploaded';
                payload := '{}';
                exit;
            end;
        end else begin
            responseCode := '01';
            responseMessage := 'Document already uploaded';
            payload := '{}';
            exit;
        end;
    end;

    procedure activateEntity(var referenceNumber: Text; var responseCode: Text; var responseMessage: Text; VAR payload: text)
    var
        uploadedDoc: Record ViewDocument;
        SaccoAppl: Record "Sacco Application";
        OrgCode: Code[100];
        FosaManagement: Codeunit "FOSA Management";
        DocumentTypes: Record DocumentTypes;
        jsonObj: JsonObject;
    begin
        if SaccoAppl.Get(referenceNumber) then begin
            SaccoAppl.Status := SaccoAppl.Status::Approved;
            SaccoAppl.Modify();
            OrgCode := FosaManagement.CreateOrganisation(SaccoAppl);
            FosaManagement.CreateSaccoAccount(SaccoAppl, OrgCode);
            responsecode := '00';
            jsonObj.Add('entityCode', OrgCode);
            jsonObj.WriteTo(payload);
        end else begin
            responseCode := '01';
            responseMessage := 'Application Number does not exist';
            jsonObj.WriteTo(payload);
        end;
    end;

    procedure fetchWithdrawalAccounts(var entityCode: Text; var responseCode: Text; var responseMessage: Text; var payload: Text)
    var
        Vendor: Record Vendor;
        found: Boolean;
        position: Text;
        jsonObj: JsonObject;
        jsonArray: JsonArray;
        Position1: Integer;
        List: List of [Text];
        ListOfEntity: Text;
        i: Integer;
        Entities: Text;
        start: Integer;
        section: Text;
    begin
        List := entityCode.Split(',');
        for i := 1 to List.Count() do begin
            section := List.Get(i);
            if section <> '' then begin
                Vendor.Reset();
                Vendor.SetAutoCalcFields(Balance);
                Vendor.SetLoadFields("No.", Name, Balance, OrgCode);
                Vendor.SetRange("No.", section);
                Vendor.SetRange(Commision, true);
                if Vendor.FindSet() then begiN
                    Vendor.CalcFields(Balance);
                    repeat
                        Clear(jsonObj);
                        jsonObj.Add('accountName', Vendor.Name);
                        jsonObj.Add('entityCode', Vendor.OrgCode);
                        jsonObj.Add('accountNumber', Vendor."No.");
                        jsonObj.Add('accountBalance', Vendor.Balance);
                        jsonArray.Add(jsonObj);
                    until Vendor.Next() = 0;
                    responseCode := '00';
                    responseMessage := 'success';
                    // jsonArray.WriteTo(payload);
                    // exit;
                end else begin
                    responseCode := '01';
                    responseMessage := 'Account not found';
                    jsonArray.WriteTo(payload);
                end;

            end;
        end;
        jsonArray.WriteTo(payload);
        exit;
    end;



    procedure fetchAllWithdrawalAccounts(var responseCode: Text; var responseMessage: Text; var payload: Text)
    var
        Vendor: Record Vendor;
        found: Boolean;
        position: Text;
        jsonObj: JsonObject;
        jsonArray: JsonArray;

    begin

        Vendor.Reset();
        Vendor.SetAutoCalcFields(Balance);
        Vendor.SetLoadFields("No.", Name, Balance);
        Vendor.SetRange(Commision, true);
        if Vendor.FindSet() then begiN
            repeat
                Clear(jsonObj);
                jsonObj.Add('accountName', Vendor.Name);
                jsonObj.Add('accountNumber', Vendor."No.");
                jsonObj.Add('accountBalance', Vendor.Balance);
                jsonArray.Add(jsonObj);
            until Vendor.Next() = 0;
            responseCode := '00';
            responseMessage := 'success';
            jsonArray.WriteTo(payload);
            exit;
        end else begin
            responseCode := '01';
            responseMessage := 'Account not found';
            jsonArray.WriteTo(payload);
        end;

    end;

    procedure fetchSettlementAccounts(var entityCode: Text; var accountType: Code[100]; var responseCode: Text; var responseMessage: Text; var payload: Text)
    var
        Vendor: Record Vendor;
        found: Boolean;
        accountTypes: Enum settlementType;
        BankDetails: Record BankDetails;
        Organization: Record Organisation;
        accountName: Code[100];
        accountNumber: Code[100];
        Paybill: Record Paybill;
        PaybillNumber: Code[100];
        JSONObj: JsonObject;
        jsonArray: JsonArray;
        section: Text;
        List: List of [Text];
        i: Integer;
    begin
        List := entityCode.Split(',');
        for i := 1 to List.Count() do begin
            section := List.Get(i);
            if section <> '' then begin
                Organization.Reset();
                Organization.SetLoadFields("No.", "Full Name");
                if Organization.Get(section) then begin
                    found := true;
                    //bank details
                    if accountType in ['0'] then begin
                        BankDetails.Reset();
                        BankDetails.SetLoadFields(AccounNo, paybillNumber);
                        BankDetails.SetRange(ApplicationNo, Organization.applicationNo);
                        if BankDetails.FindSet() then begin
                            repeat
                                accountNumber := BankDetails.AccounNo;
                                accountName := Organization."Full Name" + '- ' + accountNumber + '(' + BankDetails.BankName + ')';
                                PaybillNumber := BankDetails.paybillNumber;
                                Clear(JSONObj);
                                JSONObj.Add('accountName', accountName);
                                JSONObj.Add('accountNumber', accountNumber);
                                JSONObj.Add('entityCode', Organization."No.");
                                JSONObj.Add('paybillNumber', PaybillNumber);
                                jsonArray.Add(JSONObj);
                            until BankDetails.Next() = 0;
                            jsonArray.WriteTo(payload);
                            //   exit;
                        end
                        else begin
                            responseCode := '01';
                            responseMessage := 'Settlement account not found';
                            jsonArray.WriteTo(payload);
                            // exit;
                        end;
                    end;
                    //Phone Number Details
                    if accountType in ['1'] then begin
                        accountNumber := Organization."Phone No.";
                        accountName := Organization."Full Name" + '- ' + accountNumber;
                        if accountNumber = '' then begin
                            responseCode := '01';
                            responseMessage := 'Settlement account not found';
                            jsonArray.WriteTo(payload);
                            exit;
                        end;
                        Clear(JSONObj);
                        JSONObj.Add('accountName', accountName);
                        JSONObj.Add('accountNumber', accountNumber);
                        JSONObj.Add('entityCode', Organization."No.");
                        JSONObj.Add('paybillNumber', PaybillNumber);
                        jsonArray.Add(JSONObj);
                        jsonArray.WriteTo(payload);
                    end;
                    //Paybill Details
                    if accountType in ['2'] then begin
                        Paybill.Reset();
                        Paybill.SetLoadFields(paybillNo);
                        Paybill.SetRange(applNo, Organization.applicationNo);
                        if Paybill.FindSet() then begin
                            repeat
                                accountNumber := Paybill.paybillNo;
                                accountName := Organization."Full Name" + '- ' + accountNumber;
                                Clear(JSONObj);
                                JSONObj.Add('accountName', accountName);
                                JSONObj.Add('accountNumber', PaybillNumber);
                                JSONObj.Add('entityCode', Organization."No.");
                                JSONObj.Add('paybillNumber', accountNumber);
                                jsonArray.Add(JSONObj);
                            until Paybill.Next() = 0;
                            jsonArray.WriteTo(payload);
                        end else begin
                            responseCode := '01';
                            responseMessage := 'Settlement account not found';
                            jsonArray.WriteTo(payload);
                            // exit;
                        end;
                    end;
                    //kanja Float Account
                    if accountType in ['3'] then begin
                        Vendor.Reset();
                        Vendor.SetLoadFields(Name, "No.");
                        Vendor.SetRange(OrgCode, section);
                        Vendor.SetRange(Commision, false);
                        if Vendor.FindSet() then begin
                            repeat

                                accountNumber := Vendor."No.";
                                accountName := Vendor.Name + '- ' + accountNumber;
                                Clear(JSONObj);
                                JSONObj.Add('accountName', accountName);
                                JSONObj.Add('accountNumber', accountNumber);
                                JSONObj.Add('entityCode', Organization."No.");
                                JSONObj.Add('paybillNumber', PaybillNumber);
                                jsonArray.Add(JSONObj);
                            until Vendor.Next() = 0;
                            jsonArray.WriteTo(payload);
                        end else begin
                            responseCode := '01';
                            responseMessage := 'Settlement account not found';
                            jsonArray.WriteTo(payload);
                            // exit;
                        end;
                    end;
                    //SaccoAccountNumber
                    if accountType in ['4'] then begin
                        accountNumber := Organization.SaccoNo;
                        accountName := Organization."Full Name" + '- ' + accountNumber;
                        if accountNumber = '' then begin
                            responseCode := '01';
                            responseMessage := 'Settlement account not found';
                            jsonArray.WriteTo(payload);
                            //  exit;
                        end;
                        Clear(JSONObj);
                        JSONObj.Add('accountName', accountName);
                        JSONObj.Add('accountNumber', accountNumber);
                        JSONObj.Add('entityCode', Organization."No.");
                        JSONObj.Add('paybillNumber', PaybillNumber);
                        jsonArray.Add(JSONObj);
                        jsonArray.WriteTo(payload);
                    end;
                    //KanjaWallet
                    if accountType in ['5'] then begin
                        Vendor.SetLoadFields(Name, "No.");
                        Vendor.SetRange(OrgCode, section);
                        Vendor.SetRange(Commision, false);
                        Vendor.SetRange("Vendor Type", Vendor."Vendor Type"::"Member Account");
                        if Vendor.FindSet() then begin
                            repeat
                                accountNumber := Vendor."No.";
                                accountName := Vendor.Name + '- ' + accountNumber;
                                Clear(JSONObj);
                                JSONObj.Add('accountName', accountName);
                                JSONObj.Add('accountNumber', accountNumber);
                                JSONObj.Add('entityCode', Organization."No.");
                                JSONObj.Add('paybillNumber', PaybillNumber);
                                jsonArray.Add(JSONObj);
                            until Vendor.Next() = 0;
                            jsonArray.WriteTo(payload);
                        end else begin
                            responseCode := '01';
                            responseMessage := 'Settlement account not found';
                            jsonArray.WriteTo(payload);
                            // exit;
                        end;
                    end;
                    responseCode := '00';
                    responseMessage := 'success';
                end else begin
                    responseCode := '01';
                    responseMessage := 'Entity Code not found';
                    jsonArray.WriteTo(payload);
                end;
            END;
        END;
    end;

    procedure stageToOwnSettlement(entityCode: Code[100]; fromAccountNumber: Code[100]; toAccountNumber: Code[100]; payBillNumber: code[100]; accountType: code[100]; transactionAmount: Decimal; description: Code[100]; transactionId: code[100]; var responseCode: Text; var responseMessage: text; var payload: text)
    var
    begin
        KanjaFunctions.stageOwnSettlement(entityCode, fromAccountNumber, toAccountNumber, payBillNumber, accountType, transactionAmount, description, transactionId, responseCode, responseMessage, payload);
    end;

    procedure validateKanjaFinancials(var transactionId: Code[30]; Var referenceid: Code[20]; var responseCode: Text; var responseMessage: text; var payload: Text)
    var
        vendLedg: Record "Vendor Ledger Entry";
        orgaNization: Record Organisation;
        vend: Record Vendor;
        jsonObl: JsonObject;
        detailed: Record "Detailed Vendor Ledg. Entry";
        bankLedg: Record "Bank Account Ledger Entry";
        glEntry: Record "G/L Entry";
    begin
        vendLedg.Reset();
        vendLedg.SetLoadFields("Document No.");
        vendLedg.SetRange("Document No.", transactionId);
        if vendLedg.Findset() then begin
            repeat
                responseCode := '00';
                responseMessage := 'Transaction Validated Successfully';
                jsonObl.Add('referenceid', referenceid);
                jsonObl.Add('transactionId', transactionId);
                jsonObl.WriteTo(payload);
            until vendLedg.Next() = 0;
        end else begin
            responseCode := '01';
            responseMessage := 'Invalid Transaction';
            jsonObl.WriteTo(payload);
        end;

    end;

    procedure stageToOtherSettlement(entityCode: Code[100]; fromAccountNumber: Code[100]; toAccountNumber: Code[100]; payBillNumber: code[100]; accountType: code[100]; transactionAmount: Decimal; description: Code[100]; transactionId: code[100]; var responseCode: Text; var responseMessage: text; var payload: text)
    var
    begin
        KanjaFunctions.stageOtherSettlement(entityCode, fromAccountNumber, toAccountNumber, payBillNumber, accountType, transactionAmount, description, transactionId, responseCode, responseMessage, payload);
    end;

    procedure PostingSettlementTransaction(transactionId: Code[30]; Post: Code[20]; VAR responseCode: Code[20]; VAR responseMessage: Text)
    var
    begin

        KanjaFunctions.PostingSettlementTransaction(transactionId, Post, responseCode, responseMessage);

    end;

    procedure createAgency(var name: text; var entityType: text; var accountNo: Text; var physicalAddress: text; var officialEmail: text; var officialPhone: Text; var kraPin: text; var agencyTarget: Text; var salesAgent: text; var country: text; var region: text; var subRegion: text; var postalAddress: text; var postalCode: text; var longitude: text; var latitude: Text; var gpsLocationName: text; var responseCode: text; var responseMessage: text; var payload: text)
    var
    begin
        KanjaFunctions.creatingAgency(name, entityType, accountNo, physicalAddress, officialEmail, officialPhone, kraPin, agencyTarget, salesAgent, country, region, subRegion, postalAddress, postalCode, longitude, latitude, gpsLocationName, responseCode, responseMessage, payload);

    end;

    procedure fetchAgencyDetails(var agencyCode: Code[100]; VAR responseCode: Code[20]; VAR responseMessage: Text; var payload: Text)
    var
        Organization: Record Organisation;
        found: Boolean;
        Vendor: Record Vendor;
        jsonObj: JsonObject;

    begin
        Vendor.Reset();
        Vendor.SetLoadFields(OrgCode, Status);
        if Vendor.Get(agencyCode) then begin
            Organization.Reset();
            Organization.SetLoadFields("No.", "Full Name", "E-mail", "Physical Address", AgencyTarget);
            if Organization.Get(Vendor.OrgCode) then begin
                Clear(jsonObj);
                jsonObj.Add('agencyCode', Organization."No.");
                jsonObj.Add('agencyName', Organization."Full Name");
                jsonObj.Add('agencyEmail', Organization."E-mail");
                jsonObj.Add('agencyLocation', Organization."Physical Address");
                jsonObj.Add('agencyTarget', Organization.AgencyTarget);
                jsonObj.Add('status', Format(Vendor.Status));
                responseCode := '00';
                responseMessage := 'Validated Successfully';
                jsonObj.WriteTo(payload);
            end;
        end else begin
            responseCode := '01';
            responseMessage := 'Invalid Details';
            jsonObj.WriteTo(payload);
        end;
    end;

    procedure validateKanjaAccount(var accountNo: Code[100]; VAR responseCode: Code[20]; VAR responseMessage: Text; var payload: Text)
    var
        Vendor: Record Vendor;
        found: Boolean;
        jsonObj: JsonObject;
    begin
        Vendor.Reset();
        Vendor.SetLoadFields("No.", Name);
        if Vendor.Get(accountNo) then begin
            Clear(jsonObj);
            jsonObj.Add('accountName', Vendor.Name);
            jsonObj.Add('accountNo', Vendor."No.");
            responseCode := '00';
            responseMessage := 'Validated Successfully';
            jsonObj.WriteTo(payload);
        end else begin
            responseCode := '01';
            responseMessage := 'Invalid Account Details';
            jsonObj.WriteTo(payload);
        end;
    end;

    procedure activateAgency(var agencyCode: Code[100]; VAR responseCode: Code[20]; VAR responseMessage: Text; var payload: Text)
    var
        Organization: Record Organisation;
        found: Boolean;
        Vendor: Record Vendor;
        jsonObj: JsonObject;
    begin
        // Vendor.Reset();
        // Vendor.SetLoadFields(OrgCode, Status);
        // Vendor.SetRange(OrgCode, agencyCode);
        // Vendor.SetRange(Status, Vendor.Status::"Pending Approval");
        // if Vendor.FindFirst() then begin
        //     Vendor.Status := Vendor.Status::Active;
        //     if Vendor.Modify() then begin
        //         responseCode := '00';
        //         responseMessage := 'Activated Successfully';
        //         jsonObj.WriteTo(payload);
        //     end;
        // end else begin
        //     responseCode := '02';
        //     responseMessage := 'Agency already Activated ';
        //     jsonObj.WriteTo(payload);
        // end;
    end;

    procedure fetchAccounts(var entityCode: Text; VAR responseCode: Code[20]; VAR responseMessage: Text; var payload: Text)
    var
        Vendor: Record Vendor;
        Found: Boolean;
        objJson: JsonObject;
        jsonArray: JsonArray;
        i: Integer;
        Entities: Text;
        start: Integer;
        section: Text;
        List: List of [Text];
    begin
        List := entityCode.Split(',');
        for i := 1 to List.Count() do begin
            section := List.Get(i);
            if section <> '' then begin
                Vendor.Reset();
                Vendor.SetAutoCalcFields(Balance);
                Vendor.SetLoadFields(Name, "No.", Commision, Balance);
                Vendor.SetRange(OrgCode, section);
                if Vendor.FindSet() then begin
                    repeat
                        Clear(objJson);
                        objJson.Add('accountName', Vendor.Name);
                        objJson.Add('accountNo', Vendor."No.");
                        objJson.Add('isCommission', Vendor.Commision);
                        objJson.Add('accountBalance', Vendor.Balance);
                        jsonArray.Add(objJson);
                    until Vendor.Next() = 0;
                    responseCode := '00';
                    responseMessage := '  Success';
                    jsonArray.WriteTo(payload);
                end else begin
                    responseCode := '01';
                    responseMessage := 'invalid account';
                    jsonArray.WriteTo(payload)
                end;

            end;
        end;
    end;

    procedure fetchStatement(var floatAccountNo: Code[100]; var startDate: Date; var endDate: Date; VAR responseCode: Code[20]; VAR responseMessage: Text; var payload: Text)
    var
        OpeningBalance: Decimal;
        VenObj: JsonObject;
        Entries: Record "Vendor Ledger Entry";
        creditAmount: Decimal;
        debitAmount: Decimal;
    begin
        Entries.Reset();
        Entries.SetCurrentKey("Posting Date");
        Entries.SetAutoCalcFields(Amount, "Credit Amount", "Debit Amount");
        Entries.SetLoadFields("Vendor No.", "Posting Date", "Document No.", Description, "Credit Amount", "Debit Amount", Amount);
        Entries.SetRange("Vendor No.", floatAccountNo);
        Entries.SetRange("Posting Date", startDate, endDate);
        if Entries.FindSet() then begin
            repeat
                creditAmount += Entries."Credit Amount";
                debitAmount += Entries."Debit Amount";
                if (creditAmount = 0) and (debitAmount = 0) then begin
                    if Entries.Amount <= 0 then begin
                        creditAmount += Abs(Entries.Amount);
                    end;
                    if Entries.Amount > 0 then begin
                        debitAmount += Abs(Entries.Amount);

                    end;
                end;
            until Entries.Next() = 0;
        end;
        if GetAccountDetails(floatAccountNo, OpeningBalance, startDate, endDate, creditAmount, debitAmount, VenObj) then begin
            VenObj.Add('statementTransactions', GetAccountEntries(floatAccountNo, OpeningBalance, startDate, endDate));
            responseCode := '00';
            responseMessage := '  Success';
            VenObj.WriteTo(payload);
            exit;
        end
        else begin
            Clear(VenObj);
            responseCode := '01';
            responseMessage := 'Account No not found';
            VenObj.WriteTo(payload);
            exit;
        end;

    end;

    local procedure GetAccountDetails(floatAccountNo: Code[100]; var OpeningBalalce: Decimal; Start_Date: Date; End_Date: Date; var creditAmount: Decimal; var debitAmount: Decimal; var VenOnj: JsonObject): Boolean
    var
        Ven: Record Vendor;
        PrevDate: Date;
        accountsName: Text;
        Entries: Record "Vendor Ledger Entry";

        orgnization: Record Organisation;
        EntityName: Code[100];
    begin
        Clear(VenOnj);
        Clear(OpeningBalalce);
        PrevDate := CalcDate('-1D', Start_Date);

        Ven.Reset();
        Ven.SetLoadFields("No.", Name, "Net Change", "Date Filter", Comment);
        if Ven.Get(floatAccountNo) then begin
            orgnization.Reset();
            orgnization.SetLoadFields("Full Name");
            if orgnization.Get(Ven.OrgCode) then begin
                EntityName := orgnization."Full Name";
            end;
            VenOnj.Add('entityName', EntityName);
            VenOnj.Add('accountNo', Ven."No.");
            VenOnj.Add('accountName', Ven.Name);
            Ven.SetRange("Date Filter", 0D, End_Date);
            Ven.CalcFields("Net Change");
            VenOnj.Add('accountBalance', Ven."Net Change");
            Ven.SetRange("Date Filter", 0D, PrevDate);
            Ven.CalcFields("Net Change");
            OpeningBalalce := Ven."Net Change";
            VenOnj.Add('startingBalance', OpeningBalalce);
            VenOnj.Add('totalDeposited', creditAmount);
            VenOnj.Add('totalWithdrawn', debitAmount);
            VenOnj.Add('startDate', Start_Date);
            VenOnj.Add('endDate', End_Date);
            exit(true);
        end;
    end;

    local procedure GetAccountEntries(AccountNo: Code[20]; OpeningBalance: Decimal; Start_Date: Date; End_Date: Date): JsonArray
    var
        Entries: Record "Vendor Ledger Entry";
        Entriesobj: JsonObject;
        EntriesArr: JsonArray;
        creditAmount: Decimal;
        debitAmount: Decimal;
        runningBal: Decimal;
    begin
        runningBal := OpeningBalance;
        Clear(EntriesArr);
        Entries.Reset();
        Entries.SetCurrentKey("Posting Date");
        Entries.SetAutoCalcFields(Amount, "Credit Amount", "Debit Amount");
        Entries.SetLoadFields("Vendor No.", "Posting Date", "Document No.", Description, "Credit Amount", "Debit Amount", Amount);
        Entries.SetRange("Vendor No.", AccountNo);
        Entries.SetRange("Posting Date", Start_Date, End_Date);
        if Entries.FindSet() then begin
            repeat
                Clear(Entriesobj);
                creditAmount := Entries."Credit Amount";
                debitAmount := Entries."Debit Amount";
                if (creditAmount = 0) and (debitAmount = 0) then begin
                    if Entries.Amount <= 0 then creditAmount := Abs(Entries.Amount);
                    if Entries.Amount > 0 then debitAmount := Abs(Entries.Amount);
                end;
                if creditAmount > 0 then begin
                    runningBal += creditAmount;
                    debitAmount := 0;
                end;
                if debitAmount > 0 then begin
                    runningBal -= debitAmount;
                    creditAmount := 0;
                end;
                Entriesobj.Add('documentNo', Entries."Document No.");
                Entriesobj.Add('creditAmount', creditAmount);
                Entriesobj.Add('debitAmount', debitAmount);
                Entriesobj.Add('runningBal', runningBal);
                Entriesobj.Add('postingDate', Entries."Posting Date");
                Entriesobj.Add('transactionDescription', Entries.Description);
                EntriesArr.Add(Entriesobj);
            until Entries.Next() = 0;
        end;
        exit(EntriesArr);
    end;

    procedure PostingSaccoTransaction(transactionId: Code[20]; Post: Code[20]; VAR responseCode: Code[20]; VAR responseMessage: Text)
    begin
        KanjaFunctions.postSaccoTransaction(transactionId, Post, responseCode, responseMessage);
    end;

    procedure fetchKyc(entityType: Text[10]; code: Code[100]; VAR responseCode: Code[20]; VAR responseMessage: Text; var payload: Text)

    var
        EntityTypes: Enum EntityType;
        Organization: Record Organisation;
        JsonObj: JsonObject;
    begin
        if entityType in ['0'] then begin
            EntityTypes := EntityTypes::Fintech;
        end;
        if entityType in ['1'] then begin
            EntityTypes := EntityTypes::Sacco;
        end;
        if entityType in ['2'] then begin
            EntityTypes := EntityTypes::Merchant;
        end;
        if entityType in ['3'] then begin
            EntityTypes := EntityTypes::Acquirer;
        end;
        Organization.Reset();
        Organization.SetLoadFields("Full Name", "Phone No.", Website, "Postal Address", Mission, "PIN No.", Type, "Physical Address", "E-mail");
        Organization.SetRange(Type, EntityTypes);
        Organization.SetRange("No.", code);
        if Organization.FindFirst() then begin
            JsonObj.Add('name', Organization."Full Name");
            JsonObj.Add('phoneNumber', Organization."Phone No.");
            JsonObj.Add('website', Organization.Website);
            JsonObj.Add('address', Organization."Postal Address");
            JsonObj.Add('mission', Organization.Mission);
            JsonObj.Add('kraPin', Organization."PIN No.");
            JsonObj.Add('category', Format(Organization.Type));
            JsonObj.Add('location', Organization."Physical Address");
            JsonObj.Add('email', Organization."E-mail");
            JsonObj.WriteTo(payload);
            responseCode := '00';
            responseMessage := 'Fetched Successfully';
        end ELSE begin
            responseCode := '01';
            responseMessage := 'Invalid Details';
            JsonObj.WriteTo(payload);
        end;
    end;

    procedure registerMembers(idNo: Text[20]; firstName: Text[30]; middleName: Text[30]; surnameName: Text[30]; email: code[80]; phoneNo: code[20]; entityCode: Code[20]; gender: Text[100]; dob: Text[30]; kraPin: Code[20]; var memberNumber: Code[20]; var accountNumber: Code[20]; var county: Code[30]; var nationality: Code[20]; var responseCode: Text; var responseMessage: Text; var payload: Text)
    var
    begin
        KanjaFunctions.registerMember(idNo, firstName, middleName, surnameName, email, phoneNo, entityCode, gender, dob, kraPin, memberNumber, accountNumber, county, nationality, responseCode, responseMessage, payload);
    end;

    procedure validateMemberDetails(phoneNo: Code[20]; entityCode: Code[20]; var responseMessage: Text; var responseCode: Text; var payload: text)
    begin
        KanjaFunctions.validateMemberDetail(phoneNo, entityCode, responseMessage, responseCode, payload);
    end;

    procedure validateKanjaId(kanjaId: Code[100]; entityCode: Code[100]; var responseCode: Text; var responseMessage: text; var payload: text)

    begin
        KanjaFunctions.validateKanjaDetails(kanjaId, entityCode, responseCode, responseMessage, payload);
    end;

    procedure validateMember(var msisdn: Code[20]; entityCode: Code[20]; var responseCode: Text; var responseMessage: text; var payload: text)
    var
        KanjaFunc: Codeunit kanjaFunctions;
    begin
        KanjaFunc.ValidateKanjaMember(msisdn, entityCode, responseCode, responseMessage, payload);
    end;

    procedure fetchServiceLimits(var serviceCode: Code[20]; entityCode: Code[20]; var responseCode: Text; var responseMessage: text; var payload: text)
    var
        KanjaFunc: Codeunit kanjaFunctions;
    begin
        KanjaFunc.fetchService(serviceCode, entityCode, responseCode, responseMessage, payload);

    end;

    procedure processReversal(var kanjaID: Code[20]; var responseCode: Code[20]; var responseMessage: Text; var payload: Text);
    var
        KanjaFunc: Codeunit kanjaFunctions;
    begin
        KanjaFunc.ProcessReversal(kanjaID, ResponseCode, ResponseMessage, payload);
        exit;
    end;

    procedure confirmTerms(var PhoneNumber: Code[50]; var saccoCode: Code[50]; var responseCode: Code[20]; var responseMessage: Text; var payload: Text)
    var
        Member: Record Members;
    begin
        Member.Reset();
        Member.SetRange("Mobile Phone No", PhoneNumber);
        Member.SetRange(EntityCode, saccoCode);
        if Member.FindFirst() then begin
            Member."Confirmed Terms" := true;
            Member.Modify();
            responseCode := '00';
            responseMessage := 'Validated Successfully';
            payload := '{}';
            exit;
        end else begin
            responseCode := '01';
            responseMessage := 'Member Not Found';
            exit;
        end;

    end;

}