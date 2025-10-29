page 50002 "Account Opening List"
{
    // version TL2.0

    Caption = 'New Account Openings';
    CardPageID = "Account Opening Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Related Information,Approval Request,Comments,Category 7,Category 8';
    SourceTable = "Account Opening";
    SourceTableView = WHERE(Status = FILTER(New));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; REC."Account Type")
                {
                    ApplicationArea = All;
                }
                field(Description; REC.Description)
                {
                    ApplicationArea = All;
                }
                field("Sacco No."; Rec."Sacco No.")
                {
                    ApplicationArea = All;
                }
                field("Sacco Name"; Rec."Sacco Name")
                {
                    ApplicationArea = All;
                }

                field(Status; REC.Status)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';
                Visible = false;

                trigger OnAction()
                var
                //ApprovalsMgmt: Codeunit "1535";
                begin
                    /*  IF ApprovalsMgmt.CheckAccountOpeningApprovalPossible(Rec) THEN
                         ApprovalsMgmt.OnSendAcccountOpeningForApproval(Rec); */
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';
                Visible = false;

                trigger OnAction()
                var
                    //ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    //  ApprovalsMgmt.OnCancelAccountOpeningApprovalRequest(Rec);
                    //  WorkflowWebhookMgt.FindAndCancel(RECORDID);
                end;
            }
        }
        area(navigation)
        {

            action(Comments)
            {
                Caption = 'Comments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'View or add comments for the record.';

                trigger OnAction()
                var
                    //ApprovalsMgmt: Codeunit "1535";
                    RecRef: RecordRef;
                begin
                    ApprovalCommentLine.FILTERGROUP(10);
                    ApprovalCommentLine.SETRANGE("Document No.", Rec."No.");
                    ApprovalCommentLine.FILTERGROUP(0);
                    ApprovalComments.SETTABLEVIEW(ApprovalCommentLine);
                    ApprovalComments.EDITABLE(FALSE);
                    ApprovalComments.RUN;
                end;
            }
        }
    }

    var
        //ApprovalsMgmt: Codeunit "1535";
        ApprovalCommentLine: Record "Approval Comment Line";
        ApprovalComments: Page "Approval Comments";

}

