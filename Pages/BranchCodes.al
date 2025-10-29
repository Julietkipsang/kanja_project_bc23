page 50015 BranchCodes
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = BranchCodes;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Codes; Rec.Codes)
                {
                    ApplicationArea = All;

                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ApplicationArea = All;

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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}