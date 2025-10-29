page 50004 "Account Type List"
{
    // version TL2.0

    Caption = 'Account Types';
    CardPageID = "Account Type Card";
    PageType = List;
    SourceTable = "Account Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field(Type; Rec.Type)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account Prefix"; Rec."Account Prefix")
                {
                    Editable = false;
                    ApplicationArea = All;
                }


                field("Posting Group"; Rec."Posting Group")
                {
                    Editable = false;
                    ApplicationArea = All;
                }



            }
        }
    }

    actions
    {
    }
}

