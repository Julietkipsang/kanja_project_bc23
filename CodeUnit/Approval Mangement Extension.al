codeunit 50044 "Approvals Mgnt Ext"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var

        PV: Record "Payment/Receipt Voucher";
        SaccoApplication: Record "Sacco Application";
        ChangeRequest: Record ChangeRequest;
        FloatMangement: Record "Float Management";

    begin
        case RecRef.Number of
            Database::"Payment/Receipt Voucher":
                begin
                    RecRef.SetTable(PV);
                    PV.CalcFields("Net Amount");
                    ApprovalEntryArgument."Document No." := pv."Paying Code.";
                    ApprovalEntryArgument.Amount := PV."Net Amount";
                    ApprovalEntryArgument."Amount (LCY)" := PV."Net Amount";
                end;
            DATABASE::"Sacco Application":
                begin
                    RecRef.SETTABLE(SaccoApplication);
                    ApprovalEntryArgument."Document No." := SaccoApplication."No.";
                end;
            DATABASE::ChangeRequest:
                begin
                    RecRef.SETTABLE(ChangeRequest);
                    ApprovalEntryArgument."Document No." := ChangeRequest."No.";
                end;
            DATABASE::"Float Management":
                begin
                    RecRef.SETTABLE(FloatMangement);
                    ApprovalEntryArgument."Document No." := FloatMangement."Receipt No";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        PV: Record "Payment/Receipt Voucher";
        SaccoApplication: Record "Sacco Application";
        ChangeRequest: Record ChangeRequest;
        FloatMangement: Record "Float Management";

    begin
        case RecRef.Number of

            Database::"Payment/Receipt Voucher":
                begin
                    RecRef.SetTable(PV);
                    PV.Validate(Status, PV.Status::"Pending Approval");
                    PV.Modify(true);
                    Variant := PV;
                    IsHandled := true;
                end;
            DATABASE::"Sacco Application":
                begin
                    RecRef.SetTable(SaccoApplication);
                    SaccoApplication.Status := SaccoApplication.Status::"Pending Approval";
                    SaccoApplication."Created By" := UserId;
                    SaccoApplication."Created Date" := Today;
                    SaccoApplication."Created Time" := Time;
                    SaccoApplication.Modify(true);
                    isHandled := true;
                end;
            DATABASE::ChangeRequest:
                begin
                    RecRef.SetTable(ChangeRequest);
                    ChangeRequest.Status := ChangeRequest.Status::"Pending Approval";
                    ChangeRequest."Created By" := UserId;
                    ChangeRequest."Created Date" := Today;
                    ChangeRequest."Created Time" := Time;
                    ChangeRequest.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Float Management":
                begin
                    RecRef.SetTable(FloatMangement);
                    FloatMangement.Status := FloatMangement.Status::"Pending Approval";
                    FloatMangement."Created By" := UserId;
                    FloatMangement."Created Date" := Today;
                    FloatMangement.Modify(true);
                    isHandled := true;
                end;



        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        SaccoApplication: Record "Sacco Application";
        ChangeRequest: Record ChangeRequest;
        FloatManagement: Record "Float Management";
    begin
        CASE ApprovalEntry."Table ID" OF
            DATABASE::"Sacco Application":
                begin
                    SaccoApplication.Get(ApprovalEntry."Document No.");
                    SaccoApplication.Status := SaccoApplication.Status::Rejected;
                    SaccoApplication.Modify(true);
                    // ReleaseFOSADocument.RejectMemberApplication(MemberApplication);
                end;
            DATABASE::ChangeRequest:
                begin
                    ChangeRequest.Get(ApprovalEntry."Document No.");
                    ChangeRequest.Status := ChangeRequest.Status::Rejected;
                    ChangeRequest.Modify(true);
                    // ReleaseFOSADocument.RejectMemberApplication(MemberApplication);
                end;
            DATABASE::"Float Management":
                begin
                    FloatManagement.Get(ApprovalEntry."Document No.");
                    FloatManagement.Status := FloatManagement.Status::Rejected;
                    FloatManagement.Modify(true);
                    // ReleaseFOSADocument.RejectMemberApplication(MemberApplication);
                end;
        end;
    end;
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnStatusChange', 'ElementName',false,false)]
    local procedure InformUserOnStatusChange(var Variant: Variant; WorkflowInstanceId: GUID)
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPVForApproval(var PV: Record "Payment/Receipt Voucher")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnSendChangeRequestForApproval(VAR ChangeRequestHeader: Record ChangeRequest);
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPVApprovalRequest(var PV: Record "Payment/Receipt Voucher")
    begin
    end;

    procedure IsPVDocApprovalsWorkflowEnabled(var PV: Record "Payment/Receipt Voucher"): Boolean
    begin
        //exit(WorkflowManagement.CanExecuteWorkflow(PV, WorkflowEventHandlingExt.RunWorkflowOnSendPVDocForApprovalCode));
    end;

    procedure CheckPVApprovalPossible(var PV: Record "Payment/Receipt Voucher"): Boolean
    begin
        if not IsPVDocApprovalsWorkflowEnabled(pv) then begin
            Error(NoWorkflowEnabledErr);
        end else begin
            exit(true);
        end;
    end;



    procedure CheckPVDocApprovalsWorkflowEnabled(var PV: Record "Payment/Receipt Voucher"): Boolean
    begin

    end;

    [EventSubscriber(ObjectType::Page, Page::"Workflow Responses", 'OnAfterGetRecordEvent', '', true, true)]
    local procedure Workflow_Responses2(var Rec: Record "Workflow Response")
    begin
        //Message('OnAfterGetCurrRecordEvent  Independent.......%1.....Function Name...%2......Description....%3.....Table ID...%4', Rec.Independent, Rec."Function Name", Rec.Description, Rec."Table ID");
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendSaccoApplicationForApproval(var SaccoApplication: Record "Sacco Application")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnSendFloatApplicationForApproval(var FloatApplication: Record "Float Management")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelSaccoApplicationApprovalRequest(var saccoApplication: Record "Sacco Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelFloatApplicationApprovalRequest(var FloatApplication: Record "Float Management")
    begin
    end;


    procedure CheckSaccoApplicationApprovalPossible(var SaccoApplication: Record "Sacco Application"): Boolean
    begin
        IF NOT IsSaccoApplicationApprovalsWorkflowEnabled(SaccoApplication) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsSaccoApplicationApprovalsWorkflowEnabled(var SaccoApplication: Record "Sacco Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(SaccoApplication, WorkflowEventHandlingExt.RunWorkflowOnSendSaccoApplicationForApprovalCode()));
    end;

    procedure CheckFloatApplicationApprovalPossible(var FloatApplication: Record "Float Management"): Boolean
    begin
        IF NOT IsFloatApplicationApprovalsWorkflowEnabled(FloatApplication) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsFloatApplicationApprovalsWorkflowEnabled(var FloatApplication: Record "Float Management"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(FloatApplication, WorkflowEventHandlingExt.RunWorkflowOnSendFloatApplicationForApprovalCode()));
    end;

    procedure CheckChangeRequestHeaderApprovalPossible(VAR ChangeRequestHeader: Record ChangeRequest): Boolean;
    begin
        IF NOT IsChangeRequestHeaderWorkflowEnabled(ChangeRequestHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure IsChangeRequestHeaderWorkflowEnabled(VAR ChangeRequestHeader: Record ChangeRequest): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ChangeRequestHeader, WorkflowEventHandlingExt.RunWorkflowOnSendChangeRequestHeaderForApprovalCode));
    end;


    var
        PendingApprovalmsg: Label 'An Apporval request has been sent to your immediate approver';
        DocStatusChangedMsg: Label '%1 %2 has been automatically approved. The status has been changed to %3.';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';

        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext";

}