page 50089 "Float Management Card"
{
    PageType = Card;
    // ApplicationArea = All;
    // UsageCategory = Lists;
    SourceTable = "Float Management";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'Float Details';
                field("Receipt No"; Rec."Receipt No")
                {
                    ApplicationArea = All;

                }
                field("Associated Bank Account"; Rec."Associated Bank Account")
                {

                }
                field("Sacco Code"; Rec."Sacco Code")
                {
                    Caption = 'Entity Code';

                }
                field("Sacco No"; Rec."Sacco No")
                {

                    Caption = 'Account No';
                }
                field("Received Amount"; Rec."Received Amount")
                {

                }
                field("Sacco Name"; Rec."Sacco Name")
                {

                }
                field("Transaction Description"; Rec."Transaction Description")
                {

                }


            }
            group("Audit Trail")
            {

                field("Created By"; Rec."Created By")
                { }
                field("Approved By"; Rec."Approved By")
                { }
                field("Approved Date"; Rec."Approved Date")
                { }
                field("Approved Time"; Rec."Approved Time")
                { }

                field("Posted By"; Rec."Posted By")
                { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SendApprovalRequest)
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = isSend;
                ToolTip = 'Request approval of the document.';


                trigger OnAction()
                var

                    ShowSuccessResetStatusMsg: Label 'Status has been reset successfully';
                    FosaSetup: Record "FOSA Setup";
                    ConfirmSendApprovalText: Label 'Do you wish to submit this application for approval?';
                    ShowSuccessSendApproval: Label 'The application has been sent for approval';

                begin
                    Rec.TestField("Received Amount");
                    rec.TestField("Sacco Code");
                    Rec.TestField("Associated Bank Account");
                    if Confirm(ConfirmSendApprovalText) then begin
                        if ApprovalsMgmt.CheckFloatApplicationApprovalPossible(Rec) then
                            ApprovalsMgmt.OnSendFloatApplicationForApproval(Rec);
                    end;
                    Message(ShowSuccessSendApproval);

                    // if Confirm(ConfirmSendApprovalText) then begin
                    //     Rec.Status := Rec.Status::"Pending Approval";
                    //     Rec."Created By" := UserId;
                    //     Rec."Created Date" := Today;
                    //     Rec.Modify();
                    //     Message(ShowSuccessSendApproval);
                    // end;
                end;
            }
            action(ResetStatus)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reset Status';
                Image = ResetStatus;
                Promoted = true;
                Visible = isReset;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ConfirmResetStatusMsg: Label 'Are you sure you want to Reset the status of this application?';
                    ShowSuccessResetStatusMsg: Label 'Status has been reset successfully';
                    ConfirmSendApprovalText: Label 'Do you wish to submit this application for approval?';
                begin
                    if Confirm(ConfirmResetStatusMsg) then begin
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                        Message(ShowSuccessResetStatusMsg);

                    end;
                end;
            }
            action(Approve)
            {
                ApplicationArea = Suite;
                Caption = 'Approve & Post';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsApprove;
                Scope = Repeater;
                ToolTip = 'Approve the requested changes.';

                trigger OnAction()
                var
                    ConfirmApproveMsg: Label 'Are you sure you want to Approve this application?';
                    ShowSuccessSendApproval: Label 'The Request has Been Approved SuccessFully';
                    ShowCannotApproveErr: Label 'You cannot approve this application request!';
                    NoApproverCommentErr: Label 'Please fill in the Approver Comments!';
                    // FosaManagement: Codeunit "FOSA Management";
                    FloatManagement: Codeunit "FOSA Management";

                begin
                    if Confirm(ConfirmApproveMsg) then begin
                        ApprovalMgt.ApproveRecordApprovalRequest(Rec.RecordId);
                        // Rec.Status := Rec.Status::Approved;
                        // rec."Approved By" := UserId;
                        // rec."Approved Date" := Today;
                        // rec."Approved Time" := Time;
                        // Rec.Modify();
                        // Message(ShowSuccessSendApproval);
                        if Rec.Posted = true then
                            Error('This Document has been Posted');
                        FloatManagement.Deletejournline();
                        FloatManagement.PostToAccount(Rec);
                        Rec.Posted := true;
                        Rec.Status := Rec.Status::Posted;
                        rec."Posted By" := UserId;
                        if Rec.Modify(true) then
                            Message('Approved and Posted Successfully');
                    end;

                end;

            }
            action(DocAttach)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GETTABLE(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RUNMODAL;
                end;
            }


            action("Post Transcation")
            {
                Caption = 'Post Transcation';
                Image = ApplyEntries;
                Promoted = true;
                Visible = false;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Post Transcation ';
                trigger OnAction()
                var
                    FloatManagement: Codeunit "FOSA Management";
                begin
                    if Rec.Posted = true then
                        Error('This Document has been Posted');
                    FloatManagement.Deletejournline();
                    FloatManagement.PostToAccount(Rec);
                    Rec.Posted := true;
                    Rec.Status := Rec.Status::Posted;
                    rec."Posted By" := UserId;
                    if Rec.Modify(true) then
                        Message('Posted Successfully');
                end;
            }
        }
    }
    var
        isSend: Boolean;
        IsApprove: Boolean;
        isPost: Boolean;
        isReset: Boolean;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmt: Codeunit "Approvals Mgnt Ext";


    procedure Visibility()
    begin
        if Rec.Status = Rec.Status::Open then begin
            isSend := true;


        end;
        if Rec.Status = Rec.Status::"Pending Approval" then begin
            IsApprove := true;
            isReset := true;
            Editable := false;

        end;
        if Rec.Status = Rec.Status::Approved then begin
            isPost := true;
            Editable := false;

        end;
    end;

    trigger
    OnOpenPage()
    begin
        Visibility();
    end;


}
