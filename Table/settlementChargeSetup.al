Table 50040 "Settlement"
{
    fields
    {

        field(1; "Minimum Amount"; Decimal)
        {
        }
        field(2; "Maximum Amount"; Decimal)
        {
        }
        field(3; "Settlement %"; Decimal)
        {
            Caption = 'Settlement % (SACCO)';
            Description = 'This is reserved for SACCO commission';
        }
        field(4; "Settlement Amount  (SACCO)"; Decimal)
        {
            Caption = 'Settlement Amount (SACCO)';
            Description = 'This is reserved for SACCO commission';
        }
        field(5; "Settlement % (TL)"; Decimal)
        {
            Caption = 'Settlement % (TL)';
            Description = 'This is reserved for TL commission';
        }
        field(6; "Settlement Amount  (TL)"; Decimal)
        {
            Caption = 'Settlement Amount (TL)';
            Description = 'This is reserved for TL commission';
        }
        field(7; "Settlement % (COOP)"; Decimal)
        {
            Caption = 'Settlement % (COOP)';
            Description = 'This is reserved for COOP commission';
        }
        field(8; "Settlement Amount (COOP)"; Decimal)
        {
            Caption = 'Settlement Amount (COOP)';
            Description = 'This is reserved for COOP commission';
        }
        field(9; "Settlement % (AGENT)"; Decimal)
        {
            Caption = 'Settlement % (AGENT)';
            Description = 'This is reserved for AGENT commission';
        }
        field(10; "Settlement Amount (AGENT)"; Decimal)
        {
            Caption = 'Settlement Amount (AGENT)';
            Description = 'This is reserved for AGENT commission';
        }
        field(11; "Total Charge Amount"; Decimal)
        {

        }
        field(12; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(13; "Calculation Method"; Option)
        {
            OptionMembers = "Based Flat Amount","Based on %",Range;
        }
        field(14; "Agent Type"; Option)
        {
            OptionCaption = 'External,Internal';
            OptionMembers = External,Internal;
        }
        field(15; "MPESA Charges"; Decimal)
        {
            trigger
            OnValidate()
            begin
                //  "Total Charge Amount" := "MPESA Charges" + KanjaCharges;
            end;

        }

        field(16; Description; Code[100])
        {


        }
        field(17; settlementTypes; Enum settlementType)
        {

            trigger
            OnValidate()
            begin
                settlementDescription := Format(settlementTypes);
            end;
        }
        field(18; "Deduct Excise Duty"; Boolean)
        {
        }

        field(19; "Deduct Withholding Tax"; Boolean)
        {
        }
        field(20; "Settlement Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Settlement Account Type (SACCO)';
            Description = 'This is reserved for SACCO commission';
            trigger OnValidate()
            begin
                Clear("Settlement Account No.");
            end;
        }
        field(21; "Settlement Account No."; Code[20])
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
        field(22; "Settlement Account Type (TL)"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Settlement Account Type (TL)';
            Description = 'This is reserved for TL commission';
            trigger OnValidate()
            begin
                Clear("Settlement Account No. (TL)");
            end;
        }
        field(23; "Settlement Account No. (TL)"; Code[20])
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
        field(24; "Settlement3 Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Settlement Account Type (COOP)';
            Description = 'This is reserved for COOP commission';

        }
        field(25; "Settlement3 Account No."; Code[20])
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
        field(26; "Settlement4 Account Type"; Code[20])
        {
            Caption = 'Settlement Account Type (Agent)';
            Description = 'This is reserved for AGENT commission';
            TableRelation = "Account Type";
        }
        field(27; "Sett. Control Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Settlement Control Account Type';

        }
        field(28; "Sett. Control Account No."; Code[20])
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

        field(29; "Charge Penalty"; Boolean)
        {
        }


        field(30; "Settlement Account Type (Saf)"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Settlement Account Type (Safaricom)';
            Description = 'This is reserved for MPESA CHarges';
            trigger OnValidate()
            begin
                Clear("Settlement Account No. (Saf)");
            end;
        }
        field(31; "Settlement Account No. (Saf)"; Code[20])
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

        field(32; "Excise %"; Decimal)
        {

        }
        field(33; "Excise G/L Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true), Blocked = const(false));
        }

        field(34; "Stamp Duty %"; Decimal)
        {

        }
        field(35; "Stamp Duty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true), Blocked = const(false));
        }

        field(36; settlementDescription; Text[100])
        {


        }
        field(37; Value; Decimal)
        {

        }
        field(38; Type; Option)
        {
            OptionCaption = ',KanjaCharges,MpesaCharges';
            OptionMembers = ,KanjaCharges,MpesaCharges;

        }
        field(39; TotalPercentage; Decimal)
        {

        }


    }

    keys
    {
        key(Key1; "Line No.", settlementTypes)
        {
            Clustered = true;
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

}
