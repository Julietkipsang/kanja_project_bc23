table 50017 "Charges Table"
{
    // version TL2.0


    fields
    {

        field(2; "Code"; Code[20])
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
        field(3; Description; Text[100])
        {
            Editable = false;
        }

        field(4; "Calculation Mode"; Option)
        {
            OptionCaption = '% of Transcation,Flat Amount,Range';
            OptionMembers = "% of Transcation","Flat Amount",Range;
        }
        field(5; Value; Decimal)
        {
            trigger
            OnValidate()
            begin
                // Charges.Reset();
                // Charges.SetRange(Code, Rec.Code);
                // Charges.SetRange("Calculation Mode", "Calculation Mode"::"% of Transcation");
                // if Charges.FindSet() then begin
                //     repeat
                //         Value += Charges.Value;
                //     until Charges.Next() = 0;
                // end;
                // if TotalAmount > 100 then
                //     Error('Value must be less than or equal to 100');

            end;
        }
        field(6; "Account Type"; Enum "Gen. Journal Account Type")
        {

        }
        field(7; "Account No."; Code[20])
        {

            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer// WHERE ("Customer Type"=CONST(Normal))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor// WHERE ("Vendor Type"=CONST(FOSA))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            // trigger OnValidate();
            // begin
            //     PaymentReceiptProcessing.PopulatePVLines(Rec);
            //     "Payee Name" := PaymentReceiptProcessing."GetVendor/CustomerName"("Account No.", "Account Type");
            //     IF "Line type" = "Line type"::Receipt THEN BEGIN
            //         Description := "Payee Name";
            //     END;
            // end;
        }
        field(9; "Insurance Charge"; Boolean)
        {

        }
        field(10; "Minimum Fees"; Decimal)
        {

        }
        field(11; Installments; Boolean)
        {

        }
        field(12; "Source Code"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(13; "Charge Type"; Enum "Charge Type")
        {
            // OptionMembers = RECFintech,SENFintech,Kanja,"Others","SENSacco",RECSacco,REmerchant,SEmerchant,REAgent,SEAgent,"M-Kanja",Ketsa,Tl;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                // IF "Charge Type" = "Charge Type"::Kanja then
                //"Account Type" := "Account Type"::"GL Account";
            end;
        }
        field(14; "Transaction Type"; Option)
        {
            OptionMembers = "Member to Member","Member to Merchant";
        }
        field(15; "Channel"; Option)
        {
            OptionMembers = "MobileBanking","CBS",Paybill;
        }
        field(16; ExciseGl; Code[20])
        {
            TableRelation = "G/L Account" where(Blocked = const(false), "Direct Posting" = const(true));
        }
        field(17; "% of transaction"; Decimal)
        {


        }
        field(18; "Excise Account Type"; Option)
        {
            OptionMembers = ,"GL Account",Member;
        }
        field(19; "Charge Description"; Text[30])
        {
        }
        field(20; "Excise Description"; Text[30])
        {

        }
        field(30; TotalAmount; Decimal)
        {

            CalcFormula = sum("Charges Table".Value where(Code = field(Code)));
            FieldClass = FlowField;
        }
        field(31; "Applies to"; Boolean)
        {

        }
    }

    keys
    {
        key(Key1; "Code", "Charge Type", "Transaction Type", Channel)
        {
            Clustered = true;
        }
        key(Key2; Code)
        {
            Enabled = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Description)
        {
        }
    }

    var
        LoanChargeSetup1: Record "Loan Charge Setup";
        Total: Decimal;
        Charges: Record "Charges Table";
}

