page 50022 "ChangeList"
{
    // version TL2.0

    Caption = 'New Change List';
    CardPageID = ChangeCard;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Related Information,Approval Request,Comments,Category 7,Category 8';
    SourceTable = ChangeRequest;
    SourceTableView = WHERE(Status = FILTER(New));
    //, Type = filter(Merchant));
    //Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(OrgCode; Rec.OrgCode)
                {

                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = all;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }


            }
        }
    }

    actions
    {
        area(processing)
        {


        }
        area(navigation)
        {


        }
    }

    var
        //ApprovalsMgmt: Codeunit "1535";
        ApprovalCommentLine: Record "Approval Comment Line";
        ApprovalComments: Page "Approval Comments";

}

