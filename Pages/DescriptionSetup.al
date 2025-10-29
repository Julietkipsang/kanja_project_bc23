page 50025 DescriptionSetup
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = DescriptionSetUp;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(DocumentSource; Rec.DocumentSource)
                {
                    ApplicationArea = All;

                }
                field(Description; rec.Description)
                {

                }
                field(ResponseCode; Rec.ResponseCode)
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