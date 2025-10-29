page 50037 "MemberAccounts List"
{
    // version TL2.0

    Caption = ' Accounts';
    CardPageID = "Vendor Card";
    // Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    // ModifyAllowed = false;
    PageType = List;
    SourceTable = Vendor;
    //SourceTableView = WHERE("Account Type" = FILTER(<> ''),
    //Status = filter(Active)
    SourceTableView = where("Vendor Type" = filter('Member Account'));

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


                field("Vendor Posting Group"; Rec."Vendor Posting Group")
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

        }
    }
}

