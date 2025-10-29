page 50051 "Payment Voucher"
{
    // version TL2.0

    SourceTable = "Payment/Receipt Voucher";
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Paying Code."; Rec."Paying Code.")
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
                    Visible = rec."Payment Mode" = Rec."Payment Mode"::FOSA;

                }
                field("Paying Bank"; Rec."Paying Bank")
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
                field("Payee Name"; rec."Payee Name")
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
                    field("Cheque Date"; Rec."Cheque Date")
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


            action(SendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgnt Ext";
                begin
                    // IF ApprovalsMgmt.CheckPVApprovalPossible(Rec) THEN BEGIN
                    if Confirm('Do you want to send the record for approval') then begin
                        ApprovalsMgmt.OnSendPVForApproval(Rec);
                        // Message('Sent Successfully for approval');
                        CurrPage.Close();
                    end;
                    //  END;
                end;
            }
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
                    if Confirm('Do you want to approve the record') then begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        Message('Approved Successfully');
                        CurrPage.Close();
                    end;
                end;
            }

            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgnt Ext";
                    WorkflowWebhookMgt: Codeunit "Approvals Mgmt.";
                begin
                    if Confirm('Do you want to cancel approval') then begin
                        ApprovalsMgmt.OnCancelPVApprovalRequest(Rec);
                        Message('Cancelled Succesffully');
                        CurrPage.Close();
                    end;
                end;
            }
            // action("&Preview Posting")
            // {
            //     Image = ViewPostedOrder;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ApplicationArea = All;
            //     ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';
            //     trigger OnAction();
            //     begin
            //         // paymentVoucher.postPaymentVoucher(Rec);
            //         //  PaymentReceiptProcessing.PostingPaymentVoucher(Rec, true);

            //     end;
            // }
            // action(Archive)
            // {
            //     Visible = Archived;
            //     Image = Archive;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ApplicationArea = All;
            //     trigger OnAction();
            //     begin
            //         Rec.TestField(Posted, false);
            //         // PaymentReceiptProcessing.ArchivePaymentVoucher(Rec);
            //         CurrPage.Close();
            //     end;
            // }
            // action(Print)
            // {
            //     Image = Print;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ApplicationArea = Basic, Suite;
            //     trigger OnAction();
            //     begin
            //         // Rec.SETRANGE("Paying Code.", "Paying Code.");
            //         REPORT.RUN(50440, TRUE, TRUE, Rec);
            //     end;
            // }
        }




    }

    trigger OnAfterGetRecord();
    begin
        //  OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
        IF Rec.Status <> Rec.Status::Open THEN BEGIN
            CanRequestApprovalForFlow := FALSE;
        END;
        IF rec.Status = rec.Status::Open THEN BEGIN
            ModifyFields := TRUE;
        END;
        if Rec.Status = Rec.Status::"Pending Approval" then begin
            OpenApprovalEntriesExistForCurrUser := true;
        end;
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        IF rec.Status <> rec.Status::Open THEN BEGIN
            IF CanRequestApprovalForFlow = TRUE THEN BEGIN
                CanRequestApprovalForFlow := FALSE;
            END;
            CurrPage.EDITABLE(FALSE);
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        rec."Line type" := rec."Line type"::Payment;
        rec."Document Type" := rec."Document Type"::"Payment Voucher";
    end;

    trigger OnOpenPage();
    begin
        CanRequestApprovalForFlow := TRUE;
        IF rec.Status <> rec.Status::Open THEN BEGIN
            CanRequestApprovalForFlow := FALSE;
            CurrPage.EDITABLE(FALSE);
        END;
        IF rec.Status = rec.Status::Released THEN BEGIN
            IF rec.Posted = FALSE THEN BEGIN
                PostingPV := TRUE;
            END;
        END;
        Archived := true;
        if (rec.Posted) or (rec.Status = rec.Status::Archived) then begin
            Archived := false;
        end;

    end;

    var
        paymentVoucher: Codeunit PaymentVoucher;
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;
        Archived: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForFlow: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        ModifyFields: Boolean;
        //PaymentRemittanceAdvise : Report "50441";
        PostingPV: Boolean;
}

