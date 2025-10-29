page 50049 Paybill
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Paybill;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(paybillNo; Rec.paybillNo)
                {
                    ApplicationArea = All;

                }
               //  field(accountNo; Rec.accountNo)
               //  {

               //  }
                field(paybillName; Rec.paybillName)
                {

                }
            }
        }
        // area(Factboxes)
        // {

        // }
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