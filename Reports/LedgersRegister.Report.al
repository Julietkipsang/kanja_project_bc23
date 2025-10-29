report 50244 "Ledgers Registers Report"
{
    Caption = 'Ledgers Register Analysis';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\LedgersRegister.rdl';
    dataset
    {
        dataitem(Integer; Integer)
        {
            column(CompInfo_Name; CompInfo.Name)
            {

            }
            column(CompInfo_Picture; CompInfo.Picture)
            {

            }
            column(TitleLbl; TitleLbl)
            {

            }
            column(RegisterNo; RegisterNo)
            {

            }
            column(PostedBy; PostedBy)
            {

            }
            column(CreationDate; CreationDate)
            {

            }
            column(CreationTime; CreationTime)
            {

            }
            column(PositngDate; PositngDate)
            {

            }
            column(Categories; Categories)
            {

            }
            column(DocumentNo; DocumentNo)
            {

            }
            column(AccountNo; AccountNo)
            {

            }
            column(AccountName; AccountName)
            {

            }
            column(Desciption; Desciption)
            {

            }
            column(Amount; Amount)
            {

            }
            column(CreditAmount; CreditAmount)
            {

            }
            column(DebitAmount; DebitAmount)
            {

            }
            column(TransactionType; TransactionType)
            {

            }
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, Rows);
                i := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(CreditAmount);
                Clear(DebitAmount);
                J_Array.Get(i, Token);
                JObject := Token.AsObject();
                Categories := GetJsonToken(JObject, 'Categories').AsValue().AsText();
                DocumentNo := GetJsonToken(JObject, 'DocumentNo').AsValue().AsCode();
                AccountNo := GetJsonToken(JObject, 'AccountNo').AsValue().AsCode();
                AccountName := GetJsonToken(JObject, 'AccountName').AsValue().AsText();
                Desciption := GetJsonToken(JObject, 'Desciption').AsValue().AsText();
                TransactionType := GetJsonToken(JObject, 'TransactionType').AsValue().AsText();
                Amount := GetJsonToken(JObject, 'Amount').AsValue().AsDecimal();
                if Amount < 0 then CreditAmount := Abs(Amount);
                if Amount > 0 then DebitAmount := Abs(Amount);
                i += 1;
            end;
        }
    }
    trigger OnPreReport()
    begin
        if not Allowed then Error('There is not data to generate!');
        if Rows <= 0 then Error('There is not data to generate!');
        CompInfo.Reset();
        CompInfo.Get();
        CompInfo.CalcFields(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        TitleLbl: Label 'Posting Breakdown Per Individual Ledgers';
        CreationDate: Date;
        CreationTime: Time;
        PositngDate: Date;
        PostedBy: Code[120];
        RegisterNo: Integer;
        Categories: Text[50];
        DocumentNo: Code[20];
        AccountNo: Code[20];
        AccountName: Text[100];
        Desciption: Text[100];
        Amount: Decimal;
        CreditAmount: Decimal;
        DebitAmount: Decimal;
        TransactionType: Text[50];
        Rows: Integer;
        J_Array: JsonArray;
        Token: JsonToken;
        i: Integer;
        JObject: JsonObject;
        Allowed: Boolean;


    procedure GetLedgerEntries(IsRange: Boolean; EntryNo: Integer)
    var
        Register: Record "G/L Register";
        FromEntryNo: Integer;
        ToEntryNo: Integer;
    begin
        if EntryNo <= 0 then Error('No Record to analyze!');
        Clear(FromEntryNo);
        Clear(ToEntryNo);
        case IsRange of
            true:
                begin
                    Register.Reset();
                    Register.Get(EntryNo);
                end;
            false:
                begin
                    Register := GetRange(EntryNo);
                    if Register."No." <= 0 then Error('No Data Found!');
                end;
        end;
        RegisterNo := Register."No.";
        FromEntryNo := Register."From Entry No.";
        ToEntryNo := Register."To Entry No.";
        PostedBy := Register."User ID";
        CreationDate := Register."Posting Date";
        CreationTime := Register."Posting Time";
        Clear(J_Array);
        Rows := 0;
        J_Array := GetGLEntries(J_Array, FromEntryNo, ToEntryNo);
        J_Array := GetPayableEntries(J_Array, FromEntryNo, ToEntryNo);
        J_Array := GetReceivableEntries(J_Array, FromEntryNo, ToEntryNo);
        J_Array := GetBankEntries(J_Array, FromEntryNo, ToEntryNo);
        Allowed := true;
    end;

    local procedure GetRange(EntryNo: Integer) Register: Record "G/L Register";
    begin
        Register.Reset();
        Register.SetFilter("From Entry No.", '<=%1', EntryNo);
        Register.SetFilter("To Entry No.", '>=%1', EntryNo);
        if Register.FindFirst() then exit(Register);
    end;

    local procedure GetGLEntries(J_Array: JsonArray; FromEntryNo: Integer; ToEntryNo: Integer): JsonArray
    var
        Categories_: Text[50];
        Entries: Record "G/L Entry";
        Json: JsonObject;
        Account: Record "G/L Account";
    begin
        Categories_ := 'General Ledger Entries';
        Entries.Reset();
        Entries.SetLoadFields("Document No.", "G/L Account No.", "Posting Date", Description, Amount);
        Entries.SetRange("Entry No.", FromEntryNo, ToEntryNo);
        if Entries.FindSet() then begin
            repeat
                if PositngDate = 0D then PositngDate := Entries."Posting Date";
                Account.Reset();
                Account.Get(Entries."G/L Account No.");
                Json := CreateJson(Categories_, Entries."Document No.", Entries."G/L Account No.", Account.Name, Entries.Description, Entries.Amount, StrSubstNo('%1', Enum::"Posting Line Type"::Normal));
                J_Array.Add(Json);
                Rows += 1;
            until Entries.Next() = 0;
        end;
        exit(J_Array);
    end;

    local procedure GetPayableEntries(J_Array: JsonArray; FromEntryNo: Integer; ToEntryNo: Integer): JsonArray
    var
        Categories_: Text[50];
        Entries: Record "Vendor Ledger Entry";
        Ven: Record Vendor;
        Json: JsonObject;
    begin
        Categories_ := 'Payable Entries';
        Entries.Reset();
        Entries.SetCurrentKey("Vendor No.");
        Entries.SetAutoCalcFields(Amount);
        Entries.SetLoadFields("Document No.", "Vendor No.", "Vendor Name", Description, Amount);
        Entries.SetRange("Entry No.", FromEntryNo, ToEntryNo);
        if Entries.FindSet() then begin
            repeat
                Ven.Reset();
                Ven.Get(Entries."Vendor No.");
                Json := CreateJson(Categories_, Entries."Document No.", Entries."Vendor No.", Ven.Name, Entries.Description, Entries.Amount, StrSubstNo('%1', Entries."Posting Line Type"));
                J_Array.Add(Json);
                Rows += 1;
            until Entries.Next() = 0;
        end;
        exit(J_Array);
    end;

    local procedure GetReceivableEntries(J_Array: JsonArray; FromEntryNo: Integer; ToEntryNo: Integer): JsonArray
    var
        Categories_: Text[50];
        Entries: Record "Cust. Ledger Entry";
        Json: JsonObject;
        Cust: Record Customer;
    begin
        Categories_ := 'Receivable Entries';
        Entries.Reset();
        Entries.SetCurrentKey("Customer No.");
        Entries.SetAutoCalcFields(Amount);
        Entries.SetLoadFields("Document No.", "Customer No.", "Customer Name", Description, Amount);
        Entries.SetRange("Entry No.", FromEntryNo, ToEntryNo);
        if Entries.FindSet() then begin
            repeat
                Cust.Reset();
                Cust.Get(Entries."Customer No.");
                Json := CreateJson(Categories_, Entries."Document No.", Entries."Customer No.", Cust.Name, Entries.Description, Entries.Amount, StrSubstNo('%1', Entries."Posting Line Type"));
                J_Array.Add(Json);
                Rows += 1;
            until Entries.Next() = 0;
        end;
        exit(J_Array);
    end;

    local procedure GetBankEntries(J_Array: JsonArray; FromEntryNo: Integer; ToEntryNo: Integer): JsonArray
    var
        Categories_: Text[50];
        Entries: Record "Bank Account Ledger Entry";
        Json: JsonObject;
        Bank: Record "Bank Account";
    begin
        Categories_ := 'Bank Ledger Entries';
        Entries.Reset();
        Entries.SetCurrentKey("Bank Account No.");
        Entries.SetLoadFields("Document No.", "Bank Account No.", Description, Amount);
        Entries.SetRange("Entry No.", FromEntryNo, ToEntryNo);
        if Entries.FindSet() then begin
            repeat
                Bank.Reset();
                Bank.Get(Entries."Bank Account No.");
                Json := CreateJson(Categories_, Entries."Document No.", Entries."Bank Account No.", Bank.Name, Entries.Description, Entries.Amount, StrSubstNo('%1', Enum::"Posting Line Type"::Normal));
                J_Array.Add(Json);
                Rows += 1;
            until Entries.Next() = 0;
        end;
        exit(J_Array);
    end;

    local procedure CreateJson(Categories_: Text[50]; DocumentNo_: Code[20]; AccountNo_: Code[20]; AccountName_: Text[100]; Desciption_: Text[100]; Amount_: Decimal; TransactionType_: Text[50]) Json: JsonObject
    begin
        Clear(Json);
        Json.Add('Categories', Categories_);
        Json.Add('DocumentNo', DocumentNo_);
        Json.Add('AccountNo', AccountNo_);
        Json.Add('AccountName', AccountName_);
        Json.Add('Desciption', Desciption_);
        Json.Add('Amount', Amount_);
        Json.Add('TransactionType', TransactionType_);
        exit(Json);
    end;

    local procedure GetJsonToken(MemObject: JsonObject; TokenKey: Text) Json_Token: JsonToken
    var
    begin
        if not MemObject.Get(TokenKey, Json_Token) then
            Error('could not find a token with Key %1', TokenKey);
    end;
}