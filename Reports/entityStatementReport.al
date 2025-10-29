report 50001 entityStatement
{
    // UsageCategory = ReportsAndAnalysis;
    //ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\EntityReport.rdl';


    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = where(Status = filter("Active"));
            RequestFilterFields = "No.";

            column(No_; "No.")
            {

            }
            column(Name; Name)
            {

            }
            column(Phone_No_; "Phone No.")
            {

            }
            column(Balance; Balance)
            {

            }
            column(FintechAccount; FintechAccount)
            {

            }

            column(E_Mail; "E-Mail")
            {


            }
            column(startDate; startDate)
            {

            }
            column(endDate; endDate)
            {

            }
            column(Status; Status)
            {

            }



            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {

                DataItemLink = "Vendor No." = field("No.");


                column(Vendor_No_; "Vendor No.")
                {

                }
                column(postingDate; postingDate)
                {

                }

                column(Description; Description)
                {

                }
                column(Amount; Amount)
                {

                }
                column(Document_No_; "Document No.")
                {

                }
                column(runningBal; runningBal)
                {
                }
                column(openingBalnce; openingBalnce)
                {

                }
                column(closingBal; closingBal)
                {

                }
                column(debitAmount; debitAmount)
                {

                }
                column(creditAmount; creditAmount)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    creditAmount := 0;
                    debitAmount := 0;
                    if lastBal > 0 then begin
                        runningBal := lastBal;
                    end else begin
                        runningBal := openingBalnce;
                    end;
                    "Vendor Ledger Entry".SetRange("Date Filter", startDate, endDate);
                    postingDate := "Vendor Ledger Entry"."Posting Date";
                    "Vendor Ledger Entry".CalcFields(Amount);
                    if "Vendor Ledger Entry".Amount < 0 then begin
                        creditAmount += Abs("Vendor Ledger Entry".Amount);
                    end;
                    if "Vendor Ledger Entry".Amount > 0 then begin
                        debitAmount += Abs("Vendor Ledger Entry".Amount);
                    end;

                    // if creditAmount > 0 then begin
                    //     runningBal += creditAmount;
                    //     debitAmount := 0;
                    // end;
                    // if debitAmount > 0 then begin
                    //     runningBal -= debitAmount;

                    //     creditAmount := 0;
                    // end;
                    lastBal := runningBal;
                end;

            }
            trigger
            OnAfterGetRecord()
            begin
                prevDate := CalcDate('-1D', startDate);
                SetRange("Date Filter", 0D, endDate);
                Vendor.CalcFields("Net Change");
                closingBal := Vendor."Net Change";
                SetRange("Date Filter", 0D, prevDate);
                Vendor.CalcFields("Net Change");
                openingBalnce := Vendor."Net Change";

            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(startDate; startDate)
                    {

                    }
                    field(endDate; endDate)
                    {

                    }

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }


    var
        myInt: Integer;
        runningBal: Decimal;
        openingBalnce: Decimal;
        startDate: Date;
        endDate: Date;
        prevDate: Date;
        startingBal: Decimal;
        closingBal: Decimal;
        creditAmount: Decimal;
        debitAmount: Decimal;
        lastBal: Decimal;
        postingDate: Date;
}