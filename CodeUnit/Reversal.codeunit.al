codeunit 50116 "Reversal Entry"
{
    TableNo = "Reversal Entry";
    trigger OnRun()
    var
        GLReg: Record "G/L Register";
        GenJnlTemplate: Record "Gen. Journal Template";
        PostedDeferralHeader: Record "Posted Deferral Header";
        GenJnlPostReverse: Codeunit "Gen. Jnl.-Post Reverse";
        Txt: Text[1024];
        WarningText: Text[250];
        Number: Integer;
        Handled: Boolean;
        ReversalEntry: Record "Reversal Entry";
        Text008: Label 'Changes have been made to posted entries after the window was opened.\Close and reopen the window to continue.';
        Text003: Label 'The entries were successfully reversed.';

    begin
        ReversalEntry := Rec;

        if Rec."Reversal Type" = Rec."Reversal Type"::Transaction then
            ReversalEntry.SetReverseFilter(Rec."Transaction No.", Rec."Reversal Type")
        else
            ReversalEntry.SetReverseFilter(Rec."G/L Register No.", Rec."Reversal Type");
        ReversalEntry.CheckEntries();
        Rec.Get(1);
        if Rec."Reversal Type" = Rec."Reversal Type"::Register then
            Number := Rec."G/L Register No."
        else
            Number := Rec."Transaction No.";
        if not ReversalEntry.VerifyReversalEntries(Rec, Number, Rec."Reversal Type") then
            Error(Text008);
        Message('Number %1...........%2', Number, Rec.Count);
        GenJnlPostReverse.Reverse(ReversalEntry, Rec);
        Rec.DeleteAll();
        PostedDeferralHeader.DeleteForDoc("Deferral Document Type"::"G/L".AsInteger(), ReversalEntry."Document No.", '', 0, '');
        Message(Text003);
    end;

    var
        GLReg: Record "G/L Register";
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        TempReversalEntry: Record "Reversal Entry" temporary;
        PostedAndAppliedSameTransactionErr: Label 'You cannot reverse register number %1 because it contains customer or vendor or employee ledger entries that have been posted and applied in the same transaction.\\You must reverse each transaction in register number %1 separately.', Comment = '%1="G/L Register No."';
        CannotReverseDeletedErr: Label 'The transaction cannot be reversed, because the %1 has been compressed or a %2 has been deleted.', Comment = '%1 and %2 = table captions';

    local procedure SetReverseFilter(Number: Integer; RevType: Option Transaction,Register)
    begin
        if RevType = RevType::Register then begin
            GLReg.Get(Number);
            GLEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
            CustLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
            VendLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
            BankAccLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
        end;
    end;

    procedure ReverseEntries(Number: Integer) Success: Boolean
    var
        RevType: Option Transaction,Register;
        ReversalPost: Codeunit "Reversal-Post";
        ReversalEntry: Record "Reversal Entry";
        GenJnlPostReverse: Codeunit "Gen. Jnl.-Post Reverse";
        Text002: Label 'Do you want to reverse the entries?';
        Text003: Label 'The entries were successfully reversed.';
        Text005: Label 'To reverse these entries, correcting entries will be posted.';
        Txt: Text;
        ReverseEntry: Codeunit "Reversal Entry";
    begin
        Clear(TempReversalEntry);
        // Message('%1.................', Number);
        InsertReversalEntry(Number, RevType::Register);
        TempReversalEntry.SetCurrentKey("Document No.", "Posting Date", "Entry Type", "Entry No.");
        ReversalEntry := TempReversalEntry;
        Txt := StrSubstNo('%1\%2', Text005, Text002);
        ReverseEntry.Run(TempReversalEntry);
        exit(true);
        // Message('%1....fist.......%2', ReversalEntry.Count, TempReversalEntry.Count);
        // if Confirm(Txt, false) then begin
        //     if Confirm('Choose Default?', false) then begin
        //         ReversalPost.Run(TempReversalEntry);
        //     end else begin
        //         ReverseEntry.Run(TempReversalEntry);
        //     end;
        //     //Message(Text003);
        //     exit(true);

        // end;


        Page.RunModal(PAGE::"Reverse Transaction Entries", TempReversalEntry);
        TempReversalEntry.DeleteAll();
        exit(Success)
    end;

    local procedure RunReversal(var Rec: Record "Reversal Entry")
    var

    begin

    end;



    local procedure InsertReversalEntry(Number: Integer; RevType: Option Transaction,Register)
    var
        TempRevertTransactionNo: Record "Integer" temporary;
        NextLineNo: Integer;
    begin
        TempReversalEntry.DeleteAll();
        NextLineNo := 1;
        TempRevertTransactionNo.Number := Number;
        TempRevertTransactionNo.Insert();
        SetReverseFilter(Number, RevType);
        InsertFromCustLedgEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        InsertFromVendLedgEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        InsertFromBankAccLedgEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        InsertFromGLEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        if TempReversalEntry.FindFirst() then;
    end;

    local procedure InsertFromCustLedgEntry(var TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        myInt: Integer;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        Cust: Record Customer;
    begin
        DtldCustLedgEntry.SetCurrentKey("Transaction No.", "Customer No.", "Entry Type");
        DtldCustLedgEntry.SetFilter(
          "Entry Type", '<>%1', DtldCustLedgEntry."Entry Type"::"Initial Entry");
        if CustLedgEntry.FindSet then
            repeat
                DtldCustLedgEntry.SetRange("Transaction No.", CustLedgEntry."Transaction No.");
                DtldCustLedgEntry.SetRange("Customer No.", CustLedgEntry."Customer No.");
                if (not DtldCustLedgEntry.IsEmpty) and (RevType = RevType::Register) then
                    Error(PostedAndAppliedSameTransactionErr, Number);
                Clear(TempReversalEntry);
                if RevType = RevType::Register then
                    TempReversalEntry."G/L Register No." := Number;
                TempReversalEntry."Reversal Type" := RevType;
                TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Customer;
                Cust.Get(CustLedgEntry."Customer No.");
                TempReversalEntry."Account No." := Cust."No.";
                TempReversalEntry."Account Name" := Cust.Name;
                TempReversalEntry.CopyFromCustLedgEntry(CustLedgEntry);
                TempReversalEntry."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                TempReversalEntry.Insert();
                DtldCustLedgEntry.SetRange(Unapplied, true);
                if DtldCustLedgEntry.FindSet then
                    repeat
                        InsertCustTempRevertTransNo(TempRevertTransactionNo, DtldCustLedgEntry."Unapplied by Entry No.");
                    until DtldCustLedgEntry.Next() = 0;
                DtldCustLedgEntry.SetRange(Unapplied);
            until CustLedgEntry.Next() = 0;
    end;

    local procedure InsertCustTempRevertTransNo(var TempRevertTransactionNo: Record "Integer" temporary; CustLedgEntryNo: Integer)
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry.Get(CustLedgEntryNo);
        if DtldCustLedgEntry."Transaction No." <> 0 then begin
            TempRevertTransactionNo.Number := DtldCustLedgEntry."Transaction No.";
            if TempRevertTransactionNo.Insert() then;
        end;
    end;

    local procedure InsertFromVendLedgEntry(var TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        Vend: Record Vendor;
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry.SetCurrentKey("Transaction No.", "Vendor No.", "Entry Type");
        DtldVendLedgEntry.SetFilter(
          "Entry Type", '<>%1', DtldVendLedgEntry."Entry Type"::"Initial Entry");
        if VendLedgEntry.FindSet then
            repeat
                DtldVendLedgEntry.SetRange("Transaction No.", VendLedgEntry."Transaction No.");
                DtldVendLedgEntry.SetRange("Vendor No.", VendLedgEntry."Vendor No.");
                if (not DtldVendLedgEntry.IsEmpty) and (RevType = RevType::Register) then
                    Error(PostedAndAppliedSameTransactionErr, Number);
                Clear(TempReversalEntry);
                if RevType = RevType::Register then
                    TempReversalEntry."G/L Register No." := Number;
                TempReversalEntry."Reversal Type" := RevType;
                TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Vendor;
                Vend.Get(VendLedgEntry."Vendor No.");
                TempReversalEntry."Account No." := Vend."No.";
                TempReversalEntry."Account Name" := Vend.Name;
                TempReversalEntry.CopyFromVendLedgEntry(VendLedgEntry);
                TempReversalEntry."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                TempReversalEntry.Insert();
                DtldVendLedgEntry.SetRange(Unapplied, true);
                if DtldVendLedgEntry.FindSet then
                    repeat
                        InsertVendTempRevertTransNo(TempRevertTransactionNo, DtldVendLedgEntry."Unapplied by Entry No.");
                    until DtldVendLedgEntry.Next() = 0;
                DtldVendLedgEntry.SetRange(Unapplied);
            until VendLedgEntry.Next() = 0;
    end;

    local procedure InsertVendTempRevertTransNo(var TempRevertTransactionNo: Record "Integer" temporary; VendLedgEntryNo: Integer)
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry.Get(VendLedgEntryNo);
        if DtldVendLedgEntry."Transaction No." <> 0 then begin
            TempRevertTransactionNo.Number := DtldVendLedgEntry."Transaction No.";
            if TempRevertTransactionNo.Insert() then;
        end;
    end;

    local procedure InsertFromBankAccLedgEntry(TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        BankAcc: Record "Bank Account";
    begin
        if BankAccLedgEntry.FindSet then
            repeat
                Clear(TempReversalEntry);
                if RevType = RevType::Register then
                    TempReversalEntry."G/L Register No." := Number;
                TempReversalEntry."Reversal Type" := RevType;
                TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::"Bank Account";
                BankAcc.Get(BankAccLedgEntry."Bank Account No.");
                TempReversalEntry."Account No." := BankAcc."No.";
                TempReversalEntry."Account Name" := BankAcc.Name;
                TempReversalEntry.CopyFromBankAccLedgEntry(BankAccLedgEntry);
                TempReversalEntry."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                TempReversalEntry.Insert();
            until BankAccLedgEntry.Next() = 0;
    end;

    local procedure InsertFromGLEntry(var TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        GLAcc: Record "G/L Account";
    begin
        TempRevertTransactionNo.FindSet();
        repeat
            if RevType = RevType::Transaction then
                GLEntry.SetRange("Transaction No.", TempRevertTransactionNo.Number);
            if GLEntry.FindSet then
                repeat
                    Clear(TempReversalEntry);
                    if RevType = RevType::Register then
                        TempReversalEntry."G/L Register No." := Number;
                    TempReversalEntry."Reversal Type" := RevType;
                    TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::"G/L Account";
                    if not GLAcc.Get(GLEntry."G/L Account No.") then
                        Error(CannotReverseDeletedErr, GLEntry.TableCaption, GLAcc.TableCaption);
                    TempReversalEntry."Account No." := GLAcc."No.";
                    TempReversalEntry."Account Name" := GLAcc.Name;
                    TempReversalEntry.CopyFromGLEntry(GLEntry);
                    TempReversalEntry."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 1;
                    TempReversalEntry.Insert();
                until GLEntry.Next() = 0;
        until TempRevertTransactionNo.Next() = 0;
    end;
}