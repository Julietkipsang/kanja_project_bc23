codeunit 50102 "Optimized Gen. Jnl.-Post Line"
{
    Permissions = TableData "G/L Account" = r,
                  TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = imd,
                  TableData "Vendor Ledger Entry" = imd,
                  TableData "G/L Register" = imd,
                  TableData "G/L Entry - VAT Entry Link" = rimd,
                  TableData "VAT Entry" = imd,
                  TableData "Bank Account Ledger Entry" = imd,
                  TableData "Check Ledger Entry" = imd,
                  TableData "Detailed Cust. Ledg. Entry" = imd,
                  TableData "Detailed Vendor Ledg. Entry" = imd,
                  TableData "Line Fee Note on Report Hist." = rim,
                  TableData "Employee Ledger Entry" = imd,
                  TableData "Detailed Employee Ledger Entry" = imd,
                  TableData "FA Ledger Entry" = rimd,
                  TableData "FA Register" = imd,
                  TableData "Maintenance Ledger Entry" = rimd;
    TableNo = "Gen. Journal Line";
    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        GLEntryNo: Integer;
        NextEntryNo: Integer;
        FirstTransactionNo: Integer;
        NextTransactionNo: Integer;
        GLReg: Record "G/L Register";
        IsGLRegInserted: Boolean;
        NextVATEntryNo: Integer;
        // GetUser: Codeunit "Get User";
        Text0001: Label 'Posting Journal Batch: #1###\ Posting @2@@@@ \Posting Journal Line #3###\ Current Line: #4######';//Journal Batch Name    #1##########\\Posting @2@@@@@@@@@@@@@\#3#############
        Text0002: Label 'Journal Batch Successfully Posted!';
        Text0003: Label 'The Journal is out of Balance by %1';
        Text0004: Label '%1 or %2 must be a G/L Account or Bank Account.';
        Window: Dialog;
        AllRecords: Integer;
        Current: Integer;
        FGLRegNo: Integer;


    local procedure RunWithCheck(var GenJnlLine2: Record "Gen. Journal Line" temporary): Integer

    begin
        RunWithCheckBalance(GenJnlLine2);
        Code(GenJnlLine2, true);
        exit(GLEntryNo);
    end;

    procedure RunWithMobileBanking(var GenJnlLine2: Record "Gen. Journal Line" temporary): Integer
    begin
        RunWithCheck(GenJnlLine2);
        exit(FGLRegNo);
    end;

    local procedure StartPosting(GenJnlLine: Record "Gen. Journal Line" temporary)
    var
        GLRegNo: Integer;
    begin
        InitNextEntryNo();
        FirstTransactionNo := NextTransactionNo;
        GLReg.LockTable();
        if GLReg.FindLast then
            GLRegNo := GLReg."No." + 1
        else
            GLRegNo := 1;
        GLReg.Init();
        GLReg."No." := GLRegNo;
        GLReg."From Entry No." := NextEntryNo;
        GLReg."From VAT Entry No." := NextVATEntryNo;
        GLReg."Posting Date":= Today;
        GLReg."Posting Time" := Time;
        GLReg."Source Code" := 'GENJNL';
        GLReg."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        GLReg."User ID" := UserId;
        IsGLRegInserted := false;
        FGLRegNo := GLReg."No.";
    end;

    local procedure FinishPosting(GenJnlLine: Record "Gen. Journal Line" temporary) IsTransactionConsistent: Boolean
    begin
        IsTransactionConsistent := true;
        GLReg."To VAT Entry No." := NextVATEntryNo - 1;
        GLReg."To Entry No." := GLEntryNo;
        UpdateGLReg(IsTransactionConsistent);
    end;

    local procedure UpdateGLReg(IsTransactionConsistent: Boolean)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if IsTransactionConsistent then
            if IsGLRegInserted then begin
                GLReg.Modify();
            end else begin
                GLReg.Insert();
                IsGLRegInserted := true;
            end;
    end;

    local procedure InitNextEntryNo()
    var
        GLEntry: Record "G/L Entry";
        LastEntryNo: Integer;
        LastTransactionNo: Integer;
    begin
        GLEntry.LockTable();
        GLEntry.GetLastEntry(LastEntryNo, LastTransactionNo);
        NextEntryNo := LastEntryNo + 1;
        NextTransactionNo := LastTransactionNo + 1;
    end;

    local procedure IncrNextEntryNo()
    begin
        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure "Code"(var GenJnlLine: Record "Gen. Journal Line" temporary; CheckLine: Boolean)
    var
        Balancing: Boolean;
        GenJnlLine2: Record "Gen. Journal Line" temporary;
    begin
        Window.Open(Text0001);
        if NextEntryNo = 0 then begin
            StartPosting(GenJnlLine)
        end;
        AllRecords := GenJnlLine.Count;
        Current := 0;
        if GenJnlLine.FindSet() then begin
            repeat
                Current += 1;
                Window.Update(1, GenJnlLine."Journal Batch Name");
                ValidateAccountType(GenJnlLine);
                GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                if GenJnlLine.Amount < 0 then begin
                    GenJnlLine."Credit Amount" := Abs(GenJnlLine.Amount);
                end else begin
                    GenJnlLine."Debit Amount" := Abs(GenJnlLine.Amount);
                end;
                Balancing := false;
                if GenJnlLine."Account No." <> '' then begin
                    if (GenJnlLine."Bal. Account No." <> '') then begin
                        Balancing := true;
                        GenJnlLine2.Copy(GenJnlLine);
                        Codeunit.Run(Codeunit::"Exchange Acc. G/L Journal Line", GenJnlLine2);
                    end;
                end;
                Window.Update(2, ((Current / AllRecords) * 10000) div 1);
                Window.Update(3, GenJnlLine."Line No.");
                Window.Update(4, Format(Current) + ' out of ' + Format(AllRecords));
                PostGenJnlLine(GenJnlLine, Balancing);
                if Balancing then begin
                    PostGenJnlLine(GenJnlLine2, Balancing);
                end;
            until GenJnlLine.Next() = 0;
        end;
        FinishPosting(GenJnlLine);
        Window.Close();
        Message(Text0002);
    end;

    local procedure ValidateAccountType(GenJnlLine: Record "Gen. Journal Line" temporary)
    begin
        if (GenJnlLine."Account Type" in [GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::Vendor, GenJnlLine."Account Type"::"Fixed Asset",
                                        GenJnlLine."Account Type"::"IC Partner", GenJnlLine."Account Type"::Employee]) and
                    (GenJnlLine."Bal. Account Type" in [GenJnlLine."Bal. Account Type"::Customer, GenJnlLine."Bal. Account Type"::Vendor, GenJnlLine."Bal. Account Type"::"Fixed Asset",
                                             GenJnlLine."Bal. Account Type"::"IC Partner", GenJnlLine."Bal. Account Type"::Employee])
                 then
            Error(Text0004, GenJnlLine.FieldCaption("Account Type"), GenJnlLine.FieldCaption("Bal. Account Type"));
    end;

    local procedure PostGenJnlLine(var GenJnlLine: Record "Gen. Journal Line" temporary; Balancing: Boolean)
    begin
        case GenJnlLine."Account Type" of
            GenJnlLine."Account Type"::"G/L Account":
                PostGLAcc(GenJnlLine, Balancing);
            GenJnlLine."Account Type"::Customer:
                PostCust(GenJnlLine, Balancing);
            GenJnlLine."Account Type"::Vendor:
                PostVend(GenJnlLine, Balancing);
            GenJnlLine."Account Type"::"Bank Account":
                PostBankAcc(GenJnlLine, Balancing);
        end;

    end;

    local procedure PostGLAcc(GenJnlLine: Record "Gen. Journal Line" temporary; Balancing: Boolean)
    var
        GLAcc: Record "G/L Account";
        GLEntry: Record "G/L Entry";
    begin
        GLAcc.Reset();
        GLAcc.Get(GenJnlLine."Account No.");
        InitGLEntry(GenJnlLine, GLEntry,
             GenJnlLine."Account No.", GenJnlLine."Amount (LCY)",
             GenJnlLine."Source Currency Amount", true, GenJnlLine."System-Created Entry");
        GLEntry."Gen. Posting Type" := GenJnlLine."Gen. Posting Type";
        GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
        GLEntry."No. Series" := GenJnlLine."Posting No. Series";
        if GenJnlLine."Additional-Currency Posting" =
           GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only"
        then begin
            GLEntry."Additional-Currency Amount" := GenJnlLine.Amount;
            GLEntry.Amount := 0;
        end;
        if GLEntry.Amount > 0 then begin
            GLEntry."Debit Amount" := Abs(GLEntry.Amount);
        end else begin
            GLEntry."Credit Amount" := Abs(GLEntry.Amount);
        end;
        //GLEntry."Transaction Time" := Time;
        GLEntry.Insert();
        IncrNextEntryNo();
    end;

    local procedure InitGLEntry(GenJnlLine: Record "Gen. Journal Line" temporary; var GLEntry: Record "G/L Entry"; GLAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean; SystemCreatedEntry: Boolean)
    var
        GLAcc: Record "G/L Account";
    begin
        GLAcc.Reset();
        GLAcc.Get(GLAccNo);
        GLAcc.TestField(Blocked, false);
        GLAcc.TestField("Account Type", GLAcc."Account Type"::Posting);
        GLEntry.Init();
        GLEntry.CopyFromGenJnlLine(GenJnlLine);
        GLEntry."Entry No." := NextEntryNo;
        GLEntry."User ID" := UserId;
        GLEntry."Transaction No." := NextTransactionNo;
        GLEntry."G/L Account No." := GLAccNo;
        GLEntry."System-Created Entry" := SystemCreatedEntry;
        GLEntry.Amount := Amount;
        // Store Entry No. to global variable for return:
        GLEntryNo := GLEntry."Entry No.";
    end;

    local procedure PostCust(GenJnlLine: Record "Gen. Journal Line" temporary; Balancing: Boolean)
    var
        Cust: Record Customer;
        CustPostingGr: Record "Customer Posting Group";
        CustLedgEntry: Record "Cust. Ledger Entry";
        CVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        SalesSetup: Record "Sales & Receivables Setup";
        ReceivablesAccount: Code[20];
        DtldCustLedgEntryNoOffset: Integer;
    begin
        SalesSetup.Get();
        Cust.Get(GenJnlLine."Account No.");
        Cust.CheckBlockedCustOnJnls(Cust, GenJnlLine."Document Type", true);

        if GenJnlLine."Posting Group" = '' then begin
            Cust.TestField("Customer Posting Group");
            GenJnlLine."Posting Group" := Cust."Customer Posting Group";
        end;
        CustPostingGr.Get(GenJnlLine."Posting Group");
        ReceivablesAccount := CustPostingGr.GetReceivablesAccount();
        DtldCustLedgEntry.LockTable();
        CustLedgEntry.LockTable();
        InitCustLedgEntry(GenJnlLine, CustLedgEntry);
        TempDtldCVLedgEntryBuf.DeleteAll();
        TempDtldCVLedgEntryBuf.Init();
        TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
        TempDtldCVLedgEntryBuf."CV Ledger Entry No." := CustLedgEntry."Entry No.";
        CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
        TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf, CVLedgEntryBuf, true);
        CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
        CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

        // Post customer entry
        CustLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        CustLedgEntry."Amount to Apply" := 0;
        CustLedgEntry."Applies-to Doc. No." := '';
        CustLedgEntry."Applies-to ID" := '';
        // CustLedgEntry."Transaction Time" := Time;
        if SalesSetup."Copy Customer Name to Entries" then
            CustLedgEntry."Customer Name" := Cust.Name;
        CustLedgEntry.Insert(true);
        if DtldCustLedgEntry.FindLast then
            DtldCustLedgEntryNoOffset := DtldCustLedgEntry."Entry No."
        else
            DtldCustLedgEntryNoOffset := 0;
        InsertDtldCustLedgEntry(GenJnlLine, TempDtldCVLedgEntryBuf, DtldCustLedgEntry, DtldCustLedgEntryNoOffset, CustLedgEntry."Entry No.");
        CreateGLEntry(GenJnlLine, ReceivablesAccount, GenJnlLine."Amount (LCY)", GenJnlLine."Source Currency Amount", true, GenJnlLine."System-Created Entry");
    end;

    local procedure InitCustLedgEntry(GenJnlLine: Record "Gen. Journal Line"; var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry.Init();
        CustLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        CustLedgEntry."User ID" := UserId;
        CustLedgEntry."Entry No." := NextEntryNo;
        CustLedgEntry."Transaction No." := NextTransactionNo;
    end;

    local procedure InsertDtldCustLedgEntry(GenJnlLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; Offset: Integer; CustLedgerEntryNo: Integer)

    begin
        DtldCustLedgEntry.Init;
        DtldCustLedgEntry.TransferFields(DtldCVLedgEntryBuf);
        DtldCustLedgEntry."Cust. Ledger Entry No." := CustLedgerEntryNo;
        DtldCustLedgEntry."Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
        DtldCustLedgEntry."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        DtldCustLedgEntry."Reason Code" := GenJnlLine."Reason Code";
        DtldCustLedgEntry."Source Code" := GenJnlLine."Source Code";
        DtldCustLedgEntry."Transaction No." := NextTransactionNo;
        DtldCustLedgEntry."User ID" := UserId;
        DtldCustLedgEntry."Initial Entry Due Date" := Today;
        DtldCustLedgEntry."Amount (LCY)" := DtldCustLedgEntry.Amount;
        if DtldCustLedgEntry.Amount > 0 then begin
            DtldCustLedgEntry."Debit Amount" := Abs(DtldCustLedgEntry.Amount);
            DtldCustLedgEntry."Debit Amount (LCY)" := Abs(DtldCustLedgEntry.Amount);
        end else begin
            DtldCustLedgEntry."Credit Amount" := Abs(DtldCustLedgEntry.Amount);
            DtldCustLedgEntry."Credit Amount (LCY)" := Abs(DtldCustLedgEntry.Amount);
        end;
        DtldCustLedgEntry.Insert(true);
    end;

    local procedure PostVend(GenJnlLine: Record "Gen. Journal Line" temporary; Balancing: Boolean)
    var
        Vend: Record Vendor;
        VendPostingGr: Record "Vendor Posting Group";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        CVLedgEntryBuf: Record "CV Ledger Entry Buffer" temporary;
        PayablesAccount: Code[20];
        PurchSetup: Record "Purchases & Payables Setup";
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        DtldVendLedgEntryNoOffset: Integer;
    begin
        PurchSetup.Get();
        Vend.Get(GenJnlLine."Account No.");
        Vend.CheckBlockedVendOnJnls(Vend, GenJnlLine."Document Type", true);
        if GenJnlLine."Posting Group" = '' then begin
            Vend.TestField("Vendor Posting Group");
            GenJnlLine."Posting Group" := Vend."Vendor Posting Group";
        end;
        DtldVendLedgEntry.LockTable();
        VendLedgEntry.LockTable();
        InitVendLedgEntry(GenJnlLine, VendLedgEntry);
        TempDtldCVLedgEntryBuf.DELETEALL;
        TempDtldCVLedgEntryBuf.INIT;
        TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
        TempDtldCVLedgEntryBuf."CV Ledger Entry No." := VendLedgEntry."Entry No.";

        CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
        TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf, CVLedgEntryBuf, true);
        CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
        CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;
        // Post vendor entry
        VendLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        VendLedgEntry."Amount to Apply" := 0;
        VendLedgEntry."Applies-to Doc. No." := '';
        VendLedgEntry."Applies-to ID" := '';
        // VendLedgEntry."Transaction Time" := Time;
        if PurchSetup."Copy Vendor Name to Entries" then
            VendLedgEntry."Vendor Name" := Vend.Name;
        VendLedgEntry.Insert(true);
        GetVendorPostingGroup(GenJnlLine, VendPostingGr);
        PayablesAccount := VendPostingGr.GetPayablesAccount();
        DtldVendLedgEntry.LockTable();
        VendLedgEntry.LockTable();
        TempDtldCVLedgEntryBuf.DeleteAll();
        TempDtldCVLedgEntryBuf.Init();
        TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
        if DtldVendLedgEntry.FindLast then
            DtldVendLedgEntryNoOffset := DtldVendLedgEntry."Entry No."
        else
            DtldVendLedgEntryNoOffset := 0;
        InsertDtldVendLedgEntry(GenJnlLine, TempDtldCVLedgEntryBuf, DtldVendLedgEntry, DtldVendLedgEntryNoOffset, VendLedgEntry."Entry No.");
        CreateGLEntry(GenJnlLine, PayablesAccount, GenJnlLine."Amount (LCY)", GenJnlLine."Source Currency Amount", true, GenJnlLine."System-Created Entry");
    end;

    local procedure InitVendLedgEntry(GenJnlLine: Record "Gen. Journal Line" temporary; var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry.Init();
        VendLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        VendLedgEntry."User ID" := UserId;
        VendLedgEntry."Entry No." := NextEntryNo;
        VendLedgEntry."Transaction No." := NextTransactionNo;
    end;

    local procedure InsertDtldVendLedgEntry(GenJnlLine: Record "Gen. Journal Line" temporary; DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; Offset: Integer; VendorLedgerEntryNo: Integer)
    begin
        DtldVendLedgEntry.Init;
        DtldVendLedgEntry.TransferFields(DtldCVLedgEntryBuf);
        DtldVendLedgEntry."Vendor Ledger Entry No." := VendorLedgerEntryNo;
        DtldVendLedgEntry."Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
        DtldVendLedgEntry."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        DtldVendLedgEntry."Reason Code" := GenJnlLine."Reason Code";
        DtldVendLedgEntry."Source Code" := GenJnlLine."Source Code";
        DtldVendLedgEntry."Transaction No." := NextTransactionNo;
        DtldVendLedgEntry."User ID" := UserId;
        DtldVendLedgEntry."Amount (LCY)" := DtldVendLedgEntry.Amount;
        if DtldVendLedgEntry.Amount > 0 then begin
            DtldVendLedgEntry."Debit Amount" := Abs(DtldVendLedgEntry.Amount);
            DtldVendLedgEntry."Debit Amount (LCY)" := Abs(DtldVendLedgEntry.Amount);
        end else begin
            DtldVendLedgEntry."Credit Amount" := Abs(DtldVendLedgEntry.Amount);
            DtldVendLedgEntry."Credit Amount (LCY)" := Abs(DtldVendLedgEntry.Amount);
        end;
        DtldVendLedgEntry.Insert(true);
    end;

    local procedure GetVendorPostingGroup(GenJournalLine: Record "Gen. Journal Line" temporary; var VendorPostingGroup: Record "Vendor Posting Group")
    begin
        VendorPostingGroup.Get(GenJournalLine."Posting Group");
    end;

    local procedure PostBankAcc(GenJnlLine: Record "Gen. Journal Line" temporary; Balancing: Boolean)
    var
        BankAcc: Record "Bank Account";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        BankAccPostingGr: Record "Bank Account Posting Group";
    begin
        BankAcc.Get(GenJnlLine."Account No.");
        BankAcc.TestField(Blocked, false);
        if GenJnlLine."Currency Code" = '' then
            BankAcc.TestField("Currency Code", '')
        else
            if BankAcc."Currency Code" <> '' then
                GenJnlLine.TestField("Currency Code", BankAcc."Currency Code");
        BankAcc.TestField("Bank Acc. Posting Group");
        BankAccPostingGr.Get(BankAcc."Bank Acc. Posting Group");
        BankAccLedgEntry.LockTable();
        InitBankAccLedgEntry(GenJnlLine, BankAccLedgEntry);
        BankAccLedgEntry."Bank Acc. Posting Group" := BankAcc."Bank Acc. Posting Group";
        BankAccLedgEntry."Currency Code" := BankAcc."Currency Code";
        if BankAcc."Currency Code" <> '' then
            BankAccLedgEntry.Amount := GenJnlLine.Amount
        else
            BankAccLedgEntry.Amount := GenJnlLine."Amount (LCY)";
        BankAccLedgEntry."Amount (LCY)" := GenJnlLine."Amount (LCY)";
        BankAccLedgEntry.Open := GenJnlLine.Amount <> 0;
        BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry.Amount;
        BankAccLedgEntry.Positive := GenJnlLine.Amount > 0;
        BankAccLedgEntry."Amount (LCY)" := BankAccLedgEntry.Amount;
        if BankAccLedgEntry.Amount > 0 then begin
            BankAccLedgEntry."Debit Amount" := Abs(BankAccLedgEntry.Amount);
            BankAccLedgEntry."Debit Amount (LCY)" := Abs(BankAccLedgEntry.Amount);
        end else begin
            BankAccLedgEntry."Credit Amount" := Abs(BankAccLedgEntry.Amount);
            BankAccLedgEntry."Credit Amount (LCY)" := Abs(BankAccLedgEntry.Amount);
        end;
        BankAccLedgEntry.Insert(true);
        BankAccPostingGr.TestField("G/L Account No.");
        CreateGLEntry(GenJnlLine, BankAccPostingGr."G/L Account No.", GenJnlLine."Amount (LCY)", GenJnlLine."Source Currency Amount", true, GenJnlLine."System-Created Entry");
    end;

    local procedure InitBankAccLedgEntry(GenJnlLine: Record "Gen. Journal Line" temporary; var BankAccLedgEntry: Record "Bank Account Ledger Entry")
    begin

        BankAccLedgEntry.Init();
        BankAccLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        BankAccLedgEntry."User ID" := UserId;
        BankAccLedgEntry."Entry No." := NextEntryNo;
        BankAccLedgEntry."Transaction No." := NextTransactionNo;
    end;

    local procedure CreateGLEntry(GenJnlLine: Record "Gen. Journal Line" temporary; GLAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean; SystemCreatedEntry: Boolean)
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJnlLine, GLEntry, GLAccNo, Amount, AmountAddCurr, true, true);
        GLEntry."Source Type" := GenJnlLine."Account Type";
        GLEntry."Source Code" := GenJnlLine."Source Code";
        GLEntry."System-Created Entry" := SystemCreatedEntry;
        GLEntry."Bal. Account Type" := GenJnlLine."Account Type";
        GLEntry."Bal. Account No." := GenJnlLine."Account No.";
        if GLEntry.Amount > 0 then begin
            GLEntry."Debit Amount" := GLEntry.Amount;
        end else begin
            GLEntry."Credit Amount" := Abs(GLEntry.Amount);
        end;
        GLEntry.Insert();
        IncrNextEntryNo();
    end;


    local procedure RunWithCheckBalance(var GenJnlLine2: Record "Gen. Journal Line" temporary)
    var
        Balance: Decimal;
        GenJnlLineCopy: Record "Gen. Journal Line" temporary;
    begin
        if GenJnlLine2.FindSet() then begin
            repeat
                if StrLen(GenJnlLine2."Bal. Account No.") = 0 then begin
                    Balance += GenJnlLine2.Amount;
                end;
            until GenJnlLine2.Next() = 0;
        end;
        if Balance <> 0 then begin
            Error(Text0003, Balance);
        end;
    end;
}