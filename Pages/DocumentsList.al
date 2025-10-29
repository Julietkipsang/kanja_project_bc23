page 50026 DocumentsList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = DocumentTypes;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(DocumentType; Rec.DocumentType)
                {
                    ApplicationArea = All;

                }

                field(DocumentDescription; Rec.DocumentDescription)
                {
                    ApplicationArea = All;

                }

                field(RequiresAttachment; Rec.RequiresAttachment)
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