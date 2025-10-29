page 50013 Banks
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Banks;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    // Editable = false;

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;

                }
                field(paybillNumber; Rec.paybillNumber)
                {

                }


            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Branch Codes")
            {
                ApplicationArea = All;
                RunObject = page BranchCodes;
                RunPageLink = BranchCode = field("No.");
                trigger OnAction()
                begin


                end;
            }
        }
    }
}