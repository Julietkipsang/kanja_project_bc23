table 50036 "Payment/Receipt Lines"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Code"; Code[30])
        {
            TableRelation = "Payment/Receipt Voucher";
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            trigger OnValidate()
            begin
                Clear("Account No.");
                // PaymentReceiptProcessing.DeleteWTaxOnPayments(Code, "Line No");
            end;
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" where("Direct Posting" = const(true))//, "Income/Balance" = const("Income Statement")
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            //where("Customer Type" = filter("Normal Account" | "Board Accounts" | "Staff Accounts"))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            // Vendor where("Vendor Type" = filter("Normal Account" | Stations))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account";

            trigger OnValidate();

            begin
                Clear("Remaining Amount");
                Clear(Amount);
                Clear("Net Amount");
                Clear("Tax Code Rate");
                Clear("Applies to Doc. No");
                Clear("Apples to Doc Type");
                Clear("External Document No");
                Clear(Description);
                "Account Name" := paymentVoucher.getAccountName("Account No.", "Account Type");
            end;
        }
        field(5; "Account Name"; Text[150])
        {
            Editable = false;
        }
        field(6; Description; Text[50])
        {
        }
        field(7; "Applies to Doc. No"; Code[20])
        {

            trigger OnLookup();
            begin
                Clear("Remaining Amount");
                TestField("Account Type");
                TestField("Account No.");
                CASE "Account Type" OF
                    "Account Type"::Vendor:
                        BEGIN
                            PVoucher.Reset();
                            PVoucher.Get(Code);
                            if PVoucher."Line type" = PVoucher."Line type"::Receipt then begin
                                "Applies to Doc. No" := PaymentReceiptProcessing.LookUpAppliesToDocVendRcpt("Account No.");
                            end else begin
                                "Applies to Doc. No" := PaymentReceiptProcessing.LookUpAppliesToDocVend("Account No.", "External Document No", "Remaining Amount", Description);
                                Validate("Remaining Amount");
                            end;
                            // GetOtherAppliesToDocVend("Applies to Doc. No");
                        END;
                    "Account Type"::Customer:
                        BEGIN
                            "Applies to Doc. No" := PaymentReceiptProcessing.LookUpAppliesToDocCust("Account No.");
                            // GetOtherAppliesToDocCust("Applies to Doc. No");
                        END;
                END;
                GetVenderDetails("Account No.");
            end;
            // end;
        }
        field(8; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                Amount := Abs(Amount);
                if "Remaining Amount" <> 0 then begin
                    if Amount > "Remaining Amount" then begin
                        Error('You can''t Pay Above the Invoice Amount of %1', "Remaining Amount");
                    end;
                end;
                Validate("Tax Code Rate");

            end;
        }
        field(9; "VAT Amount"; Decimal)
        {
            Editable = false;
        }
        /*  field(10; "W/Tax Amount"; Decimal)
          {
              //FieldClass = FlowField;
              // CalcFormula = sum("W/Tax On Payments"."W/Tax Amount" where("PV No." = field(Code), "PV Line Entry No." = field("Line No")));
              Editable = false;
              trigger OnValidate()
              begin
                  Commit();
                  CalcFields("W/Tax Amount");
                  "Net Amount" := Amount - "W/Tax Amount";
              end;
          }*/
        field(11; "Net Amount"; Decimal)
        {
            Editable = false;
            trigger OnValidate();
            begin
                ValidateAppliesToDoc()
            end;
        }
        /*      field(12; "KBA Branch Code"; Code[20])
              {
                  // TableRelation = "KBA Codes"."KBA Branch Code";
              }
              field(13; "Bank Account No."; Code[20])
              {
              }*/
        field(14; "W/Tax Code"; Code[10])
        {

            // TableRelation = "Taxation Setup";
            trigger OnValidate()
            begin
                // "Tax Code Rate" := PaymentReceiptProcessing.GetTaxationSetup("W/Tax Code", "W/Tax G/L Account");
                Validate("Tax Code Rate");
            end;
        }
        field(15; "Branch Name"; Text[70])
        {
            Editable = false;
        }
        /*   field(16; "Bank Name"; Code[90])
           {
               Editable = false;
           }*/
        field(17; "Remaining Amount"; Decimal)
        {
            trigger OnValidate()
            begin
                Validate(Amount, "Remaining Amount");
                Validate("Tax Code Rate");
            end;
        }
        field(18; "Tax Code Rate"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            begin
                // "W/Tax Amount" := Round(Amount * ("Tax Code Rate" / 100), 0.01);
                // "Net Amount" := Amount - "W/Tax Amount";
            end;
        }
        field(19; "Tax Amount"; Decimal)
        {
            Editable = false;
        }
        field(20; "VATABLE Amount"; Decimal)
        {
            Editable = false;
        }
        field(21; "Global Dimension 1 Code"; Code[10])
        {
            //CaptionClass = '1,1,1';
            TableRelation = BranchCodes;
            //Editable = false;
        }
        field(22; "Global Dimension 2 Code"; Code[10])
        {
            // CaptionClass = '1,1,2';
            TableRelation = BranchCodes;
            Editable = false;
        }
        field(23; "Apples to Doc Type"; Enum "Gen. Journal Document Type")
        {

        }
        /* field(24; "KBA Code"; Code[10])
         {
             // TableRelation = "KBA Codes";
         }*/
        field(25; "External Document No"; Code[35])
        {
            Editable = false;
        }
        field(26; "W/Tax G/L Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true), "Income/Balance" = const("Balance Sheet"));
            Editable = false;
        }
        field(30; "Already Posted"; Boolean)
        {
            //FieldClass = FlowField;
            // CalcFormula = lookup("Imprest Management".Posted where("Imprest No." = field("Imprest No")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code", "Line No")
        {
            Clustered = true;
        }
        Key(Key2; Code)
        {
            Enabled = true;
        }
    }

    fieldgroups
    {
    }

    var
        GenJournalLine: Record "Gen. Journal Line";
        PaymentReceiptProcessing: Codeunit "Cash Management";
        // ff:Codeunit cash man
        paymentVoucher: codeunit PaymentVoucher;
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        Vendor: Record Vendor;
        // KBACodes: Record "KBA Codes";
        //BankName: Record "Bank Name";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        PVoucher: Record "Payment/Receipt Voucher";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
    end;

    procedure GetVenderDetails("AccountNo.": Code[20]);
    begin

        Vendor.RESET;
        IF Vendor.GET("Account No.") THEN BEGIN


        END;
    end;

    local procedure ValidateAppliesToDoc();
    begin

        IF PVoucher.GET(Code) THEN BEGIN
            IF PVoucher."Line type" = PVoucher."Line type"::Payment THEN BEGIN
                IF ("Account Type" = "Account Type"::Vendor) THEN BEGIN
                    TESTFIELD("Applies to Doc. No");
                END;
            END;
            IF PVoucher."Line type" = PVoucher."Line type"::Receipt THEN BEGIN
                IF ("Account Type" = "Account Type"::Customer) THEN BEGIN
                    TESTFIELD("Applies to Doc. No");
                END;
            END;
        END;

    end;
}

