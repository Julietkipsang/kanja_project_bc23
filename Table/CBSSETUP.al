table 50013 "CBS Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "MA Individual Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(3; "Member Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; Prefix; Text[100])
        {

        }
        field(5; "Member No. Format"; Option)
        {
            OptionCaption = 'No. Series Only,Branch Code+No. Series';
            OptionMembers = "No. Series Only","Branch Code+No. Series";
        }
        field(6; "Account Nos."; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(7; "Account No. Format"; Option)
        {
            OptionCaption = 'No. Series Only,Branch Code+Account Type+Member No.+Count';
            OptionMembers = "No. Series Only","Branch Code+Account Type+Member No.+Count";
        }
        field(8; "Account Opening Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; SaccoNo; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(14; FintechNo; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(15; MerchantNo; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(16; AgentNo; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(20; "Phone No. Format"; Option)
        {
            OptionCaption = '07XXXXXXXX,2547XXXXXXXX';
            OptionMembers = "07XXXXXXXX","2547XXXXXXXX";
        }

        field(33; "Excise Duty %"; Decimal)
        {
        }
        field(34; "Excise Duty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(35; "Withholding Tax %"; Decimal)
        {
        }
        field(36; "Withholding Tax G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(37; "Stamp Duty %"; Decimal)
        {
        }
        field(38; "Stamp Duty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }

        field(39; "Kanja General Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(40; "Kanja General Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Kanja General Template Name"));
        }

        field(41; "Image Path Local Directory"; Text[100])
        {

        }
        field(42; "Image Path IP Address"; Text[100])
        {
        }

        field(43; "Commission Percentage(%)"; Decimal)
        {

        }
        field(44; "Settlement Bank Account"; Code[20])
        {
            Caption = 'Settlement Bank Account';
            TableRelation = "Bank Account" where(Blocked = filter(false));
        }

        field(45; PaymentVoucher; Code[30])
        {
            TableRelation = "No. Series";

        }
        field(46; EdmsPath; Text[100])
        {

        }
        field(47; "Receipt Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(48; "Receipt Journal Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Receipt Journal Template"));
        }
        field(49; "Payment Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(50; "Payment Journal Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payment Journal Template"));
        }
        field(51; "Petty Cash Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(52; "Petty Cash Journal Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Petty Cash Journal Template"));
        }
        field(53; "Bank Trans. Journal Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
        }
        field(54; "Bank Trans. Journal Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Bank Trans. Journal Template"));
        }
        field(55; "Entities Percentage"; Decimal)
        {

        }
        field(56; "Check Percentage"; Boolean)
        {

        }
        field(57; PartnerNo; Code[20])
        {
            TableRelation = "No. Series";
        }

    }


    keys
    {
        key(Key1; "Primary Key")
        {
            Enabled = true;
        }
    }

    fieldgroups
    {
    }

}

