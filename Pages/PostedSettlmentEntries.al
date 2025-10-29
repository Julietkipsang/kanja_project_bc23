page 50059 postedSettlementEntries
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = SettlementTable;
    SourceTableView = sorting("Receipt No") order(descending) where(Posted = const(true));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Receipt No"; Rec."Receipt No")
                {
                    ApplicationArea = All;

                }
                field(sourceAccountNumber; Rec.sourceAccountNumber)
                {


                }
                field(toAccountNumber; Rec.toAccountNumber)
                {

                }
                field(paybillNumber; Rec.paybillNumber)
                {

                }
                field(Types; Rec.Types)
                {

                }
                field("Received Amount"; Rec."Received Amount")
                {

                }
                field(transactionDescription; Rec.transactionDescription)
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