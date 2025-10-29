codeunit 50039 "Cash Management"
{
    // version TL2.0


    trigger OnRun();
    begin

    end;

    var
        BankAccount: Record "Bank Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        Bank: Record "Bank Account";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PVLines: Record "Payment/Receipt Lines";
        GenJlLine: Record "Gen. Journal Line";
        //CashMngtSetup: Record "Cash Management Setup";
        LineNo: Integer;
        AccountType: Enum "Gen. Journal Account Type";
        "AppliesToDocNo.": Code[20];
        AppliesToDocNoType: Enum "Gen. Journal Document Type";// Option Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        ShortcutDimension1Code: Code[10];
        PurchInvHeader: Record "Purch. Inv. Header";
        //  KRATaxCodes: Record "KRA Tax Codes";
        KRADescription: Text[60];
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        PVReceipts: Record "Payment/Receipt Voucher";
        User: Record User;
        DocumentType: Option PV,Imprest,"Imprest Surrender";
        Empl: Record Employee;
        DimensionValue: Record "Dimension Value";
        EmpName: Text;
        CustAccount: Code[20];
        // AccountMappingType: Record "Account Mapping Type";
        //AccountMapping: Record "Account Mapping";
        GenJournalBatch: Record "Gen. Journal Batch";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        // ImprestLines: Record "Imprest Lines";
        //ImprestLinesCopy: Record "Imprest Lines";
        //  ImprestManagement: Record "Imprest Management";
        // ImprestMgt: Record "Imprest Management";
        //VendorLedgerEntry: Record "Vendor Ledger Entry";
        // ImprestManagementCopy: Record "Imprest Management";
        RefundAmount: Decimal;
        NoSeriesMgt: Codeunit "No. Series";
        GLAccount: Record "G/L Account";
        JournalDocumentType: Enum "Gen. Journal Document Type";
        // Payment_Type: Enum "Payment Type";
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        Text001: Label 'ZERO';
        Text002: Label 'ONE';
        Text003: Label 'TWO';
        Text004: Label 'THREE';
        Text005: Label 'FOUR';
        Text006: Label 'FIVE';
        Text007: Label 'SIX';
        Text008: Label 'SEVEN';
        Text009: Label 'EIGHT';
        Text010: Label 'NINE';
        Text011: Label 'TEN';
        Text012: Label 'ELEVEN';
        Text013: Label 'TWELVE';
        Text014: Label 'THIRTEEN';
        Text015: Label 'FOURTEEN';
        Text016: Label 'FIFTEEN';
        Text017: Label 'SIXTEEN';
        Text018: Label 'SEVENTEEN';
        Text019: Label 'EIGHTEEN';
        Text020: Label 'NINETEEN';
        Text021: Label 'TWENTY';
        Text022: Label 'THIRTY';
        Text023: Label 'FORTY';
        Text024: Label 'FIFTY';
        Text025: Label 'SIXTY';
        Text026: Label 'SEVENTY';
        Text027: Label 'EIGHTY';
        Text028: Label 'NINETY';
        Text029: Label 'HUNDRED';
        Text030: Label 'THOUSAND';
        ExponentText: array[5] of Text[30];
        Text031: Label 'MILLION';
        NumberText: array[2] of Text[200];
        MyAmountInWord: Text[200];
        Text032: Label 'BILLLION';
        Text033: Label 'AND';
        Text034: Label '%1 results in a written number that is too long.';
        DescriptionLine: array[2] of Text[200];
        //  BudgetManagement: Codeunit "Budget Management";
        // GetUser: Codeunit "Get User";
        PostBatch: Codeunit "Gen. Jnl.-Post Batch";
        PostJnl: Codeunit "Gen. Jnl.-Post";
        JournalLine: Record "Gen. Journal Line" temporary;
        //PaymentChanell: Enum "Payment Channels";
        PostLine: Codeunit "Optimized Gen. Jnl.-Post Line";

    procedure GetBankAccountName("BankAccountNo.": Code[20]) AccountName: Code[70];
    begin
        BankAccount.RESET;
        IF BankAccount.GET("BankAccountNo.") THEN BEGIN
            AccountName := BankAccount.Name;
        END;
    end;

    procedure "GetVendor/CustomerName"("AccountNo.": Code[20]; "Account Type": Enum "Gen. Journal Account Type") AccountName: Text[100];
    begin
        CASE "Account Type" OF
            "Account Type"::Vendor:
                BEGIN
                    IF Vendor.GET("AccountNo.") THEN BEGIN
                        AccountName := Vendor.Name;
                    END
                END;
            "Account Type"::Customer:
                BEGIN
                    IF Customer.GET("AccountNo.") THEN BEGIN
                        AccountName := Customer.Name;
                    END;
                END;
            "Account Type"::"G/L Account":
                BEGIN
                    IF GLAccount.GET("AccountNo.") THEN BEGIN
                        AccountName := GLAccount.Name;
                    END;
                END;
            "Account Type"::"Fixed Asset":
                BEGIN
                    IF FixedAsset.GET("AccountNo.") THEN BEGIN
                        AccountName := FixedAsset.Description;
                    END;
                END;
            "Account Type"::"Bank Account":
                begin
                    BankAccount.Reset();
                    if BankAccount.Get("AccountNo.") then begin
                        AccountName := BankAccount.Name;
                    end;
                end;
        END;
        exit(AccountName);
    end;

    procedure LookUpAppliesToDocVend("AccountNo.": Code[20]; var ExternalDocumentNo: Code[35]; var RemainingAmount: Decimal; var Description: Text[50]) "AppliestoDoc.No": Code[20];
    begin
        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive, "Due Date");
        if "AccountNo." <> '' then begin
            VendLedgEntry.SetRange("Vendor No.", "AccountNo.");
            VendLedgEntry.SetRange(Open, true);
            VendLedgEntry.SetRange(Positive, false);
            IF PAGE.RUNMODAL(0, VendLedgEntry) = ACTION::LookupOK THEN BEGIN
                VendLedgEntry.CalcFields("Remaining Amount");
                "AppliestoDoc.No" := VendLedgEntry."Document No.";
                ExternalDocumentNo := VendLedgEntry."External Document No.";
                RemainingAmount := Abs(VendLedgEntry."Remaining Amount");
                Description := CopyStr(VendLedgEntry.Description, 1, 50);
            END;
        end;
    end;

    procedure LookUpAppliesToDocVendRcpt("AccountNo.": Code[20]) "AppliestoDoc.No": Code[20];
    begin
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
        IF "AccountNo." <> '' THEN BEGIN
            VendLedgEntry.SETRANGE("Vendor No.", "AccountNo.");
            VendLedgEntry.SETRANGE(Open, TRUE);
            VendLedgEntry.SETRANGE(Positive, TRUE);
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            IF PAGE.RUNMODAL(0, VendLedgEntry) = ACTION::LookupOK THEN BEGIN
                "AppliestoDoc.No" := VendLedgEntry."Document No.";
            END;
        END;
    end;

    procedure LookUpAppliesToDocCust("AccountNo.": Code[20]) "AppliestoDoc.No": Code[20];
    begin
        CustLedgerEntry.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date");
        IF "AccountNo." <> '' THEN BEGIN
            CustLedgerEntry.SETRANGE("Customer No.", "AccountNo.");
            CustLedgerEntry.SETRANGE(Open, TRUE);
            CustLedgerEntry.SETRANGE(Positive, TRUE);
            CustLedgerEntry.CALCFIELDS("Remaining Amount");
            IF PAGE.RUNMODAL(0, CustLedgerEntry) = ACTION::LookupOK THEN BEGIN
                "AppliestoDoc.No" := CustLedgerEntry."Document No.";
            END;
        END;
    end;

    procedure ArchivePaymentVoucher(PaymentVoucher: Record "Payment/Receipt Voucher")
    var
        ConfirmLbl: Label 'Are you sure you want to Archive Payment Vocuher No. %1 (%2)?';
    begin
        if Confirm(StrSubstNo(ConfirmLbl, PaymentVoucher."Paying Code.", PaymentVoucher.Description), false) then begin
            PaymentVoucher.TestField(Posted, false);
            PaymentVoucher.Status := PaymentVoucher.Status::Archived;
            PaymentVoucher.Modify();
            Message('Payment Vocuher No. %1 (%2) Successfully Archived!', PaymentVoucher."Paying Code.", PaymentVoucher.Description);
        end;
    end;

    /*  procedure PostingPaymentVoucher(PaymentVoucher: Record "Payment/Receipt Voucher"; Preview: Boolean)
      var
          //Taxation: Record "Taxation Setup";
         // WTax: Record "W/Tax On Payments";
          m: Integer;
          GenJnlPost: Codeunit "Gen. Jnl.-Post";
          PostLable: Label 'Are you sure you want to post the Payment Voucher No. %1?';
          PreviewLabel: Label 'Are you sure you want to Preview posting Lines for Payment Voucher No. %1?';
          ConfirmTxt: Text[200];
          TaxAmount: Decimal;
          AccountNo: Code[20];
          TaxDescription: Text[50];
      begin
          WITH PaymentVoucher DO BEGIN
            //  Clear(PaymentChanell);
              UserSetup.Reset();
              UserSetup.GET(UserId);
              if not Preview then begin
                  IF Status <> Status::Released THEN BEGIN
                      ERROR('The Payment Voucher No. %1 Cannot be Posted before it is fully Approved', "Paying Code.");
                  END;
              end;
              IF Posted = true THEN BEGIN
                  ERROR('Payment Voucher %1 has been posted', "Paying Code.");
              END;
              LineNo := 1000;
              CashMngtSetup.RESET;
              CashMngtSetup.GET;
              CashMngtSetup.TestField("PV Template");
              GenJournalBatch.INIT;
              GenJournalBatch."Journal Template Name" := CashMngtSetup."PV Template";
              GenJournalBatch.Name := "Paying Code.";
              IF NOT GenJournalBatch.GET(CashMngtSetup."PV Template", "Paying Code.") THEN BEGIN
                  GenJournalBatch.INSERT;
              END;
              GenJlLine.RESET;
              GenJlLine.SETRANGE("Journal Template Name", CashMngtSetup."PV Template");
              GenJlLine.SETRANGE("Journal Batch Name", "Paying Code.");
              GenJlLine.DELETEALL;
              CalcFields("Net Amount");
              if Preview then begin
                  ConfirmTxt := StrSubstNo(PreviewLabel, "Paying Code.");
              end else begin
                  ConfirmTxt := StrSubstNo(PostLable, "Paying Code.");
              end;
              Clear(Payment_Type);
              case "Payment Mode" of
                  "Payment Mode"::Cash:
                      begin
                          Payment_Type := Payment_Type::Cash;
                      end;
                  "Payment Mode"::Cheque:
                      begin
                          Payment_Type := Payment_Type::Cheque;
                          if not Preview then TestField("Cheque No.");
                      end;
              end;
              if Confirm(ConfirmTxt, false) then begin
                  if "Payment Mode" in ["Payment Mode"::Cheque, "Payment Mode"::Cash, "Payment Mode"::"RTGS/EFT"] then begin
                      AccountType := AccountType::"Bank Account";
                  end else
                      if "Payment Mode" in ["Payment Mode"::FOSA] then begin
                          AccountType := AccountType::Vendor;
                      end else begin
                          Error('The Payment Voucher Do not have Paymnet Mode!');
                      end;
                  MakeJournalEntries(LineNo, "Paying Code.", "Cheque No.", Description, -"Net Amount", AccountType, "Paying Bank", "Payment Date", AccountType::"G/L Account", '', "AppliesToDocNo.", AppliesToDocNoType::" ", ShortcutDimension1Code,
                  CashMngtSetup."PV Template", "Paying Code.", "Global Dimension 1 Code", UserSetup."Global Dimension 2 Code", Payment_Type);
                  PVLines.Reset();
                  PVLines.SetRange(Code, "Paying Code.");
                  if PVLines.FindSet() then begin
                      repeat
                          LineNo += 100;
                          if StrLen(PVLines."Global Dimension 1 Code") = 0 then begin
                              PVLines."Global Dimension 1 Code" := "Global Dimension 1 Code";
                          end;
                          MakeJournalEntries(LineNo, "Paying Code.", "Cheque No.", PVLines.Description, PVLines.Amount, PVLines."Account Type", PVLines."Account No.", "Payment Date", AccountType::"G/L Account", '', PVLines."Applies to Doc. No", PVLines."Apples to Doc Type", '',
                           CashMngtSetup."PV Template", "Paying Code.", PVLines."Global Dimension 1 Code", PVLines."Global Dimension 2 Code", Payment_Type);
                          WTax.Reset();
                          WTax.SetRange("PV No.", "Paying Code.");
                          WTax.SetRange("PV Line Entry No.", PVLines."Line No");
                          if WTax.FindSet() then begin
                              repeat
                                  LineNo += 100;
                                  WTax.TestField("W/Tax Code");
                                  WTax.TestField("W/Tax Amount");
                                  WTax.TestField(Description);
                                  if WTax."Deduction Type" = WTax."Deduction Type"::"Tax Withholding" then begin
                                      Taxation.Reset();
                                      Taxation.Get(WTax."W/Tax Code");
                                      Taxation.TestField("Control G/L Account");
                                      AccountType := AccountType::"G/L Account";
                                      AccountNo := Taxation."Control G/L Account";
                                      TaxDescription := CopyStr(Description, 1, MaxStrLen(TaxDescription));
                                  end else
                                      if WTax."Deduction Type" = WTax."Deduction Type"::Customer then begin
                                          AccountType := AccountType::Customer;
                                          AccountNo := WTax."W/Tax Code";
                                          TaxDescription := CopyStr(WTax.Description, 1, MaxStrLen(TaxDescription));
                                      end;
                                  TaxAmount := -WTax."W/Tax Amount";
                                  MakeJournalEntries(LineNo, "Paying Code.", "Cheque No.", TaxDescription, TaxAmount, AccountType, AccountNo, "Payment Date", AccountType::"G/L Account", '', '', JournalDocumentType::" ", '',
                                  CashMngtSetup."PV Template", "Paying Code.", PVLines."Global Dimension 1 Code", PVLines."Global Dimension 2 Code", Payment_Type);
                              until WTax.Next() = 0;
                          end;
                          if not Preview then begin
                              if (PVLines."Is Imprest") and (StrLen(PVLines."Imprest No") > 0) then begin
                                  PVLines.CalcFields("Already Posted");
                                  if (PVLines."Already Posted") then begin
                                      Error('Document No. %1 has already been posted!', PVLines."Imprest No");
                                  end else begin
                                      MarkImprestAsPosted(PVLines."Imprest No", "Paying Code.");
                                  end;
                              end;
                          end;
                      until PVLines.Next() = 0;
                  end;
              end;
              if Preview then begin
                  Commit();
                  GenJlLine.Reset();
                  GenJlLine.SetRange("Journal Template Name", CashMngtSetup."PV Template");
                  GenJlLine.SetRange("Journal Batch Name", "Paying Code.");
                  if GenJlLine.FindFirst() then begin
                      GenJnlPost.Preview(GenJlLine);
                  end;
              end else begin
                  GenJlLine.RESET;
                  GenJlLine.SETRANGE("Journal Template Name", CashMngtSetup."PV Template");
                  GenJlLine.SETRANGE("Journal Batch Name", "Paying Code.");
                  m := GenJlLine.Count;
                  Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJlLine);
                  if m <> GenJlLine.Count then begin
                      Posted := true;
                      "Payment Date" := Today;
                      "Posted By" := UserId;
                      "Time Posted" := TIME;
                      "Date Posted" := Today;
                      GenJournalBatch.Reset();
                      if GenJournalBatch.GET(CashMngtSetup."PV Template", "Paying Code.") then begin
                          GenJournalBatch.Delete()
                      end;
                      Modify();
                      Message('Payment Voucher Successfully Posted');
                  end;
              end;
          end;
      end;

     procedure PostingReceipttVoucher(PaymentVoucher: Record "Payment/Receipt Voucher"; Preview: Boolean)
      var
          PostLabel: Label 'Are you sure you want to post the Receipt Voucher No. %1 (%2)?';
          PreviewLabel: Label 'Are you sure you want to Preview Posting Receipt Voucher No. %1 (%2)?';
          ConfirmTxt: Text[250];
          GenJnlPost: Codeunit "Gen. Jnl.-Post";
          m: Integer;
      begin
          WITH PaymentVoucher DO BEGIN
              TestField("Paying Bank");
              TestField(Description);
              CalcFields(Amount);
              TestField(Amount);
              TestField("Payee Name");
              TestField("Global Dimension 1 Code");
              UserSetup.GET(USERID);
              IF Posted = true THEN BEGIN
                  ERROR('Payment Voucher %1 has been posted', "Paying Code.");
              END;
              if Preview then begin
                  ConfirmTxt := StrSubstNo(PreviewLabel, "Paying Code.", Description);
              end else begin
                  ConfirmTxt := StrSubstNo(PostLabel, "Paying Code.", Description);
              end;
              Clear(PaymentChanell);
              LineNo := 1000;
              CashMngtSetup.RESET;
              CashMngtSetup.GET;
              GenJournalBatch.INIT;
              GenJournalBatch."Journal Template Name" := CashMngtSetup."Cash Receipt Template";
              GenJournalBatch.Name := "Paying Code.";
              IF NOT GenJournalBatch.GET(CashMngtSetup."Cash Receipt Template", "Paying Code.") THEN BEGIN
                  GenJournalBatch.INSERT;
              END;
              GenJlLine.RESET;
              GenJlLine.SETRANGE("Journal Template Name", CashMngtSetup."Cash Receipt Template");
              GenJlLine.SETRANGE("Journal Batch Name", "Paying Code.");
              GenJlLine.DELETEALL;
              CALCFIELDS("Net Amount");
              if Confirm(ConfirmTxt, false) then begin
                  Clear(Payment_Type);
                  case "Payment Mode" of
                      "Payment Mode"::cash:
                          begin
                              Payment_Type := Payment_Type::Cash;
                          end;
                  end;
                  MakeJournalEntries(LineNo, "Paying Code.", "Cheque No.", Description, "Net Amount", AccountType::"Bank Account", "Paying Bank", "Payment Date", AccountType::"G/L Account", '', "AppliesToDocNo.", AppliesToDocNoType::Refund, ShortcutDimension1Code,
                 CashMngtSetup."Cash Receipt Template", "Paying Code.", "Global Dimension 1 Code", UserSetup."Global Dimension 2 Code", Payment_Type);
                  LineNo := LineNo + 100;
                  PVLines.RESET;
                  PVLines.SETRANGE(Code, "Paying Code.");
                  IF PVLines.FINDFIRST THEN BEGIN
                      REPEAT
                          LineNo := LineNo + PVLines."Line No";
                          ShortcutDimension1Code := PVLines."Global Dimension 1 Code";
                          if StrLen(ShortcutDimension1Code) = 0 then begin
                              ShortcutDimension1Code := "Global Dimension 1 Code";
                          end;
                          MakeJournalEntries(LineNo, "Paying Code.", "Cheque No.", PVLines.Description, -PVLines."Net Amount", PVLines."Account Type", PVLines."Account No.", "Payment Date", AccountType::"G/L Account", '', PVLines."Applies to Doc. No", AppliesToDocNoType::Payment, '',
                          GenJournalBatch."Journal Template Name", GenJournalBatch.Name, ShortcutDimension1Code, PVLines."Global Dimension 2 Code", Payment_Type);
                          IF PVLines."Account Type" = PVLines."Account Type"::Customer THEN BEGIN
                              IF PVLines."Applies to Doc. No" <> '' THEN BEGIN
                                  if not Preview then begin
                                      MarkImprestAsSurrendered(PVLines."Applies to Doc. No", PVLines."Net Amount", PVLines."Account No.");
                                      ClearSalaryAdvance(PVLines."Account No.", PVLines."Applies to Doc. No", PVLines."Net Amount");
                                  end;
                              END;
                          END;
                      UNTIL PVLines.Next() = 0;
                  end;
                  if Preview then begin
                      Commit();
                      GenJlLine.RESET;
                      GenJlLine.SETRANGE("Journal Template Name", CashMngtSetup."PV Template");
                      GenJlLine.SETRANGE("Journal Batch Name", "Paying Code.");
                      if GenJlLine.FindFirst() then begin
                          GenJnlPost.Preview(GenJlLine);
                      end;
                  end else begin
                      GenJlLine.RESET;
                      GenJlLine.SETRANGE("Journal Template Name", CashMngtSetup."PV Template");
                      GenJlLine.SETRANGE("Journal Batch Name", "Paying Code.");
                      m := GenJlLine.Count;
                      CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJlLine);
                      if m <> GenJlLine.Count then begin
                          Posted := true;
                          "Posted By" := UserId;
                          "Time Posted" := Time;
                          "Date Posted" := Today;
                          Modify();
                          GenJournalBatch.Reset();
                          IF GenJournalBatch.GET(CashMngtSetup."Cash Receipt Template", "Paying Code.") THEN BEGIN
                              GenJournalBatch.Delete();
                          END;
                          Message('Receipt Voucher Successfully Posted');
                      end;
                  end;

              end;

          END;
      end;
  */
    Local procedure MakeGenJournalEntries(LineNo: Integer; TemplateName: Code[20]; BatchName: Code[20]; DocumentNo: Code[20]; AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20]; Amount: Decimal; Description: Text[50]; BranchCode: Code[20]; Imprest: Enum "Gen. Journal Account Type"; AppliestoDocNo: Code[20])

    begin
        GenJlLine.Init();
        GenJlLine."Line No." := LineNo;
        GenJlLine."Journal Template Name" := TemplateName;
        GenJlLine."Journal Batch Name" := BatchName;
        GenJlLine."Posting Date" := Today;
        GenJlLine."Document No." := DocumentNo;
        GenJlLine."Account Type" := AccountType;
        GenJlLine.Validate("Account No.", AccountNo);
        GenJlLine.Validate(Amount, Amount);
        GenJlLine.Description := Description;
        GenJlLine.Validate("Shortcut Dimension 1 Code", BranchCode);
        /*if Imprest = Imprest::"Imprest Surrender" then begin
            if AccountType = AccountType::Customer then begin
              //  ImprestMgt.Reset();
               // if ImprestMgt.Get(DocumentNo) then begin
                  //  ImprestMgt.CalcFields("Applies-to Doc. No.");
               //     GenJlLine."Applies-to Doc. No." := ImprestMgt."Applies-to Doc. No.";
                end;
            end;
        end else
            if (Imprest = Imprest::"Normal Petty Cash") and (AccountType = AccountType::Customer) and (StrLen(AppliestoDocNo) > 0) then begin
                // GenJlLine."Applies-to Doc. No." := AppliestoDocNo;
            end;*/
        GenJlLine."Gen. Posting Type" := GenJlLine."Gen. Posting Type"::" ";
        GenJlLine."Gen. Bus. Posting Group" := '';
        GenJlLine."Gen. Prod. Posting Group" := '';
        GenJlLine."VAT Prod. Posting Group" := '';
        GenJlLine."VAT Bus. Posting Group" := '';
        if (Amount <> 0) then begin
            if StrLen(GenJlLine."Shortcut Dimension 1 Code") = 0 then begin
                GenJlLine.Validate("Shortcut Dimension 1 Code", BranchCode);
            end;
            GenJlLine.Insert();
        end;
    end;


    procedure MakeJournalEntries(LineNo: Integer; DocumentNo: Code[20]; ExtDocumentNo: Code[20]; Description: Text[60]; Amount: Decimal; AccountType: Enum "Gen. Journal Account Type"; "Account No.": Code[20];
     PostingDate: Date; BalAccountType: Enum "Gen. Journal Account Type"; "Bal. Account No.": Code[20]; AppliesToDocNo: Code[20]; AppliesToDocNoType: Enum "Gen. Journal Document Type";
     ShortcutDimension1Code: Code[20]; JournalTemplate: Code[20]; BatchTemplate: Code[20]; BranchCode: Code[20]; Dimension2: Code[20]; PaymentType: Enum "Gen. Journal Account Type")
    begin
        GenJlLine.Init();
        GenJlLine."Line No." := LineNo;
        GenJlLine."Account Type" := AccountType;
        GenJlLine.Validate("Account No.", "Account No.");
        GenJlLine.VALIDATE("Account No.");
        GenJlLine."Posting Date" := Today;
        /* if Dimension2 = 'PD' then begin
             GenJlLine."Posting Date" := PostingDate;
         end;*/
        GenJlLine.Description := Description;
        GenJlLine."Document No." := DocumentNo;
        GenJlLine."External Document No." := ExtDocumentNo;
        GenJlLine.Validate(Amount, Amount);
        GenJlLine."Gen. Bus. Posting Group" := '';
        GenJlLine."Gen. Prod. Posting Group" := '';
        GenJlLine.Validate("Shortcut Dimension 1 Code", BranchCode);
        GenJlLine.VALIDATE(Amount);
        if (GenJlLine."Account Type" = GenJlLine."Account Type"::Vendor)
        and (GenJlLine.Amount > 0) and (StrLen(AppliesToDocNo) > 0)
         then begin
            GenJlLine."Applies-to Doc. Type" := GenJlLine."Applies-to Doc. Type"::Invoice;
        end;
        // GenJlLine."Payment Type" := PaymentType;
        GenJlLine."Applies-to Doc. No." := AppliesToDocNo;
        GenJlLine."Journal Template Name" := JournalTemplate;
        GenJlLine."Journal Batch Name" := BatchTemplate;
        GenJlLine."Bal. Account Type" := BalAccountType;
        // GenJlLine."Payment Channel" := PaymentChanell;
        GenJlLine.Validate("Bal. Account No.", "Bal. Account No.");
        IF GenJlLine.Amount <> 0 THEN BEGIN
            if StrLen(GenJlLine."Shortcut Dimension 1 Code") = 0 then begin
                GenJlLine.Validate("Shortcut Dimension 1 Code", BranchCode);
            end;
            GenJlLine.Insert();
        END;
        // Message('BC....%1...dr..%2....desc.......%3..............%4', GenJlLine."Shortcut Dimension 1 Code", BranchCode, "Account No.", Description);
    end;

    /*procedure GetCustomerAppliesDocNo(DocumentNo: Code[20]): Code[20];
    begin
        ImprestManagement.RESET;
        IF ImprestManagement.GET(DocumentNo) THEN BEGIN
            IF ImprestManagement."Applies-to Doc. No." <> '' THEN BEGIN
                EXIT(ImprestManagement."Applies-to Doc. No.");
            END ELSE BEGIN
                EXIT(ImprestManagement."Imprest To Surrender");
            END;
        END;
    end;*/

    /*procedure VATWithheld(AccountNo: Code[20]; AppliesToDocNo: Code[20]; GrossAmount: Decimal) VATAmount: Decimal;
    begin
        IF Vendor.GET(AccountNo) THEN BEGIN
            IF Vendor."VAT Withheld" <> '' THEN BEGIN
                IF KRATaxCodes.GET(Vendor."VAT Withheld") THEN BEGIN
                    KRATaxCodes.TESTFIELD(Percentage);
                    KRATaxCodes.TESTFIELD("Account No.");
                    IF PurchInvHeader.GET(AppliesToDocNo) THEN BEGIN
                        PurchInvHeader.CALCFIELDS(Amount, "Amount Including VAT");
                        IF GrossAmount > PurchInvHeader."Amount Including VAT" THEN BEGIN
                            ERROR('Gross Amount CANNOT be more Than Purchase Invoice Amount %1,', PurchInvHeader."Amount Including VAT");
                        END ELSE BEGIN
                            VATAmount := ROUND((KRATaxCodes.Percentage / 100) * PurchInvHeader.Amount, 0.01);
                        END;
                    END;
                END;
            END;
        END
    end;*/

    /* procedure WTaxAmount(AccountNo: Code[20]; AppliesToDocNo: Code[20]; GrossAmount: Decimal) WTaxAmount: Decimal;
     begin
         IF Vendor.GET(AccountNo) THEN BEGIN
             IF Vendor."VAT Withheld" <> '' THEN BEGIN
                 IF KRATaxCodes.GET(Vendor."Withholding Tax") THEN BEGIN
                     KRATaxCodes.TESTFIELD(Percentage);
                     KRATaxCodes.TESTFIELD("Account No.");
                     IF PurchInvHeader.GET(AppliesToDocNo) THEN BEGIN
                         PurchInvHeader.CALCFIELDS(Amount, "Amount Including VAT");
                         IF GrossAmount > PurchInvHeader."Amount Including VAT" THEN BEGIN
                             ERROR('Gross Amount CANNOT be more Than Purchase Invoice Amount %1,', PurchInvHeader."Amount Including VAT");
                         END ELSE BEGIN
                             WTaxAmount := ROUND((KRATaxCodes.Percentage / 100) * PurchInvHeader.Amount, 0.01);
                         END;
                     END;
                 END;
             END;
         END
     end;

     procedure ConcatenateKBACodes(KBACodes: Record "KBA Codes") KBACode: Code[10];
     begin
         IF STRLEN(KBACodes."KBA Code") = 1 THEN BEGIN
             KBACodes."KBA Branch Code" := '00' + '' + KBACodes."KBA Branch Code";
         END;
         IF STRLEN(KBACodes."KBA Branch Code") = 2 THEN BEGIN
             KBACodes."KBA Branch Code" := '0' + '' + KBACodes."KBA Branch Code";
         END;
         KBACode := KBACodes."Bank Code" + '' + KBACodes."KBA Branch Code";
     end;

     procedure KBABranchCodes(KBACodes: Record "KBA Codes") KBABranchCode: Code[10];
     begin
         IF STRLEN(KBACodes."KBA Code") = 1 THEN BEGIN
             KBACodes."KBA Branch Code" := '00' + '' + KBACodes."KBA Branch Code";
         END;
         IF STRLEN(KBACodes."KBA Branch Code") = 2 THEN BEGIN
             KBACodes."KBA Branch Code" := '0' + '' + KBACodes."KBA Branch Code";
         END;
         KBABranchCode := KBACodes."KBA Branch Code";
     end;
 */
    procedure RequiredFields(PVReceipts: Record "Payment/Receipt Voucher");
    begin
     //   WITH PVReceipts DO BEGIN
     
            PVReceipts.TestField(PVReceipts."Paying Bank");
            PVReceipts.TestField(PVReceipts.Description);
            PVReceipts.TestField(PVReceipts."Payment Mode");
            PVReceipts.TestField(PVReceipts."Global Dimension 1 Code");
           PVReceipts.CalcFields(PVReceipts."Net Amount");
            PVReceipts.TestField(PVReceipts."Net Amount");
            if PVReceipts."Line type" = PVReceipts."Line type" then begin
                PVReceipts.TestField(PVReceipts."Payee Name");
            end;
            PVLines.Reset();
            PVLines.SetRange(Code, PVReceipts."Paying Code.");
            IF PVLines.FindSet() THEN BEGIN
                REPEAT
                    PVLines.TestField(Description);
                    PVLines.TestField("Account No.");
                    PVLines.TestField("Account Name");
                    PVLines.TestField(Amount);
                    PVLines.TestField("Net Amount");
                    PVLines.TestField("Global Dimension 1 Code");
                UNTIL PVLines.NEXT = 0;
            END;
       //END;
    end;

    /* procedure ImprestRequiredFields(ImprestManagement: Record "Imprest Management");
     begin
         WITH ImprestManagement DO BEGIN
             TestField(Description);
             // TestField("Paying Bank Account");
             ImprestLines.RESET;
             ImprestLines.SETRANGE(Code, "Imprest No.");
             IF ImprestLines.FINDFIRST THEN BEGIN
                 REPEAT
                     ImprestLines.TESTFIELD("Account No.");
                     ImprestLines.TESTFIELD(Quantity);
                     ImprestLines.TESTFIELD("Unit Price");
                     ImprestLines.TESTFIELD(Description);
                     ImprestLines.TestField("Global Dimension 1 Code");
                 UNTIL ImprestLines.NEXT = 0;
             END;
         END;
     end;

     procedure ImprestSurrenderRequiredFields(ImprestManagement: Record "Imprest Management");
     begin
         WITH ImprestManagement DO BEGIN
             TestField(Description);
             TestField("Imprest To Surrender");
             ImprestLines.RESET;
             ImprestLines.SETRANGE(Code, "Imprest No.");
             IF ImprestLines.FINDFIRST THEN BEGIN
                 REPEAT
                     ImprestLines.TESTFIELD(Description);
                     ImprestLines.TESTFIELD("Actual Spent");
                 UNTIL ImprestLines.NEXT = 0;
             END;
             CALCFIELDS("Actual Spent");
             IF "Actual Spent" < GetPostedImprestBalance("Imprest To Surrender") THEN BEGIN
                 ERROR('Please Pay The Unused Amount First %1', GetPostedImprestBalance("Imprest To Surrender") - "Actual Spent");
             END;
         END;
     end;

     procedure SalaryRequiredFields(ImprestManagement: Record "Imprest Management");
     begin
         WITH ImprestManagement DO BEGIN
             TestField(Description);
             TestField("Requested Amount");
             TestField("No. Of Months");
         END;
     end;

     procedure PopulatePVLines(PV: Record "Payment/Receipt Voucher");
     begin
         WITH PV DO BEGIN
             PVLines.RESET;
             PVLines.SETRANGE(Code, "Paying Code.");
             IF PVLines.FINDFIRST THEN BEGIN
                 ERROR('You Cannot');
             END ELSE BEGIN
                 ;
                 PVLines.INIT;
                 PVLines.Code := "Paying Code.";
                 PVLines."Account Type" := "Account Type";
                 PVLines."Account No." := "Account No.";
                 PVLines."Account Name" := "GetVendor/CustomerName"("Account No.", "Account Type");
                 IF PVLines.INSERT(TRUE) THEN BEGIN
                     MESSAGE('PV Line Successfully Added!');
                 END;
             END;
         END;
     end;*/

    procedure Approver(TableID: Integer; "DocumentNo.": Code[30]; Sequence: Integer): Code[120];
    begin
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Table ID", TableID);
        ApprovalEntry.SETRANGE("Document No.", "DocumentNo.");
        ApprovalEntry.SETRANGE("Sequence No.", Sequence);
        ApprovalEntry.SetFilter(Status, '%1|%2|%3', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            exit(ApprovalEntry."Approver ID");
        END;
    end;

    procedure CountApprovers(TableID: Integer; "DocumentNo.": Code[30]): Integer
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Table ID", TableID);
        ApprovalEntry.SetRange("Document No.", "DocumentNo.");
        ApprovalEntry.SetFilter(Status, '%1|%2|%3', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created, ApprovalEntry.Status::Approved);
        if ApprovalEntry.FindSet() then begin
            exit(ApprovalEntry.Count);
        end;

    end;

    /* procedure ReOpenPaymentReceipt(PV: Record "Payment/Receipt Voucher")
     var
         Loans: Codeunit "Loans Application";
     begin
         if Confirm(StrSubstNo('Are you Sure you want to Re-Open this Document %1(%2) ?', PV."Paying Code.", PV.Description), false) then begin
             if Loans.CanceledApprovalRequest(PV.RecordId) then begin
                 PV.Status := PV.Status::Open;
                 PV.Modify();
                 Message('Documennt Succesffuly Re-Opened!');
             end;
         end;
     end;*/

    procedure ApproverDate(TableID: Integer; "DocumentNo.": Code[30]; Sequence: Integer): DateTime;
    var
        ApprovalEntries: Record "Approval Entry";
    begin
        ApprovalEntries.Reset();
        ApprovalEntries.SetRange("Table ID", TableID);
        ApprovalEntries.SetRange("Document No.", "DocumentNo.");
        ApprovalEntries.SetRange("Sequence No.", Sequence);
        ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Approved);
        //   ApprovalEntry.SetFilter(Status, '%1|%2|%3', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created, ApprovalEntry.Status::Approved);
        if ApprovalEntries.FindFirst() then begin
            exit(ApprovalEntries."Last Date-Time Modified");
        end;
    end;


    procedure SenderApprover(TableID: Integer; "DocumentNo.": Code[30]; Sequence: Integer): Code[120];
    begin
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Table ID", TableID);
        ApprovalEntry.SETRANGE("Document No.", "DocumentNo.");
        ApprovalEntry.SETRANGE("Sequence No.", Sequence);
        ApprovalEntry.SetFilter(Status, '%1|%2|%3', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            exit(ApprovalEntry."Sender ID");
        END;
    end;

    procedure SenderDate(TableID: Integer; "DocumentNo.": Code[30]; Sequence: Integer): DateTime;
    begin
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Table ID", TableID);
        ApprovalEntry.SETRANGE("Document No.", "DocumentNo.");
        ApprovalEntry.SETRANGE("Sequence No.", Sequence);
        ApprovalEntry.SetFilter(Status, '%1|%2|%3', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            exit(ApprovalEntry."Date-Time Sent for Approval");
        END;
    end;

    procedure ValidateAccount(RecPVLines: Record "Payment/Receipt Lines");
    begin
        PVReceipts.RESET;
        PVReceipts.SETRANGE("Paying Code.", RecPVLines.Code);
        IF PVReceipts.FINDFIRST THEN BEGIN
            IF PVReceipts."Account No." <> '' THEN BEGIN
                IF (PVReceipts."Account Type" <> RecPVLines."Account Type") THEN BEGIN
                    ERROR('Account Type Must Be %1', PVReceipts."Account Type");
                END;
                IF (PVReceipts."Account No." <> RecPVLines."Account No.") THEN BEGIN
                    ERROR('Account No. Must Be %1', PVReceipts."Account No.");
                END;
            END;
        END;
    end;

    procedure EditPVReceiptLines(RecPVLines: Record "Payment/Receipt Lines") Edit: Boolean;
    begin
        PVReceipts.RESET;
        IF PVReceipts.GET(RecPVLines.Code) THEN BEGIN
            IF PVReceipts.Status = PVReceipts.Status::Open THEN BEGIN
                Edit := TRUE;
            END;
        END ELSE BEGIN
            Edit := TRUE;
        END;
    end;

    /*  procedure EditImprestLines(ImprestLines: Record "Imprest Lines") Edit: Boolean;
      begin
          ImprestManagement.RESET;
          IF ImprestManagement.GET(ImprestLines.Code) THEN BEGIN
              IF ImprestManagement.Status = ImprestManagement.Status::Open THEN BEGIN
                  Edit := TRUE;
              END;
          END ELSE BEGIN
              Edit := TRUE;
          END;
      end;*/

    procedure LookUpPVLines("AccountNo.": Code[20]) VendAccountNo: Code[20];
    begin
        PVLines.RESET;
        IF PAGE.RUNMODAL(50533, PVLines) = ACTION::LookupOK THEN BEGIN
            //VendAccountNo:=PVReceipts."Paying Code.";
            MESSAGE('ajajja  %1', PVLines."Account No.");
        END;
    end;

    /* procedure GetUsername(MyUserID: Code[90]) Fullname: Text;
     begin
         UserSetup.RESET;
         IF UserSetup.GET(MyUserID) THEN BEGIN
             UserSetup.TESTFIELD("User Name");
             Fullname := UserSetup."User Name"
         END;
     end;

     procedure PostSalaryAdvance(ImprestManagement: Record "Imprest Management")
     var
         LoansApplication: Codeunit "Loans Application";
         PostingDescription: Text[50];
         DesLabel: Label 'Salary Advamce for (%1)';
     begin
         WITH ImprestManagement DO BEGIN
             Clear(PaymentChanell);
             TestField("Requested Amount");
             TestField("Staff A/C");
             TestField(Description);
             IF Posted = true THEN BEGIN
                 Error('The Salary Advance  No.. %1 has already Been Posted!', "Imprest No.");
             END;
             IF Confirm('Are you sure you want to Post Salary Advance  No. ' + "Imprest No." + ' ?') THEN BEGIN
                 CashMngtSetup.RESET;
                 CashMngtSetup.GET;
                 CashMngtSetup.TestField("Petty Cash Template");
                 GenJournalBatch.INIT;
                 GenJournalBatch."Journal Template Name" := CashMngtSetup."Petty Cash Template";
                 GenJournalBatch.Name := "Imprest No.";
                 IF NOT GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                     GenJournalBatch.INSERT;
                 END;
                 GenJlLine.RESET;
                 GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                 GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                 GenJlLine.DELETEALL;
                 LineNo := 1000;
                 Empl.Reset();
                 Empl.Get("Employee No");
                 Empl.TestField("Member No.");
                 PostingDescription := CopyStr(StrSubstNo(DesLabel, Empl.FullName()), 1, 50);
                 MakeJournalEntries(LineNo, "Imprest No.", "Imprest No.", PostingDescription, "Requested Amount", AccountType::Customer, "Staff A/C", "Request Date", AccountType::"G/L Account", '', '', AppliesToDocNoType::" ", '',
                 GenJournalBatch."Journal Template Name", GenJournalBatch.Name, "Global Dimension 1 Code", "Global Dimension 2 Code", Payment_Type);
                 LineNo += 1000;
                 MakeJournalEntries(LineNo, "Imprest No.", "Imprest No.", PostingDescription, -"Requested Amount", AccountType::Vendor, LoansApplication.GetFosaAccount(Empl."Member No."), "Request Date", AccountType::"G/L Account", '', '', AppliesToDocNoType::Payment, '',
                 GenJournalBatch."Journal Template Name", GenJournalBatch.Name, "Global Dimension 1 Code", "Global Dimension 2 Code", Payment_Type);
                 GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                 GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                 Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJlLine);
                 Posted := true;
                 "Posted By" := UserId;
                 "Posted Date Time" := CurrentDateTime;
                 "Paying Document" := "Imprest No.";
                 "Applies-to Doc. No." := "Imprest No.";
                 Modify();
                 Message('Salary Advance Successfully Posted');
             end;
         end;
     end;

     procedure PostingImprest(ImprestManagement: Record "Imprest Management")
     var
         Imprest: Enum "Imprest Type";
         PostDescription: Text[50];
         Labled: Label 'Being Payment of Imprest No. %1';
         AppliestoDocNo: Code[20];
     begin
         WITH ImprestManagement DO BEGIN
             Clear(PaymentChanell);
             IF Posted = TRUE THEN BEGIN
                 ERROR('The Imprest No. %1 has already Been Posted!', "Imprest No.");
             END;
             IF CONFIRM('Are you sure you want to Post Imprest No. ' + "Imprest No." + ' ?') = TRUE THEN BEGIN
                 CashMngtSetup.RESET;
                 CashMngtSetup.GET;
                 GenJournalBatch.INIT;
                 GenJournalBatch."Journal Template Name" := CashMngtSetup."Petty Cash Template";
                 GenJournalBatch.Name := "Imprest No.";
                 IF NOT GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                     GenJournalBatch.INSERT;
                 END;
                 GenJlLine.RESET;
                 GenJlLine.SETRANGE("Journal Template Name", CashMngtSetup."Petty Cash Template");
                 GenJlLine.SETRANGE("Journal Batch Name", "Imprest No.");
                 GenJlLine.DELETEALL;
                 CALCFIELDS("Imprest Amount");
                 ShortcutDimension1Code := "Global Dimension 1 Code";
                 LineNo := 1000;
                 TestField("Paying Bank Account");
                 PostDescription := CopyStr(ImprestManagement.Description, 1, 50);
                 MakeGenJournalEntries(LineNo, CashMngtSetup."Petty Cash Template", "Imprest No.", "Imprest No.", AccountType::"Bank Account", "Paying Bank Account",
                -"Imprest Amount", PostDescription, "Global Dimension 1 Code", Imprest::"Normal Petty Cash", AppliestoDocNo);
                 LineNo += 1000;
                 MakeGenJournalEntries(LineNo, CashMngtSetup."Petty Cash Template", "Imprest No.", "Imprest No.", AccountType::Customer, "Staff A/C",
                 "Imprest Amount", PostDescription, "Global Dimension 1 Code", Imprest::"Normal Petty Cash", AppliestoDocNo);
                 CashMngtSetup.GET;
                 GenJlLine.RESET;
                 GenJlLine.SETRANGE("Journal Template Name", CashMngtSetup."Petty Cash Template");
                 GenJlLine.SETRANGE("Journal Batch Name", "Imprest No.");
                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJlLine);
                 Posted := true;
                 "Posted By" := UserId;
                 "Posted Date Time" := CurrentDateTime;
                 "Paying Document" := "Imprest No.";
                 Modify();
                 GenJournalBatch.Reset();
                 IF GenJournalBatch.GET(CashMngtSetup."Petty Cash Template", "Imprest No.") THEN BEGIN
                     GenJournalBatch.Delete();
                 END;
                 Message('Imprest Successfully Posted');
             END;
         END;
     end;

     procedure PostingImprestSurrender(ImprestManagement: Record "Imprest Management");
     var
         Imprest: Record "Imprest Management";
         PostDescription: Text[50];
         Labled: Label 'Imprest Surrender for Imprest No.%1';
         ImprestType: Enum "Imprest Type";
         m: Integer;
         AppliestoDocNo: Code[20];
     begin
         WITH ImprestManagement DO BEGIN
             IF Posted = TRUE THEN BEGIN
                 ERROR('The Imprest Surrender No. %1 has already Been Posted!', "Imprest No.");
             END;
             Clear(PaymentChanell);
             IF CONFIRM('Are you sure you want to Post Imprest Surrender No. ' + "Imprest No." + ' ?') = TRUE THEN BEGIN
                 CashMngtSetup.RESET;
                 CashMngtSetup.GET;
                 GenJournalBatch.INIT;
                 GenJournalBatch."Journal Template Name" := CashMngtSetup."Imprest Surrender Template";
                 GenJournalBatch.Name := "Imprest No.";
                 IF NOT GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                     GenJournalBatch.INSERT;
                 END;
                 GenJlLine.RESET;
                 GenJlLine.SETRANGE("Journal Template Name", CashMngtSetup."Imprest Surrender Template");
                 GenJlLine.SETRANGE("Journal Batch Name", "Imprest No.");
                 GenJlLine.DELETEALL;
                 CALCFIELDS("Imprest Amount");
                 CALCFIELDS("Actual Spent");
                 ShortcutDimension1Code := "Global Dimension 1 Code";
                 LineNo := 1000;
                 PostDescription := CopyStr(StrSubstNo(Labled, "Imprest To Surrender"), 1, 50);
                 MakeGenJournalEntries(LineNo, CashMngtSetup."Imprest Surrender Template", "Imprest No.", "Imprest No.", AccountType::Customer, "Staff A/C",
                -"Actual Spent", PostDescription, "Global Dimension 1 Code", ImprestType::"Imprest Surrender", AppliestoDocNo);
                 ImprestLines.Reset();
                 ImprestLines.SETRANGE(Code, "Imprest No.");
                 IF ImprestLines.FindSet() THEN BEGIN
                     REPEAT
                         LineNo += 1000;
                         MakeGenJournalEntries(LineNo, CashMngtSetup."Imprest Surrender Template", "Imprest No.", "Imprest No.", ImprestLines."Account Type", ImprestLines."Account No.",
                          ImprestLines."Actual Spent", PostDescription, "Global Dimension 1 Code", ImprestType::"Normal Petty Cash", AppliestoDocNo);
                     UNTIL ImprestLines.NEXT = 0;
                 END;
                 CashMngtSetup.GET;
                 GenJlLine.RESET;
                 GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                 GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                 m := GenJlLine.Count;
                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJlLine);
                 if m <> GenJlLine.Count then begin
                     IF "Actual Spent" >= GetPostedImprestBalance("Imprest No.") THEN BEGIN
                         IF ImprestManagementCopy.GET("Imprest To Surrender") THEN BEGIN
                             ImprestManagementCopy.Surrendered := TRUE;
                             ImprestManagementCopy.MODIFY;
                             BudgetManagement.ReverseImprest(ImprestManagementCopy);
                         END;
                     END;
                     Posted := true;
                     "Posted By" := UserId;
                     "Posted Date Time" := CurrentDateTime;
                     MODIFY;
                     GenJournalBatch.Reset();
                     IF GenJournalBatch.GET(CashMngtSetup."Imprest Surrender Template", "Imprest No.") THEN BEGIN
                         GenJournalBatch.Delete();
                     END;
                     Message('Imprest Surrender Successfully Posted!');
                 end;
             END;
         END;
     end;

     procedure PostingImprestClaim(ImprestManagement: Record "Imprest Management");
     begin
         WITH ImprestManagement DO BEGIN
             IF Posted = TRUE THEN BEGIN
                 ERROR('The Claim No. %1 has already Been Posted!', "Imprest No.");
             END;
             Clear(PaymentChanell);
             IF CONFIRM('Are you sure you want to Post Imprest No. ' + "Imprest No." + ' ?') = TRUE THEN BEGIN
                 CashMngtSetup.RESET;
                 CashMngtSetup.GET;
                 GenJournalBatch.INIT;
                 GenJournalBatch."Journal Template Name" := CashMngtSetup."Imprest Surrender Template";
                 GenJournalBatch.Name := "Imprest No.";
                 IF NOT GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                     GenJournalBatch.INSERT;
                 END;
                 GenJlLine.RESET;
                 GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                 GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                 GenJlLine.DELETEALL;
                 CALCFIELDS("Imprest Amount");
                 ShortcutDimension1Code := "Global Dimension 1 Code";
                 LineNo := 1000;
                 MakeJournalEntries(LineNo, "Imprest No.", "Imprest No.", Description, -"Imprest Amount", AccountType::"Bank Account", "Paying Bank Account", "Request Date", AccountType::"G/L Account", '', '', AppliesToDocNoType::Invoice, '',
                 CashMngtSetup."Imprest Surrender Template", CashMngtSetup."Petty Cash Template", "Global Dimension 1 Code", "Global Dimension 2 Code", Payment_Type);
                 IF "Claim Type" = "Claim Type"::"From Imprest" THEN BEGIN
                     MakeJournalEntries(LineNo + 100, "Imprest No.", "Imprest No.", Description, "Imprest Amount", AccountType::Vendor, "Staff A/C", "Request Date", AccountType::"G/L Account", '', "Imprest Surrender No.", AppliesToDocNoType::Invoice, '',
                    GenJournalBatch."Journal Template Name", GenJournalBatch.Name, "Global Dimension 1 Code", "Global Dimension 2 Code", Payment_Type);
                 END;
                 IF "Claim Type" = "Claim Type"::"Normal Claim" THEN BEGIN
                     ImprestLines.RESET;
                     ImprestLines.SETRANGE(Code, "Imprest No.");
                     IF ImprestLines.FINDFIRST THEN BEGIN
                         REPEAT
                             LineNo += 100;
                             MakeJournalEntries(LineNo, "Imprest No.", "Imprest No.", ImprestLines.Description, ImprestLines.Amount, ImprestLines."Account Type", ImprestLines."Account No.", "Request Date", AccountType::"G/L Account", '', '', AppliesToDocNoType::Payment, '',
                            GenJournalBatch."Journal Template Name", GenJournalBatch.Name, ImprestLinesCopy."Global Dimension 1 Code", ImprestLines."Global Dimension 2 Code", Payment_Type);
                         UNTIL ImprestLines.NEXT = 0;
                     END;
                 END;
                 CashMngtSetup.GET;
                 GenJlLine.RESET;
                 GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                 GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJlLine);
                 Posted := TRUE;
                 "Posted By" := USERID;
                 "Posted Date Time" := CURRENTDATETIME;
                 MODIFY;
             END;
         END;
     end;

     procedure PostingPettyCash(ImprestManagement: Record "Imprest Management")
     var
         Imprest: Enum "Imprest Type";
         ImprestMagt: Record "Imprest Management";
         OK: Boolean;
         m: Integer;
         AppliestoDocNo: Code[20];

     begin
         WITH ImprestManagement DO BEGIN
             OK := false;
             IF Posted = TRUE THEN BEGIN
                 ERROR('The Petty Cash No. %1 has already Been Posted!', "Imprest No.");
             END;
             Clear(PaymentChanell);
             IF CONFIRM('Are you sure you want to Post Petty Cash No. ' + "Imprest No." + ' ?') = TRUE THEN BEGIN
                 CashMngtSetup.Reset();
                 CashMngtSetup.Get();
                 GenJournalBatch.Init();
                 GenJournalBatch."Journal Template Name" := CashMngtSetup."Petty Cash Template";
                 GenJournalBatch.Name := "Imprest No.";
                 IF NOT GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                     GenJournalBatch.Insert();
                 END;
                 GenJlLine.RESET;
                 GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                 GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                 GenJlLine.DELETEALL;
                 CALCFIELDS("Imprest Amount");
                 ShortcutDimension1Code := "Global Dimension 1 Code";
                 LineNo := 1000;
                 CalcFields("Imprest Amount");
                 Clear(AppliestoDocNo);
                 MakeGenJournalEntries(LineNo, CashMngtSetup."Petty Cash Template", "Imprest No.", "Imprest No.", AccountType::"Bank Account", "Paying Bank Account",
                 -"Imprest Amount", Description, "Global Dimension 1 Code", Imprest::"Normal Petty Cash", AppliestoDocNo);
                 ImprestLines.RESET;
                 ImprestLines.SETRANGE(Code, "Imprest No.");
                 IF ImprestLines.FindSet() THEN BEGIN
                     REPEAT
                         LineNo += 10000;
                         Clear(AppliestoDocNo);
                         AppliestoDocNo := GetAppliestoDocNo(ImprestLines."Link To Doc No.");
                         MakeGenJournalEntries(LineNo, CashMngtSetup."Petty Cash Template", "Imprest No.", "Imprest No.", ImprestLines."Account Type", ImprestLines."Account No.",
                         ImprestLines.Amount, ImprestLines.Description, ImprestLines."Global Dimension 1 Code", Imprest::"Normal Petty Cash", AppliestoDocNo);
                         ImprestMgt.Reset();
                         IF ImprestMgt.GET(ImprestLines."Link To Doc No.") THEN BEGIN
                             ImprestMgt.Posted := true;
                             ImprestMgt."Posted By" := UserId;
                             ImprestMgt."Posted Date Time" := CurrentDateTime;
                             ImprestMgt."Paying Document" := "Imprest No.";
                             ImprestMgt.Modify();
                         END;
                     UNTIL ImprestLines.NEXT = 0;
                 END;
                 GenJlLine.Reset();
                 GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                 GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                 m := GenJlLine.Count;
                 Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJlLine);
                 if m <> GenJlLine.Count then begin
                     Posted := true;
                     "Posted By" := UserId;
                     "Posted Date Time" := CurrentDateTime;
                     Modify();
                     GenJournalBatch.Reset();
                     IF GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                         GenJournalBatch.Delete();
                     END;
                     Message('Petty Cash Posted Successfully!');
                 end else begin
                     Error('');
                 end;
             END;
         END;
     end;

     local procedure GetAppliestoDocNo(DocNo: Code[20]): Code[20]
     var
         ImprestMagt: Record "Imprest Management";
         ImprestMagt2: Record "Imprest Management";
     begin
         ImprestMagt.Reset();
         if ImprestMagt.Get(DocNo) then begin
             if ImprestMagt."Claim Type" = ImprestMagt."Claim Type"::"From Imprest" then begin
                 ImprestMagt2.Reset();
                 if ImprestMagt2.Get(ImprestMagt."Imprest Surrender No.") then begin
                     ImprestMagt2.CalcFields("Applies-to Doc. No.");
                     exit(ImprestMagt2."Applies-to Doc. No.");
                 end;
             end else begin
                 ImprestMagt.CalcFields("Applies-to Doc. No.");
                 exit(ImprestMagt."Applies-to Doc. No.");
             end;
         end;
     end;
 */
    procedure PostJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20]): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        Commit();
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJournalLine.FindSet() then begin
            if GenJnlPostBatch.Run(GenJournalLine) then
                exit(true)
            else
                exit(false);
        end;



    end;

    /* procedure PopulateImprestDetails(ImprestManagement: Record "Imprest Management");
     begin
         WITH ImprestManagement DO BEGIN
             Empl.RESET;
             Empl.SETRANGE("No.", ImprestManagement."Employee No");
             IF Empl.FINDFIRST THEN BEGIN
                 ImprestManagement."Employee Name" := Empl."First Name" + ' ' + Empl."Middle Name" + ' ' + Empl."Last Name";
                 ;
                 ImprestManagement."Global Dimension 1 Code" := Empl."Global Dimension 1 Code";
                 IF Empl."Global Dimension 1 Code" <> '' THEN BEGIN
                     DimensionValue.RESET;
                     DimensionValue.SETRANGE(Code, Empl."Global Dimension 1 Code");
                     IF DimensionValue.FINDFIRST THEN BEGIN
                         //ImprestManagement.
                     END;
                 END;
                 //ImprestManagement.MODIFY;
             END;
         END;
     end;*/

    procedure GetEmployeeName(EmployeeNo: Code[20]): Text;
    begin
        EmpName := '';
        Empl.RESET;
        Empl.SETRANGE("No.", EmployeeNo);
        IF Empl.FINDFIRST THEN BEGIN
            EmpName := Empl."First Name" + ' ' + Empl."Middle Name" + ' ' + Empl."Last Name";
            EXIT(EmpName);
        END ELSE BEGIN
            EXIT(EmpName);
        END;
    end;

    procedure GetBranchCode(EmployeeNo: Code[20]): Code[10];
    begin
        UserSetup.GET(USERID);
        Empl.RESET;
        Empl.SETRANGE("No.", EmployeeNo);
        IF Empl.FINDFIRST THEN BEGIN
            Empl.TestField("Global Dimension 1 Code");
            EXIT(Empl."Global Dimension 1 Code");
        end;
    end;

    procedure GetDepartmentCode(EmployeeNo: Code[20]): Code[10];
    begin
        UserSetup.GET(USERID);
        Empl.RESET;
        Empl.SETRANGE("No.", EmployeeNo);
        IF Empl.FINDFIRST THEN BEGIN
            Empl.TestField("Global Dimension 2 Code");
            EXIT(Empl."Global Dimension 2 Code");
        END;
    end;

    procedure GetDimensionName(GlobalDimensionCode: Code[90]; GlobalDimensionNo: Integer): Code[100];
    var
        DimnValue: Record "Dimension Value";
    begin
        IF GlobalDimensionCode <> '' THEN BEGIN
            DimensionValue.RESET;
            DimensionValue.SETRANGE("Global Dimension No.", GlobalDimensionNo);
            DimensionValue.SETRANGE(Code, GlobalDimensionCode);
            IF DimensionValue.FINDFIRST THEN BEGIN
                EXIT(DimensionValue.Name);
            END;
        END;
    end;

    procedure GetBankName(BankCode: Code[20]): Text;
    begin
        BankAccount.RESET;
        BankAccount.SETRANGE("No.", BankCode);
        IF BankAccount.FINDFIRST THEN BEGIN
            EXIT(BankAccount.Name);
        END;
    end;

    /*  procedure CreateCustomer(Employee: Record Employee; "Account Type": Option Imprest,"Salary Advance");
      var
          AccountSelect: Code[20];
          Cust: Record Customer;
      begin
          CustAccount := '';
          WITH Employee DO BEGIN
              CashMngtSetup.GET;
              IF "Account Type" = "Account Type"::Imprest THEN BEGIN
                  CashMngtSetup.TESTFIELD("Imprest Code");
                  AccountSelect := CashMngtSetup."Imprest Code";
              END;
              IF "Account Type" = "Account Type"::"Salary Advance" THEN BEGIN
                  CashMngtSetup.TESTFIELD("Salary Advance Code");
                  AccountSelect := CashMngtSetup."Salary Advance Code";
              END;
              AccountMappingType.GET(AccountSelect);
              AccountMappingType.TESTFIELD(Prefix);
              AccountMappingType.TESTFIELD("Staff Posting Group");
              CustAccount := AccountMappingType.Prefix + '' + Employee."No.";
              IF AccountMapping.GET(AccountSelect, Employee."No.") THEN BEGIN
                  MESSAGE('Employee No. %1:-%2, Already has %4 Acccount :-%3', Employee."No.", Employee."First Name", AccountMapping."Staff A/C", "Account Type");
                  Cust.Get(AccountMapping."Staff A/C");
                  Page.Run(21, Cust);
              END ELSE BEGIN
                  Cust."No." := CustAccount;
                  Cust.Name := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                  Cust."Customer Type" := Cust."Customer Type"::"Staff Accounts";
                  Cust."Customer Posting Group" := AccountMappingType."Staff Posting Group";
                  Cust."VAT Bus. Posting Group" := AccountMappingType."VAT Bus. Posting Group";
                  Cust."Gen. Bus. Posting Group" := AccountMappingType."Gen. Bus. Posting Group";
                  Cust.Address := Employee.Address;
                  Cust."Address 2" := Employee."Address 2";
                  Cust."Post Code" := Employee."Post Code";
                  Cust.City := Employee.City;
                  Cust."Country/Region Code" := Employee."Country/Region Code";
                  Cust.Image := Employee.Image;
                  Cust."Customer Type" := Cust."Customer Type"::"Staff Accounts";
                  Cust.Insert();
                  AccountMapping.Init();
                  AccountMapping."Account Type" := AccountMappingType.Code;
                  AccountMapping."Employee No." := Employee."No.";
                  AccountMapping."Staff A/C" := Vendor."No.";
                  AccountMapping.Insert();
                  Page.Run(21, Cust);
              END;
          END;
      end;

      procedure GetCustomerAccount(ImprestManagement: Record "Imprest Management"): Code[120];
      begin
          WITH ImprestManagement DO BEGIN
              IF ("Transaction Type" = "Transaction Type"::Imprest) OR ("Transaction Type" = "Transaction Type"::"Imprest Surrender") THEN BEGIN
                  CashMngtSetup.GET;
                  CashMngtSetup.TESTFIELD("Imprest Code");
                  AccountMappingType.GET(CashMngtSetup."Imprest Code");
                  IF AccountMapping.GET(AccountMappingType.Code, "Employee No") THEN BEGIN
                      EXIT(AccountMapping."Staff A/C");
                  END;
              END ELSE
                  IF "Transaction Type" = "Transaction Type"::"Salary Advance" THEN BEGIN
                      CashMngtSetup.GET;
                      CashMngtSetup.TESTFIELD("Salary Advance Code");
                      AccountMappingType.GET(CashMngtSetup."Salary Advance Code");
                      IF AccountMapping.GET(AccountMappingType.Code, "Employee No") THEN BEGIN
                          EXIT(AccountMapping."Staff A/C");
                      END;
                  END;
          END;
      end;*/

    procedure GetCustomerName(CustomerAccount: Code[20]): Text;
    begin
        if Customer.Get(CustomerAccount) then begin
            exit(Customer.Name);
        end;
    end;

    /* procedure GetPostedImprestBalance("ImprestNo.": Code[20]): Decimal;
     begin
         ImprestManagement.Reset();
         if ImprestManagement.Get("ImprestNo.") then begin
             IF ImprestManagement."Paying Document" <> '' THEN BEGIN
                 "ImprestNo." := ImprestManagement."Paying Document";
             END;
             CustLedgerEntry.Reset();
             CustLedgerEntry.SetRange("Customer No.", ImprestManagement."Staff A/C");
             CustLedgerEntry.SetRange("Document No.", "ImprestNo.");
             IF CustLedgerEntry.FindSet() THEN BEGIN
                 CustLedgerEntry.CalcFields("Remaining Amount");
                 exit(Abs(CustLedgerEntry."Remaining Amount"));
             END;
         end;
     end;*/

    procedure GetVendDocumentBalance("DocumentNo.": Code[20]; Vend_CustNo: Code[20]): Decimal;
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETRANGE("Vendor No.", Vend_CustNo);
        VendLedgEntry.SETRANGE("Document No.", "DocumentNo.");
        IF VendLedgEntry.FINDSET THEN BEGIN
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            EXIT(ABS(VendLedgEntry."Remaining Amount"));
        END;
    end;

    procedure GetCustDocumentBalance("DocumentNo.": Code[20]; Vend_CustNo: Code[20]): Decimal;
    begin
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", Vend_CustNo);
        CustLedgerEntry.SETRANGE("Document No.", "DocumentNo.");
        IF CustLedgerEntry.FINDSET THEN BEGIN
            CustLedgerEntry.CALCFIELDS("Remaining Amount");
            EXIT(ABS(CustLedgerEntry."Remaining Amount"));
        END;
    end;

    procedure GetCustomerBalance(CustNo: Code[20]): Decimal;
    begin
        Customer.RESET;
        IF Customer.GET(CustNo) THEN BEGIN
            Customer.CALCFIELDS("Balance (LCY)");
            EXIT(Customer."Balance (LCY)");
        END;
    end;

    /*  procedure "GetEmployeeNo."(UserID: Code[90]): Code[20];
      begin
          UserSetup.RESET;
          IF UserSetup.GET(UserID) THEN BEGIN
              UserSetup.TESTFIELD("Employee No.");
              EXIT(UserSetup."Employee No.");
          END;
      end;

      procedure CreateSurrenderLines(ImprestManagement: Record "Imprest Management");
      begin

          WITH ImprestManagement DO BEGIN
              ImprestLines.Reset();
              ImprestLines.SETRANGE(Code, "Imprest No.");
              if ImprestLines.FindSet() then begin
                  ImprestLines.DeleteAll();
              end;
              ImprestLines.Reset();
              ImprestLines.SETRANGE(Code, "Imprest To Surrender");
              IF ImprestLines.FindSet() THEN BEGIN
                  REPEAT
                      ImprestLinesCopy.TransferFields(ImprestLines);
                      ImprestLinesCopy.Code := "Imprest No.";
                      ImprestLinesCopy."Global Dimension 1 Code" := "Global Dimension 1 Code";
                      ImprestLinesCopy."Global Dimension 2 Code" := "Global Dimension 2 Code";
                      ImprestLinesCopy.Insert();
                  UNTIL ImprestLines.NEXT = 0;
              END;
          END;
      end;

      procedure CreateImprestClaim(ImprestMgnt: Record "Imprest Management");
      begin
          WITH ImprestMgnt DO BEGIN
              IF Posted = FALSE THEN BEGIN
                  ERROR('You Cannot Create A claim For Imprest Surrender That Has not been Posted!');
              END;
              CashMngtSetup.GET;
              CashMngtSetup.TESTFIELD("Imprest Code");
              RefundAmount := 0;
              IF CONFIRM('Are you sure you want to Create A Claim from Imrest Surrender No.. ' + "Imprest No." + ' ?') = TRUE THEN BEGIN
                  IF "Imprest To Surrender" <> '' THEN BEGIN
                      RefundAmount := GetPostedImprestBalance("Imprest No.");
                      IF (RefundAmount <> 0) AND (RefundAmount > 0) THEN BEGIN
                          ImprestManagementCopy.COPY(ImprestMgnt);
                          ImprestManagementCopy."Imprest No." := NoSeriesMgt.GetNextNo(CashMngtSetup."Claim No.", TODAY, TRUE);
                          ImprestManagementCopy."Transaction Type" := ImprestManagementCopy."Transaction Type"::"Imprest Claim/Refund";
                          ImprestManagementCopy."Request Date" := TODAY;
                          ImprestManagementCopy."Requested By" := USERID;
                          ImprestManagementCopy."Claim Type" := ImprestManagementCopy."Claim Type"::"From Imprest";
                          ImprestManagementCopy."Imprest Surrender No." := "Imprest No.";
                          ImprestManagementCopy.Status := ImprestManagementCopy.Status::Released;
                          ImprestManagementCopy.Posted := FALSE;
                          ImprestManagementCopy."Posted By" := '';
                          ImprestManagementCopy."Posted Date Time" := 0DT;
                          ImprestMgnt.RESET;
                          ImprestMgnt.SETRANGE("Imprest Surrender No.", "Imprest No.");
                          IF ImprestMgnt.FINDFIRST THEN BEGIN
                              MESSAGE('Imprest Claim No. %1 Has Already been Created for this document %2', ImprestMgnt."Imprest No.", "Imprest No.");
                              PAGE.RUN(50622, ImprestMgnt);
                          END ELSE BEGIN
                              ImprestManagementCopy.INSERT;
                              ImprestLines.RESET;
                              ImprestLines.SETRANGE(Code, "Imprest No.");
                              IF ImprestLines.FINDLAST THEN BEGIN
                                  ImprestLinesCopy.COPY(ImprestLines);
                                  ImprestLinesCopy.Code := ImprestManagementCopy."Imprest No.";
                                  ImprestLinesCopy.Quantity := 1;
                                  ImprestLinesCopy."Unit Price" := RefundAmount;
                                  ImprestLinesCopy.Amount := RefundAmount;
                                  ImprestLinesCopy.INSERT;
                              END;
                              MESSAGE('The Imprest Claim Sussfully Created..%1', ImprestManagementCopy."Imprest No.");
                              PAGE.RUN(50622, ImprestManagementCopy);
                          END;
                          ;
                      END;
                  END;
              END;
          END;
      end;

      procedure SuggestImprest(var ImprestLines: Record "Imprest Lines");
      begin
          IF PAGE.RUNMODAL(Page::"Approved Imprest List", ImprestManagement) = ACTION::LookupOK THEN BEGIN
              LineNo := 1000;
              ImprestLinesCopy.RESET;
              ImprestLinesCopy.SETRANGE(Code, ImprestLines.Code);
              IF ImprestLinesCopy.FINDLAST THEN BEGIN
                  LineNo := ImprestLinesCopy."Line No" + 100;
              END;
              ImprestManagement.CALCFIELDS("Imprest Amount");
              ImprestLinesCopy."Line No" := LineNo;
              ImprestLinesCopy.Code := ImprestLines.Code;
              ImprestLinesCopy."Account Type" := ImprestLinesCopy."Account Type"::Customer;
              ImprestLinesCopy."Account No." := ImprestManagement."Staff A/C";
              ImprestLinesCopy."Account Name" := ImprestManagement."Staff Name";
              ImprestLinesCopy."Unit Price" := ImprestManagement."Imprest Amount";
              ImprestLinesCopy."Link To Doc No." := ImprestManagement."Imprest No.";
              ImprestLinesCopy."Global Dimension 1 Code" := ImprestManagement."Global Dimension 1 Code";
              ImprestLinesCopy."Global Dimension 2 Code" := ImprestManagement."Global Dimension 2 Code";
              ImprestLinesCopy.Quantity := 1;
              ImprestLinesCopy.Amount := ImprestLinesCopy."Unit Price";
              IF ImprestLinesCopy.Amount <> 0 THEN BEGIN
                  ImprestLinesCopy.INSERT;
                  LineNo += 100;
              END;
          END;
      end;

      procedure SuggestImprestClaim(var ImprestLines: Record "Imprest Lines");
      begin
          IF PAGE.RUNMODAL(Page::"ApproImprest Claim/Refund List", ImprestManagement) = ACTION::LookupOK THEN BEGIN
              LineNo := 1000;
              ImprestLinesCopy.RESET;
              ImprestLinesCopy.SETRANGE(Code, ImprestLines.Code);
              IF ImprestLinesCopy.FINDLAST THEN BEGIN
                  LineNo := ImprestLinesCopy."Line No" + 100;
              END;
              ImprestManagement.CALCFIELDS("Imprest Amount");
              ImprestLinesCopy."Line No" := LineNo;
              ImprestLinesCopy.Code := ImprestLines.Code;
              ImprestLinesCopy."Account Type" := ImprestLinesCopy."Account Type"::Customer;
              ImprestLinesCopy."Account No." := ImprestManagement."Staff A/C";
              ImprestLinesCopy."Account Name" := ImprestManagement."Staff Name";
              ImprestLinesCopy."Unit Price" := ImprestManagement."Imprest Amount";
              ImprestLinesCopy."Link To Doc No." := ImprestManagement."Imprest No.";
              ImprestLinesCopy.Quantity := 1;
              ImprestLinesCopy."Applies to Doc. No" := ImprestManagement."Imprest Surrender No.";
              ImprestLinesCopy.Amount := ImprestLinesCopy."Unit Price";
              ImprestLinesCopy."Global Dimension 1 Code" := ImprestManagement."Global Dimension 1 Code";
              ImprestLinesCopy."Global Dimension 2 Code" := ImprestManagement."Global Dimension 2 Code";
              IF ImprestLinesCopy.Amount <> 0 THEN BEGIN
                  ImprestLinesCopy.INSERT;
                  LineNo += 100;
              END;
          END;
      end;

      local procedure AlterCustLedgerEntry(CustNo: Code[20])
      var
          Ledger: Record "Cust. Ledger Entry";
      begin

      end;

      procedure SuggestSalaryAdvance(var ImprestLines: Record "Imprest Lines");
      begin
          IF PAGE.RUNMODAL(50637, ImprestManagement) = ACTION::LookupOK THEN BEGIN
              LineNo := 1000;
              ImprestLinesCopy.RESET;
              ImprestLinesCopy.SETRANGE(Code, ImprestLines.Code);
              IF ImprestLinesCopy.FINDLAST THEN BEGIN
                  LineNo := ImprestLinesCopy."Line No" + 100;
              END;
              ImprestManagement.CALCFIELDS("Imprest Amount");
              ImprestLinesCopy."Line No" := LineNo;
              ImprestLinesCopy.Code := ImprestLines.Code;
              ImprestLinesCopy."Account Type" := ImprestLinesCopy."Account Type"::Vendor;
              ImprestLinesCopy."Account No." := ImprestManagement."Staff A/C";
              ImprestLinesCopy."Account Name" := ImprestManagement."Staff Name";
              ImprestLinesCopy."Unit Price" := ImprestManagement."Amount Approved";
              ImprestLinesCopy."Link To Doc No." := ImprestManagement."Imprest No.";
              ImprestLinesCopy."Global Dimension 1 Code" := ImprestManagement."Global Dimension 1 Code";
              ImprestLinesCopy."Global Dimension 2 Code" := ImprestManagement."Global Dimension 2 Code";
              ImprestLinesCopy.Quantity := 1;
              ImprestLinesCopy.Amount := ImprestLinesCopy."Unit Price";
              IF ImprestLinesCopy.Amount <> 0 THEN BEGIN
                  ImprestLinesCopy.INSERT;
                  LineNo += 100;
              END;
          END;
          //50567
      end;

      procedure SuggestSalaryAdvancePV(PVlines: Record "Payment/Receipt Lines"; TranType: Enum "Transaction Type");
      var
          PV: Record "Payment/Receipt Voucher";
      begin
          PV.Reset();
          PV.Get(PVlines.Code);
          ImprestManagement.Reset();
          ImprestManagement.SetRange("Transaction Type", TranType);
          ImprestManagement.SetRange(Status, ImprestManagement.Status::Released);
          ImprestManagement.SetRange(Posted, false);
          if ImprestManagement.FindSet() then begin
              if Page.RunModal(Page::"Documents To Pay", ImprestManagement) = Action::LookupOK then begin
                  InsertPVlines(PV, ImprestManagement);
              end;
          end else begin
              Error('There is no %1 Pending Payment at the moment', TranType);
          end;
      end;

      local procedure InsertPVlines(PV: Record "Payment/Receipt Voucher"; Imprest: Record "Imprest Management")
      var
          PVlines: Record "Payment/Receipt Lines";
      begin
          Imprest.TestField("Staff A/C");
          Imprest.TestField("Staff Name");
          Imprest.TestField(Status, Imprest.Status::Released);
          Imprest.CalcFields("Imprest Amount");
          PVlines.Init();
          PVlines.Code := PV."Paying Code.";
          PVlines."Account Type" := PVlines."Account Type"::Customer;
          PVlines.Validate("Account No.", Imprest."Staff A/C");
          PVlines."Account Name" := Imprest."Staff Name";
          PVlines.Description := Imprest.Description;
          PVlines."Imprest No" := Imprest."Imprest No.";
          PVlines."Is Imprest" := true;
          if Imprest."Transaction Type" in [Imprest."Transaction Type"::"Salary Advance"] then begin
              Imprest.TestField("Requested Amount");
              PVlines.Amount := Abs(Imprest."Requested Amount");
          end else begin
              PVlines.Amount := Abs(Imprest."Imprest Amount");
          end;
          if PVlines.Amount <> 0 then begin
              PVlines.Insert();
          end;
      end;*/

    procedure InitTextVariable();
    begin
        OnesText[1] := Text002;
        OnesText[2] := Text003;
        OnesText[3] := Text004;
        OnesText[4] := Text005;
        OnesText[5] := Text006;
        OnesText[6] := Text007;
        OnesText[7] := Text008;
        OnesText[8] := Text009;
        OnesText[9] := Text010;
        OnesText[10] := Text011;
        OnesText[11] := Text012;
        OnesText[12] := Text013;
        OnesText[13] := Text014;
        OnesText[14] := Text015;
        OnesText[15] := Text016;
        OnesText[16] := Text017;
        OnesText[17] := Text018;
        OnesText[18] := Text019;
        OnesText[19] := Text020;

        TensText[1] := '';
        TensText[2] := Text021;
        TensText[3] := Text022;
        TensText[4] := Text023;
        TensText[5] := Text024;
        TensText[6] := Text025;
        TensText[7] := Text026;
        TensText[8] := Text027;
        TensText[9] := Text028;

        ExponentText[1] := '';
        ExponentText[2] := Text030;
        ExponentText[3] := Text031;
        ExponentText[4] := Text032;
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[180]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[130]);
    begin
        PrintExponent := TRUE;
        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text034, AddText);
        END;
        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure FormatAmountToText(var NoText: array[2] of Text[1000]; Amount: Decimal; CurrencyCode: Code[10]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        InitTextVariable;
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF Amount < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text001)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := Amount DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text029);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                Amount := Amount - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;
        AddToNoText(NoText, NoTextIndex, PrintExponent, Text033);
        FormatDecimalToText(DescriptionLine, (Amount * 100), '');
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(DescriptionLine[1]) + ' CENTS ONLY');
        IF CurrencyCode <> '' THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, '');
        END;
    end;

    procedure FormatDecimalToText(var NoText: array[2] of Text[200]; Amount: Decimal; CurrencyCode: Code[10]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        InitTextVariable;
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF Amount < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text001)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := Amount DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text029);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                Amount := Amount - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;
        AddToNoText(NoText, NoTextIndex, PrintExponent, '');
    end;

    /*local procedure MarkImprestAsSurrendered(ImprestNo: Code[20]; AmountPaid: Decimal; CudtomerID: Code[20]);
    begin
        ImprestMgt.RESET;
        ImprestMgt.SETRANGE("Paying Document", ImprestNo);
        IF ImprestMgt.FINDFIRST THEN BEGIN
            ImprestMgt.CALCFIELDS("Imprest Amount");
            IF ImprestMgt."Imprest Amount" = AmountPaid THEN BEGIN
                ImprestMgt.Posted := TRUE;
                ImprestMgt."Posted Date Time" := CURRENTDATETIME;
                ImprestMgt."Posted By" := USERID;
                ImprestMgt.Surrendered := TRUE;
                ImprestMgt.MODIFY;
                BudgetManagement.ReverseImprest(ImprestMgt);
            END;
        END;
    end;

    local procedure MarkImprestAsPosted(ImprestNo: Code[20]; PayingCode: Code[20])
    var
        Imp: Record "Imprest Management";
    begin
        Imp.Reset();
        if Imp.Get(ImprestNo) then begin
            Imp.Posted := true;
            Imp."Posted By" := GetUser.GetUser();
            Imp."Posted Date Time" := CurrentDateTime;
            Imp."Paying Document" := PayingCode;
            Imp.Modify();
        end;
    end;

    local procedure ConfirmAppliesBalance();
    begin
    end;

    procedure ClearSalaryAdvance(CustomerNo: Code[20]; DocumentNo: Code[20]; Amount: Decimal);
    begin
        IF (Amount = GetCustDocumentBalance(DocumentNo, CustomerNo)) OR (GetCustDocumentBalance(DocumentNo, CustomerNo) = 0) THEN BEGIN
            ImprestMgt.RESET;
            ImprestMgt.SETRANGE("Paying Document", DocumentNo);
            IF ImprestMgt.FINDFIRST THEN BEGIN
                IF ImprestMgt."Transaction Type" = ImprestMgt."Transaction Type"::"Salary Advance" THEN BEGIN
                    ImprestMgt.Cleared := TRUE;
                    ImprestMgt.MODIFY;
                END;
            END;
        END;
    end;

    procedure GetStaffNumber(TranType: Enum "Transaction Type"): Code[20]
    var


        Allowed: Boolean;
        Options: Text[250];
        Text000: Label 'Raising My Own %1,Raising %1 On Behalf of Another staff';
        Text002: Label 'Choose one of the following %1  options:';
        Selected: Integer;
        Setup: Record "Cash Management Setup";
        Mapping: Record "Account Mapping";
        MappingPage: Page "Account Mapping";
        AccType: Code[20];
    begin
        Allowed := GetUser.CheckSpecialRights(Enum::"Special Control Access"::"Imprest Admin");
        if (Allowed) and (TranType in [TranType::Imprest, TranType::"Imprest Surrender", TranType::"Imprest Claim/Refund"]) then begin
            Options := StrSubstNo(Text000, TranType);
            Selected := Dialog.StrMenu(Options, 1, StrSubstNo(Text002, TranType));
            if Selected = 1 then begin
                exit(Personal());
            end else begin
                Setup.Reset();
                Setup.Get();
                if TranType in [TranType::Imprest, TranType::"Imprest Surrender"] then begin
                    Setup.TestField("Imprest Code");
                    AccType := Setup."Imprest Code";
                end else
                    if TranType in [TranType::"Salary Advance"] then begin
                        Setup.TestField("Salary Advance Code");
                        AccType := Setup."Salary Advance Code";
                    end;
                Mapping.Reset();
                Mapping.CalcFields(Status);
                Mapping.SetRange("Account Type", AccType);
                Mapping.SetRange(Status, true);
                if Mapping.FindSet() then begin
                    if Page.RunModal(Page::"Account Mapping2", Mapping) = Action::LookupOK then begin
                        if StrLen(Mapping."Staff A/C") = 0 then begin
                            Error('The Employee No. %1 you''ve chosen do not have %1 Account', TranType);
                        end;
                        exit(Mapping."Employee No.");
                    end;
                end;
            end;
        end else begin
            exit(Personal());
        end;
    end;

    local procedure Personal(): Code[20]
    var
        Setup: Record "User Setup";
    begin
        Setup.Reset();
        if Setup.Get(GetUser.GetUser()) then begin
            if StrLen(Setup."Employee No.") = 0 then begin
                Error('KIndly contact IT Admin to add you Staff Number in User Setup');
            end;
            exit(Setup."Employee No.");
        end else begin
            Error('KIndly contact IT Admin to set you up as a user in User Setup');
        end;
    end;

    procedure OpenDoc(EmployeeNo: Code[20]; TranType: Enum "Transaction Type"): Boolean
    var
        Imprest: Record "Imprest Management";
    begin
        Imprest.Reset();
        Imprest.SetRange("Employee No", EmployeeNo);
        Imprest.SetRange("Transaction Type", TranType);
        Imprest.SetRange(Status, Imprest.Status::Open);
        if Imprest.FindFirst() then begin
            Error('You have an open  %1 Document ', Imprest."Transaction Type");
        end else begin
            exit(true);
        end;
    end;

    procedure PettyCashMax(): Decimal
    var
        myInt: Integer;
    begin
        CashMngtSetup.Reset();
        CashMngtSetup.Get();
        CashMngtSetup.TestField("Petty Cash Maximum");
        exit(CashMngtSetup."Petty Cash Maximum");
    end;

    procedure ChooseTellerBankAccount(Imprest: Record "Imprest Management")
    var
        Bank: Record "Bank Account";
    begin
        Bank.Reset();
        Bank.SetRange("Account Type", Bank."Account Type"::"Teller Account");
        Bank.SetRange(Blocked, false);
        if Bank.FindSet() then begin
            if Page.RunModal(Page::"Bank Account List Lookup", Bank) = Action::LookupOK then begin
                Imprest."Paying Bank Account" := Bank."No.";
                Imprest.Modify();
            end;
        end else begin
            Message('No Teller Account Found, KIndly Contact ICT');
        end;
    end;

    procedure GetTaxationSetup(WTaxCode: Code[20]; var Account: Code[20]): Decimal
    var
        Taxation: Record "Taxation Setup";
    begin
        Taxation.Reset();
        if Taxation.Get(WTaxCode) then begin
            if Taxation.Rate <> 0 then begin
                Taxation.TestField("Control G/L Account");
            end;
            Account := Taxation."Control G/L Account";
            exit(Taxation.Rate);
        end;
    end;

    procedure GetWTaxOnPayments(PVLine: Record "Payment/Receipt Lines")
    var
        Tax: Record "W/Tax On Payments";
        PV: Record "Payment/Receipt Voucher";
        TaxPage: Page "W/Tax On Payments";
    begin
        PV.Reset();
        PV.Get(PVLine.Code);
        Tax.Reset();
        Tax.SetRange("Deduction Type", Tax."Deduction Type"::"Tax Withholding");
        Tax.SetRange("PV Line Entry No.", PVLine."Line No");
        Tax.SetRange("PV No.", PVLine.Code);
        if (PV.Posted) or (PV.Status <> PV.Status::Open) then begin
            Page.Run(Page::"W/Tax On Payments Loop", Tax);
        end else begin
            Page.Run(Page::"W/Tax On Payments", Tax);
        end;
    end;

    procedure GetBoardPayments(PVLine: Record "Payment/Receipt Lines")
    var
        Tax: Record "W/Tax On Payments";
        PV: Record "Payment/Receipt Voucher";
        BoardPage: Page "Board Advance Loan Recovery";
    begin
        PV.Reset();
        PV.Get(PVLine.Code);
        Tax.Reset();
        Tax.SetRange("Deduction Type", Tax."Deduction Type"::Customer);
        Tax.SetRange("PV Line Entry No.", PVLine."Line No");
        Tax.SetRange("PV No.", PVLine.Code);
        if (PV.Posted) or (PV.Status <> PV.Status::Open) then begin
            Page.Run(Page::"W/Tax On Payments Loop", Tax);
            // BoardPage.SetTableView(Tax);
            // BoardPage.Editable := false;
            // BoardPage.Run();
        end else begin
            Page.Run(Page::"Board Advance Loan Recovery", Tax);
        end;
    end;*/

    [EventSubscriber(ObjectType::Page, Page::"PV Lines", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnAfterValidate(var Rec: Record "Payment/Receipt Lines")
    var
        TotalW_TaxAmount: Decimal;
    begin
        //  Rec.CalcFields("W/Tax Amount");
        // Rec."Net Amount" := Rec.Amount - Rec."W/Tax Amount";
    end;

    /*  [EventSubscriber(ObjectType::Page, Page::"W/Tax On Payments", 'OnAfterValidateEvent', 'Taxable Amount', false, false)]
      local procedure OnAfterValidatePage(var Rec: Record "W/Tax On Payments"; var xRec: Record "W/Tax On Payments")
      var
          TotalW_TaxAmount: Decimal;
          PVline: Record "Payment/Receipt Lines";
      begin
          Clear(TotalW_TaxAmount);
          Rec.CalcFields("Total W/Tax Amount");
          TotalW_TaxAmount := Rec."Total W/Tax Amount";
          TotalW_TaxAmount -= xRec."W/Tax Amount";
          TotalW_TaxAmount += Rec."W/Tax Amount";
          PVline.Reset();
          if PVline.Get(Rec."PV No.", Rec."PV Line Entry No.") then begin
              PVline."Net Amount" := PVline.Amount - TotalW_TaxAmount;
              PVline.Modify();
              Message('Payment Voucher Successfully Updated');
              Commit();
          end;
      end;*

      [EventSubscriber(ObjectType::Page, Page::"Board Advance Loan Recovery", 'OnAfterValidateEvent', 'Amount To Recover', false, false)]
      local procedure OnAfterValidateBoardPage(var Rec: Record "W/Tax On Payments"; var xRec: Record "W/Tax On Payments")
      var
          TotalW_TaxAmount: Decimal;
          PVline: Record "Payment/Receipt Lines";
      begin
          Clear(TotalW_TaxAmount);
          Rec.CalcFields("Total W/Tax Amount");
          TotalW_TaxAmount := Rec."Total W/Tax Amount";
          TotalW_TaxAmount -= xRec."W/Tax Amount";
          TotalW_TaxAmount += Rec."W/Tax Amount";
          PVline.Reset();
          if PVline.Get(Rec."PV No.", Rec."PV Line Entry No.") then begin
              PVline."Net Amount" := PVline.Amount - TotalW_TaxAmount;
              PVline.Modify();
              Message('Payment Voucher Successfully Updated');
              Commit();
          end;
      end;

      [EventSubscriber(ObjectType::Page, Page::"W/Tax On Payments", 'OnDeleteRecordEvent', '', false, false)]
      local procedure OnDeleteRecordPage(var Rec: Record "W/Tax On Payments"; var AllowDelete: Boolean)
      var
          TotalW_TaxAmount: Decimal;
          PVline: Record "Payment/Receipt Lines";
      begin
          Clear(TotalW_TaxAmount);
          Rec.CalcFields("Total W/Tax Amount");
          TotalW_TaxAmount := Rec."Total W/Tax Amount";
          PVline.Reset();
          if PVline.Get(Rec."PV No.", Rec."PV Line Entry No.") then begin
              PVline."Net Amount" := PVline.Amount - TotalW_TaxAmount;
              PVline.Modify();
              Message('Payment Voucher Successfully Updated');
              Commit();
          end;
      end;

      [EventSubscriber(ObjectType::Page, Page::"Board Advance Loan Recovery", 'OnDeleteRecordEvent', '', false, false)]
      local procedure OnDeleteRecordBoardPage(var Rec: Record "W/Tax On Payments"; var AllowDelete: Boolean)
      var
          TotalW_TaxAmount: Decimal;
          PVline: Record "Payment/Receipt Lines";
      begin
          Clear(TotalW_TaxAmount);
          Rec.CalcFields("Total W/Tax Amount");
          TotalW_TaxAmount := Rec."Total W/Tax Amount";
          PVline.Reset();
          if PVline.Get(Rec."PV No.", Rec."PV Line Entry No.") then begin
              PVline."Net Amount" := PVline.Amount - TotalW_TaxAmount;
              PVline.Modify();
              Message('Payment Voucher Successfully Updated');
              Commit();
          end;
      end;

      procedure DeleteWTaxOnPayments(PVNo: Code[20]; EntryNo: Integer)
      var
          WTax: Record "W/Tax On Payments";
      begin
          WTax.Reset();
          WTax.SetRange("PV Line Entry No.", LineNo);
          WTax.SetRange("PV No.", PVNo);
          if WTax.FindSet() then begin
              WTax.DeleteAll();
              Message('Payment Voucher Successfully Updated');
              Commit();
          end;
      end;
  */
    /*  procedure PostReceiptFromBank(Receipts: Record "Receipts From Bank")
      var
          Lines: Record "Bank Receipt Lines";
          LoansApplication: Codeunit "Loans Application";
          Loan: Record "Loan Application";
          PrincipalDue: Decimal;
          InterestDue: Decimal;
          InsuranceDue: Decimal;
          InterestSuspenseDue: Decimal;
          InsuranceSuspenseDue: Decimal;
          Member: Record Member;
          SourceCode: Code[20];
          LoanAmount: Decimal;
          Setup: Record "Source Code Setup";
          PostLabel: Label 'Are you sure you want to Post the Receipt No. %1 :-%2';
          InsuranceLable: Label 'Insurance Paid (%1)';
          IntLabel: Label 'Interest Paid (%1)';
          PrinLabel: Label 'Loan Repayment (%1)';
          NormalLabel: Label '%1 (%2)';
          RiderLabel: Label 'Insurance Funeral Expenses(Rider)';
          Description: Text[50];
          LoanType: Record "Loan Product Type";
          InsuranceAccount: Code[20];
          InterestAccount: Code[20];
          CBSSetup: Record "CBS Setup";
          TransactionNo: Integer;
          UserId2: Code[120];
          GetUser: Codeunit "Get User";
          GenJnlPost: Codeunit "Gen. Jnl.-Post";
          m: Integer;
          Unreceipted: Record "Unreceipted Bank Entries";
          BankAccount: Code[20];
          IsUnreceipted: Boolean;
          Remittance: Codeunit Remitance;
          Station: Record "Sacco Stations";
          BranchCode: Code[20];
          Batchname: Text[10];
      begin
          Receipts.TestField("Transaction Description");
          if Confirm(StrSubstNo(PostLabel, Receipts."Receipt No", Receipts."Transaction Description"), false) then begin
              CashMngtSetup.Reset();
              CashMngtSetup.Get();
              CashMngtSetup.TestField("AP Journal Template Name");
              Setup.Reset();
              Setup.Get();
              Setup.TestField("Principal Paid");
              Setup.TestField("Interest Paid");
              Setup.TestField("Ledger Fees");
              Payment_Type := Payment_Type::Cheque;
              Clear(PaymentChanell);
              PaymentChanell := PaymentChanell::"Bank Receipts";
              Batchname := CopyStr(Receipts."Receipt No", 1, 10);
              GenJournalBatch.Reset();
              if not GenJournalBatch.Get(CashMngtSetup."AP Journal Template Name", Batchname) then begin
                  GenJournalBatch.Init();
                  GenJournalBatch."Journal Template Name" := CashMngtSetup."AP Journal Template Name";
                  GenJournalBatch.Name := Batchname;
                  GenJournalBatch.Insert();
              end;
              JournalLine.Reset();
              JournalLine.SetRange("Journal Template Name", CashMngtSetup."AP Journal Template Name");
              JournalLine.SetRange("Journal Batch Name", Batchname);
              if JournalLine.FindSet() then begin
                  JournalLine.DeleteAll();
              end;
              Clear(JournalLine);
              LineNo := 10000;
              UserId2 := GetUser.GetUser();
              TransactionNo := LoansApplication.GetGLRegNo();
              Receipts.TestField("Received Amount");
              Receipts.CalcFields("Total Receipt Line");
              Receipts.TestField("Total Receipt Line");
              Receipts.TestField("Global Dimension 1 Code");
              Receipts.TestField("Received Amount", Receipts."Total Receipt Line");
              if Receipts."Member Type" in [Receipts."Member Type"::Member] then begin
                  Receipts.TestField("Member Code");
                  Member.Reset();
                  Member.Get(Receipts."Member Code");
              end else
                  if Receipts."Member Type" in [Receipts."Member Type"::Station] then begin
                      Receipts.TestField("Select Period");
                      Receipts.CalcFields("Total Lines");
                      Receipts.TestField("Total Lines", 1);
                  end;
              CBSSetup.Reset();
              CBSSetup.Get();
              CBSSetup.TestField("Interest Suspense");
              CBSSetup.TestField("Insurance Suspense");
              InterestAccount := CBSSetup."Interest Suspense";
              InsuranceAccount := CBSSetup."Insurance Suspense";
              Lines.Reset();
              Lines.SetRange("Receipt No", Receipts."Receipt No");
              if Lines.FindSet() then begin
                  repeat
                      if Lines.Amount > 0 then begin
                          Lines.TestField("Global Dimension 1 Code");
                          BranchCode := Lines."Global Dimension 1 Code";
                          if Lines."Account Type" = Lines."Account Type"::"G/L Account" then begin
                              BranchCode := Receipts."Global Dimension 1 Code";
                          end;
                          if StrLen(BranchCode) = 0 then begin
                              Error('%1:-%2 is missing Branch Code', Lines."Account No.", Lines."Account Name");
                          end;
                          if Lines."Account Type" = AccountType::Customer then begin
                              LoanAmount := Lines.Amount;
                              Loan.Reset();
                              Loan.Get(Lines."Account No.");
                              Loan.CalcFields("Outstanding Balance");
                              LoansApplication.LoanBalances(Loan."No.", PrincipalDue, InterestDue, InsuranceDue);
                              PrincipalDue := (Loan."Outstanding Balance" - (InterestDue + InsuranceDue));
                              LoansApplication.LoanSuspenseDue(Loan."No.", InterestSuspenseDue, InsuranceSuspenseDue);
                              LoanType.Get(Loan."Loan Product Type");
                              Loan.CalcFields("Outstanding Balance");
                              if LoanAmount > Abs(Loan."Outstanding Balance") then begin
                                  LoanAmount := Abs(Loan."Outstanding Balance");
                              end;
                              if InsuranceDue > LoanAmount then begin
                                  InsuranceDue := LoanAmount;
                                  PrincipalDue := 0;
                                  InterestDue := 0;
                              end;
                              LoanAmount -= InsuranceDue;
                              SourceCode := Setup."Ledger Fees";
                              Description := CopyStr(StrSubstNo(InsuranceLable, Lines."Account Name"), 1, 50);
                              PrepareJournal(CashMngtSetup."AP Journal Template Name", Batchname, Receipts."Receipt No", Receipts."Bank Receipt No.", Lines."Account Type", Lines."Account No.", -InsuranceDue, Description,
                              BranchCode, SourceCode, AccountType::"G/L Account", '');
                              if InsuranceSuspenseDue > 0 then begin
                                  if InsuranceSuspenseDue > InsuranceDue then begin
                                      InsuranceSuspenseDue := InsuranceDue;
                                  end;
                                  PrepareJournal(CashMngtSetup."AP Journal Template Name", Batchname, Receipts."Receipt No", Receipts."Bank Receipt No.", AccountType::"G/L Account", InsuranceAccount, InsuranceSuspenseDue, Description,
                                 BranchCode, SourceCode, AccountType::"G/L Account", CBSSetup."Ledger Fee G/L Account");
                                  LoansApplication.CreateInterestLedgerEntries(Loan."No.", Receipts."Receipt No", Description, InsuranceSuspenseDue, Member."Global Dimension 1 Code", Receipts."Receipt No", SourceCode, false, TransactionNo, UserId2);
                              end;
                              if InterestDue > LoanAmount then begin
                                  InterestDue := LoanAmount;
                                  PrincipalDue := 0;
                              end;
                              LoanAmount -= InterestDue;
                              SourceCode := Setup."Interest Paid";
                              Description := CopyStr(StrSubstNo(IntLabel, Lines."Account Name"), 1, 50);
                              PrepareJournal(CashMngtSetup."AP Journal Template Name", Batchname, Receipts."Receipt No", Receipts."Bank Receipt No.", Lines."Account Type", Lines."Account No.", -InterestDue, Description,
                              BranchCode, SourceCode, AccountType::"G/L Account", '');
                              if InterestSuspenseDue > 0 then begin
                                  if InterestSuspenseDue > InterestDue then begin
                                      InterestSuspenseDue := InterestDue;
                                  end;
                                  PrepareJournal(CashMngtSetup."AP Journal Template Name", Batchname, Receipts."Receipt No", Receipts."Bank Receipt No.", AccountType::"G/L Account", InterestAccount, InterestSuspenseDue, Description,
                                 BranchCode, SourceCode, AccountType::"G/L Account", LoanType."Interest Control Account");
                                  LoansApplication.CreateInterestLedgerEntries(Loan."No.", Receipts."Receipt No", Description, InsuranceSuspenseDue, Member."Global Dimension 1 Code", Receipts."Receipt No", SourceCode, false, TransactionNo, UserId2);
                                  LoansApplication.CreateInterestLedgerEntries(Loan."No.", Receipts."Receipt No", Description, InterestSuspenseDue, Member."Global Dimension 1 Code", Receipts."Receipt No", SourceCode, false, TransactionNo, UserId2);
                              end;
                              SourceCode := Setup."Principal Paid";
                              if PrincipalDue > 0 then begin
                                  PrincipalDue := LoanAmount;
                              end;
                              Description := CopyStr(StrSubstNo(PrinLabel, Lines."Account Name"), 1, 50);
                              PrepareJournal(CashMngtSetup."AP Journal Template Name", Batchname, Receipts."Receipt No", Receipts."Bank Receipt No.", Lines."Account Type", Lines."Account No.", -PrincipalDue, Description,
                              BranchCode, SourceCode, AccountType::"G/L Account", '');
                          end else begin
                              Clear(SourceCode);
                              Description := CopyStr(StrSubstNo(NormalLabel, Receipts."Transaction Description", Lines."Account Name"), 1, 50);
                              PrepareJournal(CashMngtSetup."AP Journal Template Name", Batchname, Receipts."Receipt No", Receipts."Bank Receipt No.", Lines."Account Type", Lines."Account No.", -Lines.Amount, Description,
                              BranchCode, SourceCode, AccountType::"G/L Account", '');
                          end;
                          Lines.CalcFields("Member Type");
                          if Lines."Member Type" in [Lines."Member Type"::Station] then begin
                              Station.Reset();
                              if Station.Get(Lines."Account No.") then begin
                                  Remittance.PostedRemittanceAdvice(Receipts."Receipt No", Lines."Account No.", Receipts."Select Period", Station."Global Dimension 1 Code", Enum::Reconciliation::Receipting);
                              end;
                          end;
                      end;
                  until Lines.Next() = 0;
              end;
              Receipts.TestField("Associated Bank Account");
              if Receipts."Unpresented Receipt" then begin
                  Unreceipted.Reset();
                  Unreceipted.Get(Receipts."Associated Bank Account");
                  Unreceipted.TestField("Receipt Transferred", false);
                  Unreceipted.TestField("Account No.");
                  AccountType := AccountType::"G/L Account";
                  BankAccount := Unreceipted."Account No.";
                  Receipts.TestField("Received Amount", Unreceipted."Received Amount");
              end else begin
                  AccountType := AccountType::"Bank Account";
                  BankAccount := Receipts."Associated Bank Account";
              end;
              PrepareJournal(CashMngtSetup."AP Journal Template Name", Batchname, Receipts."Receipt No", Receipts."Bank Receipt No.", AccountType, BankAccount,
              Receipts."Received Amount", Receipts."Transaction Description", Receipts."Global Dimension 1 Code", SourceCode, AccountType::"G/L Account", '');
              PostLine.Run(JournalLine);
              Receipts.Status := Receipts.Status::Posted;
              Receipts."Posted By" := UserId2;
              Receipts."Posting Date" := Today;
              Receipts.Modify();
              if Receipts."Unpresented Receipt" then begin
                  Unreceipted.Reset();
                  if Unreceipted.Get(Receipts."Associated Bank Account") then begin
                      Unreceipted."Receipt Transferred" := true;
                      Unreceipted."Date Transferred" := Today;
                      Unreceipted."Transferred By" := UserId2;
                      Unreceipted.Modify();
                  end;
              end;
              Message('Bank Receipt Successfully Done!');
          end;
      end;

      procedure PostUnreceiptedBankEntries(var Unreceipted: Record "Unreceipted Bank Entries")
      var
          SourceCode: Code[20];
          PostLabel: Label 'Are you sure you want to Post Selected Unreceipted Bank Entries';
          m: Integer;
          UserId2: Code[120];
      begin
          if Confirm(StrSubstNo(PostLabel, Unreceipted."Receipt No.", Unreceipted."Transaction Description"), false) then begin
              LineNo := 10000;
              UserId2 := GetUser.GetUser();
              CashMngtSetup.Reset();
              CashMngtSetup.Get();
              CashMngtSetup.TestField("AP Journal Template Name");
              CashMngtSetup.TestField("Sales Batch Template Name");
              GenJournalBatch.Reset();
              if not GenJournalBatch.Get(CashMngtSetup."AP Journal Template Name", CashMngtSetup."Sales Batch Template Name") then begin
                  GenJournalBatch.Init();
                  GenJournalBatch."Journal Template Name" := CashMngtSetup."AP Journal Template Name";
                  GenJournalBatch.Name := CashMngtSetup."Sales Batch Template Name";
                  GenJournalBatch.Insert();
              end;
              GenJlLine.Reset();
              GenJlLine.SETRANGE("Journal Template Name", CashMngtSetup."AP Journal Template Name");
              GenJlLine.SETRANGE("Journal Batch Name", CashMngtSetup."Sales Batch Template Name");
              if GenJlLine.FindSet() then
                  GenJlLine.DeleteAll();
              if Unreceipted.FindSet() then begin
                  repeat
                      MakeJournalEntries(LineNo, Unreceipted."Receipt No.", Unreceipted."Bank Receipt No.", Unreceipted."Transaction Description", Unreceipted."Received Amount", AccountType::"Bank Account", Unreceipted."Associated Bank Account", Unreceipted."Date Posted", AccountType::"G/L Account", Unreceipted."Account No.", '', AppliesToDocNoType::" ", '',
                      CashMngtSetup."AP Journal Template Name", CashMngtSetup."Sales Batch Template Name", Unreceipted."Global Dimension 1 Code", 'PD', Payment_Type);
                      LineNo += 1000;
                      Unreceipted.Status := Unreceipted.Status::Posted;
                      Unreceipted."Posted By" := UserId2;
                      GetUser.GetUser();
                      Unreceipted."Posting Date" := Today;
                      Unreceipted.Modify();
                  until Unreceipted.Next() = 0;
              end;

              GenJlLine.Reset();
              GenJlLine.SETRANGE("Journal Template Name", CashMngtSetup."AP Journal Template Name");
              GenJlLine.SETRANGE("Journal Batch Name", CashMngtSetup."Sales Batch Template Name");
              m := GenJlLine.Count;
              Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJlLine);
              if m <> GenJlLine.Count then begin
                  GenJournalBatch.Reset();
                  if GenJournalBatch.Get(CashMngtSetup."AP Journal Template Name", CashMngtSetup."Sales Batch Template Name") then begin
                      GenJournalBatch.Delete();
                  end;
                  Message('Unreceipted Bank Entries Successfully Done!');
              end else begin
                  Error('');
              end;
          end;
      end;

      procedure ChangeReceipts(Receipts: Record "Receipts From Bank")
      var
          ReceiptLines: Record "Bank Receipt Lines";
      begin
          ReceiptLines.Reset();
          ReceiptLines.SetRange("Receipt No", Receipts."Receipt No");
          if ReceiptLines.FindSet() then begin
              ReceiptLines.DeleteAll();
          end;
      end;
  */
    local procedure PrepareJournal(TemplateName: Code[10]; BatchName: Code[10]; DocumentNo: Code[20]; ExtDocumentNo: Code[20]; AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20];
                                                                                                                                                Amount: Decimal;
                                                                                                                                                Description: Text[50];
                                                                                                                                                GlobalDimension_1_Code: Code[20];
                                                                                                                                                SourceCode: Code[20];
                                                                                                                                                BalAccountType: Enum "Gen. Journal Account Type";
                                                                                                                                                BalAccountNo: Code[20])
    begin
        JournalLine.Init();
        JournalLine."Line No." := LineNo;
        JournalLine."Journal Template Name" := TemplateName;
        JournalLine."Journal Batch Name" := BatchName;
        JournalLine."Posting Date" := Today;
        JournalLine."Document No." := DocumentNo;
        JournalLine."External Document No." := ExtDocumentNo;
        JournalLine."Account Type" := AccountType;
        JournalLine.Validate("Account No.", AccountNo);
        JournalLine.Validate(Amount, Amount);
        JournalLine.Description := Description;
        JournalLine.Validate("Shortcut Dimension 1 Code", GlobalDimension_1_Code);
        JournalLine."Source Code" := SourceCode;
        JournalLine."Bal. Account Type" := BalAccountType;
        JournalLine.Validate("Bal. Account No.", BalAccountNo);
        //JournalLine."Payment Channel" := PaymentChanell;
        // JournalLine."Payment Type" := Payment_Type;
        if (Amount <> 0) then begin
            if StrLen(JournalLine."Shortcut Dimension 1 Code") = 0 then begin
                JournalLine."Shortcut Dimension 1 Code" := GlobalDimension_1_Code;
            end;
            JournalLine.Insert();
            LineNo += 1000;
        end;
    end;

    local procedure GetVendorName(VendorNo: Code[20]): Text
    begin
        Vendor.Reset();
        Vendor.Get(VendorNo);
        exit(Vendor.Name);
    end;

    procedure ReverseTransaction(PostingDate: Date; EntryNo: Integer)
    var
        GLRegister: Record "G/L Register";
        GLEntry: Record "G/L Entry";
        ReversalEntry: Record "Reversal Entry";
    begin
        if CalcDate('1D', PostingDate) >= Today then begin
            GLEntry.Reset();
            GLEntry.Get(EntryNo);
            GLRegister.Reset();
            GLRegister.SetFilter("From Entry No.", '<=%1', GLEntry."Entry No.");
            GLRegister.SetFilter("To Entry No.", '>=%1', GLEntry."Entry No.");
            if GLRegister.FindFirst() then begin
                ReversalEntry.ReverseTransaction(GLRegister."No.");
            end;
        end else begin
            Error('You can only Reverse a Posting that is within 24 hours period from the time of posting!');
        end;
    end;

    procedure GetNavigate(PostingDate: Date; DocumentNo: Code[20])
    var
        Navigate: Page Navigate;
    begin
        Navigate.SetDoc(PostingDate, DocumentNo);
        Navigate.Run();
    end;

    /*procedure ReopenImptestDocuments(Imprest: Record "Imprest Management")
    var
        MsgLbl: Label 'Are you sure you want to Reopen %1 %2:-%3?';
        LoansApplication: Codeunit "Loans Application";
    begin
        if Confirm(StrSubstNo(MsgLbl, Imprest."Transaction Type", Imprest."Imprest No.", Imprest.Description), false) then begin
            if LoansApplication.CanceledApprovalRequest(Imprest.RecordId) then begin
                Imprest.Status := Imprest.Status::Open;
                Imprest.Modify();
                Message('Re-Open of %1 %2:-%3 Successfully Done!', Imprest."Transaction Type", Imprest."Imprest No.", Imprest.Description);
            end;
        end;
    end;

    procedure ArchiveImptestDocuments(Imprest: Record "Imprest Management")
    var
        MsgLbl: Label 'Are you sure you want to Archive %1 %2:-%3?';
    begin
        if Confirm(StrSubstNo(MsgLbl, Imprest."Transaction Type", Imprest."Imprest No.", Imprest.Description), false) then begin
            Imprest.Status := Imprest.Status::Archived;
            Imprest.Modify();
            Message('Archival of %1 %2:-%3 Successfully Done!', Imprest."Transaction Type", Imprest."Imprest No.", Imprest.Description);
        end;
    end;*/

    /* procedure ReopenReceiptsDocuments(Receipts: Record "Receipts From Bank")
     var
         MsgLbl: Label 'Are you sure you want to Reopen Receipts From Bank %1:-%2?';
         LoansApplication: Codeunit "Loans Application";
     begin
         if Receipts.Status = Receipts.Status::Posted then exit;
         if Confirm(StrSubstNo(MsgLbl, Receipts."Receipt No", Receipts."Transaction Description"), false) then begin
             if LoansApplication.CanceledApprovalRequest(Receipts.RecordId) then begin
                 Receipts.Status := Receipts.Status::Open;
                 Receipts.Modify();
                 Message('Re-Open of Receipts From Bank %1:-%2 Successfully Done!', Receipts."Receipt No", Receipts."Transaction Description");
             end;
         end;
     end;

     procedure ArchiveReceiptsDocuments(Receipts: Record "Receipts From Bank")
     var
         MsgLbl: Label 'Are you sure you want to Archive Receipts From Bank %1:-%2?';
     begin
         if Receipts.Status = Receipts.Status::Posted then exit;
         if Confirm(StrSubstNo(MsgLbl, Receipts."Receipt No", Receipts."Transaction Description"), false) then begin
             Receipts.Status := Receipts.Status::Archived;
             Receipts.Modify();
             Message('Archival of Receipts From Bank %1:-%2 Successfully Done!', Receipts."Receipt No", Receipts."Transaction Description");
         end;
     end;

     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostVendorEntry', '', true, true)]
     local procedure OnBeforePostVendorEntry(var PurchHeader: Record "Purchase Header"; var GenJnlLine: Record "Gen. Journal Line")
     begin
         with GenJnlLine do begin
             PurchHeader.TestField("Invoice Description");
             Description := PurchHeader."Invoice Description";
         end;
     end;

     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnInsertICGenJnlLineOnAfterCopyDocumentFields', '', true, true)]
     local procedure OnInsertICGenJnlLineOnAfterCopyDocumentFields(PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line"; var TempICGenJournalLine: Record "Gen. Journal Line")
     begin
         with TempICGenJournalLine do begin
             PurchaseHeader.TestField("Invoice Description");
             Description := PurchaseHeader."Invoice Description";
         end;
     end;*/

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertEventPurchase(var Rec: Record "Purchase Line")
    var
        Purchase: Record "Purchase Header";
    begin
        Purchase.Reset();
        if Purchase.Get(Rec."Document Type"::Invoice, Rec."Document No.") then begin
            if StrLen(Purchase."Shortcut Dimension 1 Code") = 0 then begin
                Message('Document Type %1  Document No. %2\Please Select the Branch Code Under Invoice Details before you can Add Invoice Lines', Purchase."Document Type", Purchase."No.");
                Error('');
            end;
            Rec."Gen. Prod. Posting Group" := 'GENERAL';
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitHeaderDefaults', '', false, false)]
    local procedure OnAfterInsertEventPurchase(var PurchLine: Record "Purchase Line"; var TempPurchLine: Record "Purchase Line" temporary)
    var
        Purchase: Record "Purchase Header";
    begin
        Clear(PurchLine."Shortcut Dimension 1 Code");
    end;




}

