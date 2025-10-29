codeunit 50012 WorflowResponseHandling
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])

    begin
        CASE ResponseFunctionName OF
            WorkflowResponseHandling.SetStatusToPendingApprovalCode():
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendSaccoApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendFloatApplicationForApprovalCode);
                      WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendChangeRequestHeaderForApprovalCode);

                end;
            WorkflowResponseHandling.CreateApprovalRequestsCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendSaccoApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendFloatApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendChangeRequestHeaderForApprovalCode);
                end;
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendSaccoApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendFloatApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendChangeRequestHeaderForApprovalCode);
                end;
            WorkflowResponseHandling.OpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelSaccoApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelFloatApplicationForApprovalCode);
                     WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelChangeRequestHeaderApprovalRequestCode);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        SaccoAppl: Record "Sacco Application";
        ChangeRequest: Record ChangeRequest;
        FloatApplication : Record "Float Management";
    begin
        case RecRef.Number of
            Database::"Sacco Application":
                begin
                    RecRef.SetTable(SaccoAppl);
                    SaccoAppl.Validate(Status, SaccoAppl.Status::Approved);
                    SaccoAppl.Modify(true);
                    Handled := true;

                end;
                  Database::ChangeRequest:
                begin
                    RecRef.SetTable(ChangeRequest);
                    ChangeRequest.Validate(Status, ChangeRequest.Status::Approved);
                    ChangeRequest.Modify(true);
                    Handled := true;
                end;
                  Database::"Float Management":
                begin
                    RecRef.SetTable(FloatApplication);
                    FloatApplication.Validate(Status, FloatApplication.Status::Approved);
                    //FloatApplication.Modify(true);
                    Handled := true;
                end;


        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        SaccoAppl: Record "Sacco Application";
        ChangeRequest : Record ChangeRequest;
        FloatMangement : Record "Float Management";
    begin
        case RecRef.Number of
            Database::"Sacco Application":
                begin
                    RecRef.SetTable(SaccoAppl);
                    SaccoAppl.Validate(Status, SaccoAppl.Status::New);
                    SaccoAppl.Modify(true);
                    Handled := true;

                end;
                   Database::ChangeRequest:
                begin
                    RecRef.SetTable(ChangeRequest);
                    ChangeRequest.Validate(Status, ChangeRequest.Status::New);
                    ChangeRequest.Modify(true);
                    Handled := true;

                end;
                 Database::"Float Management":
                begin
                    RecRef.SetTable(FloatMangement);
                    FloatMangement.Validate(Status, FloatMangement.Status::Open);
                    FloatMangement.Modify(true);
                    Handled := true;

                end;

        end;
    end;

    var
        myInt: Integer;
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandlingExt: codeunit "Workflow Event Handling Ext";
}