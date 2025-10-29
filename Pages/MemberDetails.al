page 50038 MemberDetails
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = MemberDetails;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(MemberNo; Rec.MemberNo)
                {

                }
                field(EntityCode; Rec.EntityCode)
                {
                    ApplicationArea = All;

                }
                field(PhoneNo; Rec.PhoneNo)
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