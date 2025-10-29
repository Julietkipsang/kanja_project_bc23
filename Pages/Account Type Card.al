page 50003 "Account Type Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Account Type";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Account Prefix"; Rec."Account Prefix")
                {
                    ApplicationArea = All;
                }

                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Open Automatically"; Rec."Open Automatically")
                {

                }



                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = All;
                }


            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

    end;

    var

}

