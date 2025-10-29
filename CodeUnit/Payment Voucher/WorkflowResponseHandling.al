codeunit 50043 "Workflow Response Handling ExF"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPVDocForApprovalCode);
                end;
            WorkflowResponseHandling.CreateApprovalRequestsCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendPVDocForApprovalCode);

                end;
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPVDocForApprovalCode);
                end;
            WorkflowResponseHandling.OpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelPVDocApprovalRequestCode);
                end;
            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                begin

                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnCancelPVDocApprovalRequestCode);

                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var

        PV: Record "Payment/Receipt Voucher";

    begin
        case RecRef.Number of
            Database::"Payment/Receipt Voucher":
                begin
                    RecRef.SetTable(PV);
                    PerformManualCheckandRelease.ReleasePVDoc(PV);
                    Handled := true;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        PV: Record "Payment/Receipt Voucher";

    begin
        case RecRef.Number of

            Database::"Payment/Receipt Voucher":
                begin
                    RecRef.SetTable(PV);
                    PerformManualCheckandRelease.ReOpenPV(PV);
                    Handled := true;
                end;

        end;
    end;

    var

        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling ExF";
        PerformManualCheckandRelease: Codeunit PerformManualCheckandRelease;
}