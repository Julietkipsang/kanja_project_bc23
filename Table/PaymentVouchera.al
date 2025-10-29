table 50035 "Payment/Receipt Voucher"
{
    // version TL 2.0
    DataCaptionFields = "Paying Code.", Description;

    fields
    {
        field(1; "Paying Code."; Code[10])
        {
            Editable = false;
        }
        field(2; "Payment Date"; Date)
        {
        }
        field(3; Type; Code[10])
        {
        }
        field(4; "Payment Mode"; Enum "Payment Voucher Mode")
        {

            trigger OnValidate()
            begin
                Clear("Paying Bank");
                Clear("Paying/Receiving Bank Name");
            end;
        }
        field(5; "Cheque No."; Code[20])
        {
            //Editable = false;
        }
        field(6; "Cheque Date"; Date)
        {
            //Editable = false;
        }
        field(7; "Paying Bank"; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate();
            var
                Bank: Record "Bank Account";
            begin
                if Bank.get("Paying Bank") then begin
                    "Paying/Receiving Bank Name" := Bank.Name;
                end;

            end;
        }
        field(8; "VAT Amount"; Decimal)
        {
        }
        field(9; "Withholding Tax Amount"; Decimal)
        {
        }
        field(10; "Net Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payment/Receipt Lines".Amount where(Code = field("Paying Code.")));
            Editable = false;

        }
        field(11; Amount; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payment/Receipt Lines".Amount WHERE(Code = FIELD("Paying Code.")));
            Editable = false;
        }
        field(12; Posted; Boolean)
        {
        }
        field(13; "Time Posted"; Time)
        {
        }
        field(14; "Date Posted"; Date)
        {
        }
        field(15; "Posted By"; Code[90])
        {
            TableRelation = "User Setup";
        }
        field(16; "Paying/Receiving Bank Name"; Text[100])
        {
        }
        field(17; Remarks; Text[90])
        {
        }
        field(18; "Global Dimension 1 Code"; Code[10])
        {
            // CaptionClass = '1,1,1';
            TableRelation = BranchCodes;
            //.Code WHERE("Global Dimension No." = CONST(1));
        }
        field(19; "Approval Status"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" WHERE("Document No." = field("Paying Code.")));
        }
        field(20; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Released,Rejected,Archived';
            OptionMembers = Open,"Pending Approval",Released,Rejected,Archived;
        }
        /* field(21; Select; Boolean)
         {
         }*/
        field(22; "Created By"; Code[90])
        {
            TableRelation = "User Setup";
        }
        /* field(23; Balance; Decimal)
         {
         }*/
        field(24; "Line type"; Option)
        {
            OptionCaption = ',Payment Voucher,Receipt Voucher';
            OptionMembers = ,Payment,Receipt;
        }
        field(25; "No. Series"; Code[20])
        {
        }
        field(26; Description; Text[50])
        {
        }
        field(27; "Document Type"; Option)
        {
            OptionCaption = ',Payment Voucher,Receipt Voucher';
            OptionMembers = ,"Payment Voucher",Receipt;
        }
        field(28; "Next Approver"; Code[90])
        {
            Editable = false;
            TableRelation = "Approval Entry"."Approver ID" WHERE("Document No." = FIELD("Paying Code."),
                                                                  Status = FILTER(Open));
        }
        field(29; "Account Type"; Enum "Gen. Journal Account Type")
        {

        }
        field(30; "Account No."; Code[20])
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
        field(31; "Payee Name"; Code[90])
        {
            Editable = true;
        }
        /*  field(32; "FOSA PG"; Code[20])
          {
              Editable = false;
          }
          field(33; "Member No."; Code[20])
          {
              //TableRelation = Member;
          }*/

    }

    keys
    {
        key(Key1; "Paying Code.")
        {
            Clustered = true;
        }
        key(Key2; Status, Posted)
        {
            Enabled = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        Error('');
        IF Status <> Status::Open THEN BEGIN
            ERROR('You Cannot Delete This Document At This Stage!');
        END;
    end;

    trigger OnInsert();
    begin
        CbsSetup.Get();
        "Paying Code." := NoSeriesMgt.GetNextNo(CbsSetup.PaymentVoucher, Today, true);
        "Payment Date" := Today;
        "Created By" := UserId;

    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        PVLines: Record "Payment/Receipt Lines";
        Vendor: Record Vendor;
        CbsSetup: Record "CBS Setup";



    procedure ReqLinesExist(): Boolean;
    begin
        // PVLines.RESET;
        // PVLines.SETRANGE(Code, "Paying Code.");
        // EXIT(PVLines.FINDFIRST);
    end;
}

