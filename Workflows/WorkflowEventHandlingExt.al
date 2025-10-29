codeunit 50011 "Workflow Event Handling Ext"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendSaccoApplicationForApprovalCode(), Database::"Sacco Application", SaccoApplicationSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelSaccoApplicationForApprovalCode(), Database::"Sacco Application", SaccoApplicationApprReqCancelledEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseSaccoApplicationForApprovalCode(), Database::"Sacco Application", SaccoApplicationReleasedEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendChangeRequestHeaderForApprovalCode, DATABASE::ChangeRequest, ChangeRequestHeaderSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelChangeRequestHeaderApprovalRequestCode, DATABASE::ChangeRequest, ChangeRequestHeaderCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterReleaseChangeRequestHeaderApprovalRequestCode, DATABASE::ChangeRequest, ChangeRequestHeaderReleasedEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendFloatApplicationForApprovalCode(), Database::"Float Management", FloatApplicationSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelFloatApplicationForApprovalCode(), Database::"Float Management", FloatApplicationApprReqCancelledEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseFloatApplicationForApprovalCode(), Database::"Float Management", FloatApplicationReleasedEventDescTxt, 0, false);

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelSaccoApplicationForApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelSaccoApplicationForApprovalCode, RunWorkflowOnCancelSaccoApplicationForApprovalCode);
            RunWorkflowOnCancelFloatApplicationForApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelFloatApplicationForApprovalCode, RunWorkflowOnCancelFloatApplicationForApprovalCode);
            RunWorkflowOnCancelChangeRequestHeaderApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelChangeRequestHeaderApprovalRequestCode, RunWorkflowOnSendChangeRequestHeaderForApprovalCode);
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendSaccoApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendFloatApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendChangeRequestHeaderForApprovalCode);
                end;

            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendSaccoApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendFloatApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendChangeRequestHeaderForApprovalCode);

                end;
            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendSaccoApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendFloatApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendChangeRequestHeaderForApprovalCode);
                end;
        end;
    end;

    procedure RunWorkflowOnSendSaccoApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendSaccoApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendFloatApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendFloatApplicationForApproval'));
    end;

    procedure RunWorkflowOnCancelSaccoApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelSaccoApplicationForApproval'));
    end;

    procedure RunWorkflowOnCancelFloatApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelFloatApplicationForApproval'));
    end;

    procedure RunWorkflowOnReleaseSaccoApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseSacccoApplicationForApproval'));
    end;

    procedure RunWorkflowOnReleaseFloatApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseFloatApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendChangeRequestHeaderForApprovalCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendChangeRequestHeaderForApproval'));
    end;

    procedure RunWorkflowOnCancelChangeRequestHeaderApprovalRequestCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelChangeRequestHeaderApprovalRequest'));
    end;

    procedure RunWorkflowOnAfterReleaseChangeRequestHeaderApprovalRequestCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseChangeRequestHeader'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgnt Ext", 'OnSendSaccoApplicationForApproval', '', false, false)]
    procedure RunWorkflowOnSendSaccoApplicationForApproval(var SaccoApplication: Record "Sacco Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendSaccoApplicationForApprovalCode, SaccoApplication);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgnt Ext", 'OnSendChangeRequestForApproval', '', false, false)]
    procedure RunWorkflowOnSendChangeRequestHeaderForApproval(var ChangeRequestHeader: Record ChangeRequest);
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendChangeRequestHeaderForApprovalCode, ChangeRequestHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgnt Ext", 'OnSendFloatApplicationForApproval', '', false, false)]
    procedure RunWorkflowOnSendFloatApplicationForApproval(var FloatApplication: Record "Float Management")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendFloatApplicationForApprovalCode, FloatApplication);

    end;





    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        SaccoApplicationSendForApprovalEventDescTxt: Label 'Approval of a sacco Application is requested.';
        SaccoApplicationApprReqCancelledEventDescTxt: Label 'An approval request for a sacco Application is canceled.';
        SaccoApplicationReleasedEventDescTxt: Label 'A Sacco Application is released.';
        ChangeRequestHeaderSendForApprovalEventDescTxt: Label 'Approval of a Change Request Header is requested.';
        ChangeRequestHeaderCancelledEventDescTxt: Label 'An approval request for a Change Request Header is cancelled.';
        ChangeRequestHeaderReleasedEventDescTxt: Label 'A Change Request Header is released.';
        FloatApplicationSendForApprovalEventDescTxt: Label 'Approval of a Float Management is requested.';
        FloatApplicationApprReqCancelledEventDescTxt: Label 'An approval request for a Float Management is canceled.';
        FloatApplicationReleasedEventDescTxt: Label 'A Float Management is released.';









}

