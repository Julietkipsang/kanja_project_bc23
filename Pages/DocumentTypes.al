page 50027 DocumentTypesList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = DocumentTypesSetup;

    layout
    {
        area(Content)
        {
            repeater(DocumentsList)
            {

                field(Nos; Rec.Nos)
                {

                }

                field(EntityType; Rec.EntityType)
                {
                    ApplicationArea = All;

                }
                // field(DocumentType; Rec.DocumentType)
                // {
                //     ApplicationArea = All;

                // }
                // field(DocumentDescription; Rec.DocumentDescription)
                // {
                //     ApplicationArea = All;

                // }
                // field(RequiresAttachment; Rec.RequiresAttachment)
                // {
                //     ApplicationArea = All;

                // }


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
            action(DocumentTypes)
            {
                ApplicationArea = All;
                Image = Select;
                RunObject = page DocumentsList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunPageLink = codes = field(Nos);
                trigger OnAction()
                begin



                end;
            }
        }
    }
}