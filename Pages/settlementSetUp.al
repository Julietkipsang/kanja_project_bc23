page 50085 settlementSetup
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = SettlementTypeCharges;

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
                field(Type; Rec.Type)
                {

                }
                field(settlementDescription; Rec.settlementDescription)
                {

                }
                field("Calculation Method"; Rec."Calculation Method")
                {

                }
                field(Value; Rec.Value)
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
            action("Ranges")
            {


                Image = Ranges;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = true;
                RunObject = Page settlementChargesList;
                RunPageLink = settlementTypes = field(settlementTypes);
                trigger OnAction()
                begin


                end;



            }
            // action("PercentageSetup")
            // {


            //     Image = Percentage;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ApplicationArea = All;
            //     Visible = true;
            //     RunObject = Page percentChargesList;
            //     RunPageLink = settlementTypes = field(settlementTypes);
            //     trigger OnAction()
            //     begin


            //     end;



            // }
        }
    }
}