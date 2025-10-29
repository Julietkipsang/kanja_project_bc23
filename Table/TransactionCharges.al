Table 50001 "Transaction Charge"
{
    fields
    {

        field(3; "Minimum Amount"; Decimal)
        {
        }
        field(4; "Maximum Amount"; Decimal)
        {
        }
        field(5; "Settlement %"; Decimal)
        {
            Caption = 'Settlement % (SACCO)';
            Description = 'This is reserved for SACCO commission';
        }
        field(6; "Settlement Amount  (SACCO)"; Decimal)
        {
            Caption = 'Settlement Amount (SACCO)';
            Description = 'This is reserved for SACCO commission';
        }
        field(7; "Settlement % (TL)"; Decimal)
        {
            Caption = 'Settlement % (TL)';
            Description = 'This is reserved for TL commission';
        }
        field(8; "Settlement Amount  (TL)"; Decimal)
        {
            Caption = 'Settlement Amount (TL)';
            Description = 'This is reserved for TL commission';
        }
        field(9; "Settlement % (COOP)"; Decimal)
        {
            Caption = 'Settlement % (COOP)';
            Description = 'This is reserved for COOP commission';
        }
        field(10; "Settlement Amount (COOP)"; Decimal)
        {
            Caption = 'Settlement Amount (COOP)';
            Description = 'This is reserved for COOP commission';
        }
        field(11; "Settlement % (AGENT)"; Decimal)
        {
            Caption = 'Settlement % (AGENT)';
            Description = 'This is reserved for AGENT commission';
        }
        field(12; "Settlement Amount (AGENT)"; Decimal)
        {
            Caption = 'Settlement Amount (AGENT)';
            Description = 'This is reserved for AGENT commission';
        }
        field(13; "Total Charge Amount"; Decimal)
        {
        }
        field(14; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(15; "Calculation Method"; Option)
        {
            OptionMembers = "Based Flat Amount","Based on %";
        }
        field(16; "Agent Type"; Option)
        {
            OptionCaption = 'External,Internal';
            OptionMembers = External,Internal;
        }
        field(17; "MPESA Charges"; Decimal)
        {

        }
        field(18; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Services Type";

            trigger OnValidate()
            var
                ServiceType: Record "Services Type";
            begin
                ServiceType.GET(Code);
                Description := ServiceType.Description;
            end;
        }
        field(19; Description; Code[100])
        {


        }
        field(20; settlementTypes; Enum settlementType)
        {

        }
        field(28; "Deduct Excise Duty"; Boolean)
        {
        }

        field(30; "Deduct Withholding Tax"; Boolean)
        {
        }
        field(31; "Settlement Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Settlement Account Type (SACCO)';
            Description = 'This is reserved for SACCO commission';
            trigger OnValidate()
            begin
                Clear("Settlement Account No.");
            end;
        }
        field(32; "Settlement Account No."; Code[20])
        {
            Caption = 'Settlement Account No. (SACCO)';
            Description = 'This is reserved for SACCO commission';
            TableRelation = IF ("Settlement Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                 Blocked = filter(false))
            ELSE
            IF ("Settlement Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Settlement Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Settlement Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(33; "Settlement Account Type (TL)"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Settlement Account Type (TL)';
            Description = 'This is reserved for TL commission';
            trigger OnValidate()
            begin
                Clear("Settlement Account No. (TL)");
            end;
        }
        field(34; "Settlement Account No. (TL)"; Code[20])
        {
            Caption = 'Settlement Account No. (TL)';
            Description = 'This is reserved for TL commission';
            TableRelation = IF ("Settlement Account Type (TL)" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                  Blocked = CONST(false))
            ELSE
            IF ("Settlement Account Type (TL)" = CONST(Customer)) Customer
            ELSE
            IF ("Settlement Account Type (TL)" = CONST(Vendor)) Vendor
            ELSE
            IF ("Settlement Account Type (TL)" = CONST("Bank Account")) "Bank Account";
        }
        field(35; "Settlement3 Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Settlement Account Type (COOP)';
            Description = 'This is reserved for COOP commission';

        }
        field(36; "Settlement3 Account No."; Code[20])
        {
            Caption = 'Settlement Account No. (COOP)';
            Description = 'This is reserved for COOP commission';
            TableRelation = IF ("Settlement3 Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                  Blocked = CONST(false))
            ELSE
            IF ("Settlement3 Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Settlement3 Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Settlement3 Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(37; "Settlement4 Account Type"; Code[20])
        {
            Caption = 'Settlement Account Type (Agent)';
            Description = 'This is reserved for AGENT commission';
            TableRelation = "Account Type";
        }
        field(38; "Sett. Control Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Settlement Control Account Type';

        }
        field(39; "Sett. Control Account No."; Code[20])
        {
            Caption = 'Settlement Control Account No.';
            TableRelation = IF ("Sett. Control Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                    Blocked = CONST(false))
            ELSE
            IF ("Sett. Control Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Sett. Control Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Sett. Control Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(40; "Service ID"; Code[20])
        {
        }

        field(42; "Priority Posting"; Boolean)
        {
        }
        field(43; "Charge Penalty"; Boolean)
        {
        }

        field(21; "Agent Account Type"; Code[20])
        {
            TableRelation = "Account Type";
        }
        field(22; "Settlement Account Type (Saf)"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Settlement Account Type (Safaricom)';
            Description = 'This is reserved for MPESA CHarges';
            trigger OnValidate()
            begin
                Clear("Settlement Account No. (Saf)");
            end;
        }
        field(23; "Settlement Account No. (Saf)"; Code[20])
        {
            Caption = 'Settlement Account No. (Safaricom)';
            Description = 'This is reserved for Safaricom commission';
            TableRelation = IF ("Settlement Account Type (Saf)" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                  Blocked = CONST(false))
            ELSE
            IF ("Settlement Account Type (Saf)" = CONST(Customer)) Customer
            ELSE
            IF ("Settlement Account Type (Saf)" = CONST(Vendor)) Vendor
            ELSE
            IF ("Settlement Account Type (Saf)" = CONST("Bank Account")) "Bank Account";
        }

        field(24; "Excise %"; Decimal)
        {

        }
        field(25; "Excise G/L Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true), Blocked = const(false));
        }

        field(26; "Stamp Duty %"; Decimal)
        {

        }
        field(27; "Stamp Duty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true), Blocked = const(false));
        }


    }

    keys
    {
        key(Key1; "Line No.", Code, settlementTypes)
        {
            Clustered = true;
        }
        key(key2; Code)
        {
            Enabled = true;
        }
        key(key3; settlementTypes)
        {
            Enabled = true;
        }

    }

    fieldgroups
    {
    }

    var
    // Charges: Record Charge;
}
