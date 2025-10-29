page 50060 "Payment Vouchers"
{
    Caption = 'Payment Voucher';
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Payment/Receipt Voucher";
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Paying Code."; rec."Paying Code.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Date"; rec."Payment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Payment Mode"; rec."Payment Mode")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                group("Member Details")
                {
                    Visible = rec."Payment Mode" = rec."Payment Mode"::FOSA;
                    // field("Member No."; "Member No.")
                    // {
                    //     ApplicationArea = All;
                    //     ShowMandatory = true;
                    // }
                    // field("Member Name"; "Member Name")
                    // {
                    //     ApplicationArea = All;
                    //     ShowMandatory = true;
                    // }
                }
                field("Paying Bank"; rec."Paying Bank")
                {
                    Caption = 'Paying Account No.';
                    ApplicationArea = All;
                }
                field("Paying/Receiving Bank Name"; rec."Paying/Receiving Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Paying Account Name';
                    Editable = false;
                }
                field("Account Type"; rec."Account Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Account No."; rec."Account No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payee Name"; Rec."Payee Name")
                {
                    ApplicationArea = All;
                    // Visible = false;
                }
                group("")
                {
                    Visible = rec."Payment Mode" = rec."Payment Mode"::Cheque;
                    field("Cheque No."; rec."Cheque No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Cheque Date"; rec."Cheque Date")
                    {
                        ApplicationArea = All;

                    }
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Net Amount"; rec."Net Amount")
                {
                    ApplicationArea = All;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Next Approver"; rec."Next Approver")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
            }
            part("PV Lines"; "PV Lines")
            {
                Caption = 'Payment Lines';
                ApplicationArea = All;
                SubPageLink = Code = FIELD("Paying Code.");
            }

        }
    }

    actions
    {
        area(processing)
        {

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    trigger OnAction();
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                // action("Re-Open Payment Voucher")
                // {
                //     //Visible = Status = Status::Released;
                //     // Visible = Posted = false;
                //     ApplicationArea = All;
                //     Caption = 'Re-Open Payment Voucher';
                //     Image = ReopenPeriod;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     ToolTip = 'Re-Open Payment Voucher';
                //     trigger OnAction();
                //     begin
                //         //TestField(Posted, false);
                //         // PaymentReceiptProcessing.ReOpenPaymentReceipt(Rec);
                //     end;
                // }

                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
                  action(Post)
                {
                    Image = PostApplication;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Visible = PostingPV;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction();
                    begin
                        
                        if Confirm('Do you want to post the PV') then begin
                            paymentVoucher.postPaymentVoucher(Rec);
                            Message('Posted Successfully');
                            CurrPage.Close();
                        end;
                    end;
                }

            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
        IF rec.Status <> rec.Status::Open THEN BEGIN
            CanRequestApprovalForFlow := FALSE;
        END;
        IF rec.Status = rec.Status::Open THEN BEGIN
            ModifyFields := TRUE;
        END;
        if Rec.Status = Rec.Status::Released then begin
            if Rec.Posted = false then begin

                PostingPV := true;
            end;
        end;

    end;

    trigger OnModifyRecord(): Boolean;
    begin
      
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
  
    end;

    trigger OnOpenPage();
    begin
        
        if Rec.Posted = true then begin
            PostingPV := false;
        end;
    end;

    var
       
        paymentVoucher: Codeunit PaymentVoucher;
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForFlow: Boolean;
        Archived: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        ModifyFields: Boolean;
        //PaymentRemittanceAdvise : Report "50441";
        PostingPV: Boolean;
        //Cheque: Page "Cheque Detials Dialog";
        IsCheque: Boolean;
}

//