page 50086 settlementCharge
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Transaction Types Card";
    SourceTable = "Settlement Charges";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(settlementTypes; Rec.settlementTypes)
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
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