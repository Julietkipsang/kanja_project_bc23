codeunit 50101 PaymentVoucher
{
    trigger OnRun()
    begin

    end;

    var
        Vendor: Record Vendor;
        Banks: Record "Bank Account";

        Gl: Record "G/L Account";
        PaymentType: Enum "Payment Voucher Mode";
        AccountType: Enum "Gen. Journal Account Type";
        PVLines: Record "Payment/Receipt Lines";

        KanjaFunc: Codeunit kanjaFunctions;

    procedure getAccountName(accountNo: Code[100]; accountType: Enum "Gen. Journal Account Type") AccountName: Code[100]
    begin
        case accountType of
            accountType::"Bank Account":
                begin
                    if Banks.get(accountNo) then begin
                        AccountName := Banks.Name;
                    end;
                end;
            accountType::Vendor:
                begin
                    if Vendor.get(accountNo) then begin
                        AccountName := Vendor.Name;

                    end
                end;
            accountType::"G/L Account":
                begin
                    if Gl.Get(accountNo) then begin
                        AccountName := Gl.Name;
                    end;
                end;

        end;
        exit(AccountName);

    end;

    procedure postPaymentVoucher(PaymentVoucher: Record "Payment/Receipt Voucher")
    var
        BatchName: Code[100];
        TemplateName: Code[100];
    begin
        //  with PaymentVoucher do begin
        TemplateName := 'GENERAL';
        BatchName := 'SPOTCASH';
        IF PaymentVoucher.Status <> PaymentVoucher.Status::Released THEN BEGIN
            ERROR('The Payment Voucher No. %1 Cannot be Posted before it is fully Approved', PaymentVoucher."Paying Code.");
        END;

        IF PaymentVoucher.Posted = true THEN BEGIN
            ERROR('Payment Voucher %1 has been posted', PaymentVoucher."Paying Code.");
        END;
        if PaymentVoucher."Payment Mode" in [PaymentVoucher."Payment Mode"::Cheque, PaymentVoucher."Payment Mode"::Cash, PaymentVoucher."Payment Mode"::"RTGS/EFT"] then begin
            AccountType := AccountType::"Bank Account";
        end else
            if PaymentVoucher."Payment Mode" in [PaymentVoucher."Payment Mode"::FOSA] then begin
                AccountType := AccountType::Vendor;
            end else begin
                Error('The Payment Voucher Do not have Paymnet Mode!');
            end;

        KanjaFunc.CreateJournalLines(TemplateName, BatchName, PaymentVoucher."Paying Code.", AccountType, PaymentVoucher."Paying Bank", AccountType::"G/L Account", '', (-1 * PaymentVoucher."Net Amount"), PaymentVoucher.Description, '');
        PVLines.Reset();
        PVLines.SetRange(Code, PaymentVoucher."Paying Code.");
        if PVLines.FindSet() then begin
            repeat
                KanjaFunc.CreateJournalLines(TemplateName, BatchName, PaymentVoucher."Paying Code.", PVLines."Account Type", PVLines."Account No.", AccountType::"G/L Account", '', (PVLines."Amount"), PVLines.Description, '');
            until PVLines.Next() = 0;
        end;

        KanjaFunc.PostJournalLine();
        PaymentVoucher.Posted := true;
        PaymentVoucher."Posted By" := UserId;
        PaymentVoucher."Date Posted" := Today;
        PaymentVoucher."Time Posted" := Time;
        PaymentVoucher.Modify();
    end;
    // end;


    var
        myInt: Integer;
}