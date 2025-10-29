page 50030 "Fintech Account List"
{
    // version TL2.0

    Caption = ' Accounts';
    CardPageID = "Vendor Card";
    Editable = false;
    InsertAllowed = false;
    UsageCategory = Lists;
    ApplicationArea = All;
    ModifyAllowed = false;
    DeleteAllowed = false;


    PageType = List;
    SourceTable = Vendor;
    //SourceTableView = WHERE("Account Type" = FILTER(<> ''),
    SourceTableView = where(Status = filter(Active), "Vendor Type" = filter('Fintech Account'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }


                field("Phone No."; Rec."Phone No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                }
                field("Net Change"; Rec."Net Change")
                {

                }


                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(OrgCode; Rec.OrgCode)
                {
                    Editable = false;
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {

            /*   action("$Ledger Enties")
               {
                   ApplicationArea = Basic, Suite;
                   Caption = 'Ledger Enties';
                   Ellipsis = true;
                   Image = VendorLedger;
                   Promoted = true;
                   PromotedCategory = Process;
                   PromotedIsBig = true;
                   ToolTip = 'View Ledger Enties';
                   RunObject = page "M Vendor Ledger Entries";
                   RunPageView = sorting("Vendor No.", "Posting Date", "Currency Code") order(descending);
                   RunPageLink = "Vendor No." = field("No.");
               }*/
            /*  action(UpdateIDNo)
             {
                 ApplicationArea = All;
                 Promoted = true;
                 trigger OnAction()
                 var
                     Member: Record Member;
                     Vendor: Record Vendor;
                     Current: Integer;
                     Total: Integer;
                     Progress: Dialog;
                 begin
                     Member.Reset();
                     // Member.SetRange(Status, Member.Status::Active);
                     if Member.FindSet() then begin
                         Progress.Open('Updating accounts\Current: #1###\Total: #2###\Progress: @3@@@');
                         Total := Member.Count;
                         repeat
                             Current += 1;
                             Progress.Update(1, Current);
                             Progress.Update(2, Total);
                             Progress.Update(3, (Current / Total) * 10000 div 1);
                             Vendor.Reset();
                             Vendor.SetRange("Member No.", Member."No.");
                             Vendor.SetRange(Status, Vendor.Status::Active, Vendor.Status::Dormant);
                             if Vendor.FindSet() then begin
                                 repeat
                                     Vendor."ID No" := Member."National ID";
                                     Vendor."Phone No." := Member."Phone No.";
                                     Vendor.Modify();
                                 until Vendor.Next() = 0;
                             end;
                         until Member.Next() = 0;
                         Progress.Close();
                     end;
                 end;
             } */
        }
    }
}

