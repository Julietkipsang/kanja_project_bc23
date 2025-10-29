page 50036 "Loan Charge Setup"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Loan Charge Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    ApplicationArea = All;
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

