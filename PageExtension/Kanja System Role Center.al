page 50306 "Kanja System"
{
    PageType = RoleCenter;
    Caption = 'Kanja System Role Center';
    layout
    {

        area(RoleCenter)
        {



            part(Part2; "FOSA Activities")
            {
                Caption = 'STATISTICS';
                ApplicationArea = All;
            }

            /*  part(Control2; "Branch Analysis-Acc Type Chart")
             {

                 ApplicationArea = Basic, Suite;
             } */
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
        }
    }


    actions
    {
        area(Sections)
        {


            group(Setups)
            {
                action("CBSSETUPS")
                {
                    RunObject = page "CBS Setup";
                    ApplicationArea = All;
                    //Visible = false;
                }
                action("Description Setup")
                {
                    RunObject = page DescriptionSetup;
                    ApplicationArea = All;
                }
                action("Enums")
                {
                    RunObject = page KanjaList;
                    ApplicationArea = All;
                    Visible = false;
                }
                action("Document Types")
                {
                    RunObject = page DocumentTypesList;
                    ApplicationArea = All;
                    //Visible = false;
                }

                action(" GenSetup List")
                {
                    RunObject = page "FOSA Setup";
                    ApplicationArea = All;
                    Visible = false;
                }
                action(" Service Type setup")
                {
                    RunObject = page "Service Type List";
                    ApplicationArea = All;
                    // Visible = false;
                }
                action(" Charges setup")
                {
                    RunObject = page "Loan Charge Setup";
                    ApplicationArea = All;
                    // Visible = false;
                }
                action("Settlement Types")
                {
                    RunObject = page settlementCharge;
                    ApplicationArea = All;
                }
                action("Charges List")
                {
                    RunObject = page Charges;
                    ApplicationArea = All;
                    Visible = false;
                }

                action("Account Type List")
                {
                    RunObject = page "Account Type List";
                    ApplicationArea = All;
                    // Visible = false;
                }
                action(County)
                {
                    RunObject = page County;
                    ApplicationArea = All;
                }
                action(BranchCodes)
                {
                    RunObject = page BranchCodes;
                    ApplicationArea = All;
                }
                action(BankDetails)
                {
                    RunObject = page Banks;
                    ApplicationArea = All;
                }
                action(BankBranches)
                {
                    RunObject = page BankBranch;
                    ApplicationArea = All;
                }
            }
            group(Onboarding)
            {
                action("Sacco Application List")
                {
                    RunObject = page "Member Application List";
                    ApplicationArea = All;
                    Caption = 'Application List';
                    //Visible = false;
                }

                action("Sacco  Pending Application List")
                {
                    RunObject = page "Member Pending Approval List";
                    ApplicationArea = All;
                    Caption = 'Application Pending  List';
                    //Visible = false;
                }
                action("Approved Sacco List")
                {
                    RunObject = page "Approved Sacco List";
                    ApplicationArea = All;
                    Caption = 'Application Approved List';
                    // Visible = false;
                }
                action("Rejected Sacco List")
                {
                    RunObject = page "Rejected  Sacco List";
                    ApplicationArea = All;
                    Caption = 'Application Rejected List';
                    // Visible = false;
                }
                action("organisation List")
                {
                    RunObject = page "Organisation List";
                    ApplicationArea = All;
                    Caption = 'Organisation List';

                }
            }

            group(ChangeRequest)
            {
                Caption = 'Change Request';
                action("Change Request")
                {
                    RunObject = page ChangeList;
                    ApplicationArea = All;
                }
                Action("Pending Change Request")
                {
                    RunObject = page PendingChangeList;
                    ApplicationArea = All;
                }
                Action("Approved Change Request")
                {
                    RunObject = page ApprovedChangeList;
                    ApplicationArea = All;
                }
                Action("Rejected Change Request")
                {
                    RunObject = page RejectedChangeList;
                    ApplicationArea = All;
                }


            }
            // group(AccountOpening)
            // {
            //     Caption = 'Account Opening';
            //     action("Account Opening List")
            //     {
            //         RunObject = page "Account Opening List";
            //         ApplicationArea = All;
            //     }

            // }
            group("Member & Member Accounts")
            {
                action("Members")
                {
                    RunObject = page MembersList;
                    ApplicationArea = all;
                }
                action("Member Accounts")
                {
                    RunObject = page "MemberAccounts List";
                    ApplicationArea = All;
                }
            }
            group("Organizations  List")
            {
                Caption = 'Organization Lists';
                action("Sacco List")
                {
                    RunObject = page "Organisation List";
                    ApplicationArea = All;
                }
                action("Fintech List")
                {
                    RunObject = page "Fintech List";
                    ApplicationArea = All;
                }
                action("Partner List")
                {
                    RunObject = page "Partners List";
                    ApplicationArea = All;
                }
                action("Merchant List")
                {
                    RunObject = page "Maerchant List";
                    ApplicationArea = All;
                }
                action("Agent List")
                {
                    RunObject = page "Agent List";
                    ApplicationArea = All;
                }

            }
            group("Float accounts")
            {
                action("Sacco Float Accounts List")
                {
                    RunObject = page "Sacco/MerchantsAccount List";
                    ApplicationArea = All;
                }


                action("Merchant Account List")
                {
                    RunObject = page "Merchants Account List";
                    ApplicationArea = All;
                    //Visible = false;
                }

            }
            group("Commision accounts")
            {

                action("Sacco Accounts")
                {
                    RunObject = page "Sacco Commision acc List";
                    ApplicationArea = All;
                }
                action("Merchant Accounts")
                {
                    RunObject = page "Merchant Commision acc List";
                    ApplicationArea = All;
                }
                action("Fintech Account List")
                {
                    RunObject = page "Fintech Account List";
                    ApplicationArea = All;
                    //Visible = false;
                }
                action("Partner Account List")
                {
                    RunObject = page "Partner Account List";
                    ApplicationArea = All;
                    //Visible = false;
                }

                action("Agent Account List")
                {
                    RunObject = page "Agents Account List";
                    ApplicationArea = All;
                    //Visible = false;
                }
            }
            group("Float Management")
            {
                action("Float Management Entries List")
                {
                    RunObject = page "Float Management Entries List";
                    ApplicationArea = All;
                    Caption = 'Float Management List';
                }
                action("Pending Management Entries List")
                {
                    RunObject = page "Pending Float Entries List";
                    ApplicationArea = All;
                    Caption = 'Pending Float Management List';
                }
                action("Approved Management Entries List")
                {
                    RunObject = page "Approved Float Entries List";
                    ApplicationArea = All;
                    Caption = 'Approved Float Management List';
                }
                action("Posted Management Entries List")
                {
                    RunObject = page "Posted Float Management List";
                    ApplicationArea = All;
                    Caption = 'Posted Float Management List';
                }
            }
            group("Payment Voucher")
            {
                action("New Payment Voucher")
                {
                    RunObject = page "Payment Voucher List";
                }
                action("Pending Payment Voucher")
                {
                    RunObject = page "pending Payment Voucher List";
                    Caption = 'Payment Voucher Pending Approval';
                }
                action("Approved Payment Voucher")
                {
                    RunObject = page "Approved Payment Voucher";
                    Caption = 'Approved Payment Voucher';
                }
                action("Posted Payment Voucher")
                {
                    RunObject = page "Posted Payment Voucher";
                    Caption = 'Posted Payment Voucher';
                }
            }

            group("Receipt Vouchers")
            {
                action("Receipt Voucher List")
                {
                    RunObject = page " New Receipt lines List";
                }
                action("Pending Receipt Voucher")
                {
                    RunObject = page " Pending Receipt lines List";
                    Caption = 'Receipt Voucher Pending Approval';
                }
                action("Approved Receipt Voucher")
                {
                    RunObject = page " Approved Receipt lines List";
                    Caption = 'Approved Receipt Voucher';
                }
                action("Posted Receipt Voucher")
                {
                    RunObject = page " posted Receipt lines List";
                    Caption = 'Posted Receipt Voucher';
                }

            }

            group(Entries)
            {

                action("Posted Float Management  List")
                {
                    RunObject = page "Posted Float Management List";
                    ApplicationArea = All;
                    // Visible = false;
                }
                action("Sacco Transcation Entries")
                {
                    RunObject = page "Sacco Transcation  List";
                    ApplicationArea = All;
                    Caption = 'Sacco Transcation List';

                }

                action("Settlement Entries")
                {
                    RunObject = page settlementEntries;
                    ApplicationArea = All;
                    Caption = 'Settlement Entries List';
                }
                action("Posted Settlement")
                {
                    RunObject = page postedSettlementEntries;
                    ApplicationArea = All;
                    // Visible = false;
                }
                action("Merchant Transcation Entries")
                {
                    RunObject = page "Merchant Transcation  List";
                    ApplicationArea = All;
                    Caption = 'Merchant Transcation List';

                }
                action("Posted Sacco Transcation List")
                {
                    RunObject = page "Posted Sacco Transcation  List";
                    ApplicationArea = All;
                    // Visible = false;
                }
                action("Charges Detail List")
                {
                    RunObject = page "Charges Entries Details";
                    ApplicationArea = All;
                    // Visible = false;
                }

            }
            group(Reports)
            {
                action("Statement Report")
                {
                    RunObject = report entityStatement;
                    ApplicationArea = All;
                }

            }


        }
        area(Creation)
        {

            action(NewSaccoApplication)
            {
                Caption = 'New Sacco Application';
                Image = NewInvoice;
                RunObject = Page "Member Application List";
                RunPageMode = Create;
                ApplicationArea = All;
            }

            action(FloatManagment)
            {
                Caption = 'New Float Management Application';
                Image = NewInvoice;
                RunObject = Page "Float Management Entries List";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(PaymentVoucher)
            {
                Caption = 'New Payment Voucher';
                Image = NewInvoice;
                RunObject = Page "Payment Voucher List";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(Receipt)
            {
                Caption = 'New Receipt ';
                Image = NewInvoice;
                RunObject = Page "Receipt Lines";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(BankAccounts)
            {
                Caption = 'New Bank Accounts ';
                Image = NewInvoice;
                RunObject = Page "Bank Account List";
                RunPageMode = Create;
                ApplicationArea = All;
            }






        }
    }
}











// Creates a sub-menu

