page 50014 BankBranch
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bank Branch";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

               field(Banks;Rec.Banks)
               {
                    ApplicationArea = All; 
               }
               
                field(Codes;Rec.Codes)
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