page 50035 KanjaList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = KanjaSetUps;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Type; Rec.Type)
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