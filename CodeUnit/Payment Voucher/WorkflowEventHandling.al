codeunit 50042 "Workflow Event Handling ExF"
{
    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        ImprestSendForApprovalEventDescTxt: Label 'Approval of an Imprest is requested.';
        ImprestApprovalRequestCancelEventDescTxt: Label 'An approval request for an Imprest is canceled.';
        ImprestDocReleasedEventDescTxt: Label 'An Imprest document is released.';
        PVSendForApprovalEventDescTxt: Label 'Approval of a PV is requested.';
        PVApprovalRequestCancelEventDescTxt: Label 'An approval request for a PV is canceled.';
        PVDocReleasedEventDescTxt: Label 'A pv document is released.';

        JournalEntriesSendForApprovalEventDescTxt: Label 'Approval of a Journal Entries Header is requested.';
        JournalEntriesApprovalRequestCancelEventDescTxt: Label 'An approval request for a Journal Entries Header is canceled.';
        JournalEntriesDocReleasedEventDescTxt: Label 'A Journal Entries Header document is released.';
        PayrollEntriesSendForApprovalEventDescTxt: Label 'Approval of a Payroll Entries is requested.';
        PayrollEntriesApprovalRequestCancelEventDescTxt: Label 'An approval request for a Payroll Entries is canceled.';
        PayrollEntriesDocReleasedEventDescTxt: Label 'A Payroll Entries document is released.';

        ReceiptsFromBankSendForApprovalEventDescTxt: Label 'Approval of Receipts From Bank is requested.';
        ReceiptsFromBankApprovalRequestCancelEventDescTxt: Label 'An approval request for Receipts From Bank is canceled.';
        ReceiptsFromBankDocReleasedEventDescTxt: Label 'A Receipts From Bank document is released.';
        OptimizedGeneralJournalBatchSendForApprovalEventDescTxt: Label 'Approval of Optimized General Journal Batch is requested.';
        OptimizedGeneralJournalBatchApprovalRequestCancelEventDescTxt: Label 'An approval request for Optimized General Journal Batch is canceled.';
        OptimizedGeneralJournalBatchDocReleasedEventDescTxt: Label 'A Optimized General Journal Batch document is released.';

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPVDocForApprovalCode, Database::"Payment/Receipt Voucher", PVSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPVDocApprovalRequestCode, Database::"Payment/Receipt Voucher", PVApprovalRequestCancelEventDescTxt, 0, false);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of

            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendImprestDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPVDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendJournalEntriesDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPayrollEntriesDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendReceiptsFromBankDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendOptimizedGeneralJournalBatchDocForApprovalCode);
                end;
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendImprestDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPVDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendJournalEntriesDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPayrollEntriesDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendReceiptsFromBankDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendOptimizedGeneralJournalBatchDocForApprovalCode);
                end;
            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendImprestDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPVDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendJournalEntriesDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPayrollEntriesDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendReceiptsFromBankDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendOptimizedGeneralJournalBatchDocForApprovalCode);
                end;

        end;


    end;

    procedure RunWorkflowOnSendImprestDocForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendImprestDocForApproval'));
    end;

    procedure RunWorkflowOnCancelImprestDocApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelImprestApprovalRequest'));
    end;

    procedure RunWorkflowOnSendPVDocForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendPVDocForApproval'));
    end;

    procedure RunWorkflowOnSendJournalEntriesDocForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendJournalEntriesDocForApproval'));
    end;

    procedure RunWorkflowOnSendPayrollEntriesDocForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendPayrollEntriesDocForApproval'));
    end;

    procedure RunWorkflowOnSendReceiptsFromBankDocForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendReceiptsFromBankDocForApproval'));
    end;

    procedure RunWorkflowOnSendOptimizedGeneralJournalBatchDocForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendOptimizedGeneralJournalBatchDocForApproval'));
    end;




    procedure RunWorkflowOnCancelPVDocApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelPVApprovalRequest'));
    end;


    procedure RunWorkflowOnCancelJournalEntriesDocApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelJournalEntriesApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelPayrollEntriesDocApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelPayrollEntriesApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelReceiptsFromBankDocApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelReceiptsFromBankApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelOptimizedGeneralJournalBatchDocApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelOptimizedGeneralJournalBatchApprovalRequest'));
    end;

    procedure RunWorkflowOnAfterReleaseImprestDocCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterReleaseSalesDoc'));
    end;


    [IntegrationEvent(false, false)]
    procedure OnSendPVForApproval(var PV: Record "Payment/Receipt Voucher")
    begin
    end;



    [IntegrationEvent(false, false)]
    procedure OnCancelPVApprovalRequest(var PV: Record "Payment/Receipt Voucher")
    begin
    end;




    [EventSubscriber(ObjectType::Codeunit, 50044, 'OnSendPVForApproval', '', false, false)]
    //[Scope('OnPrem')]
    procedure RunWorkflowOnSendPVDocForApproval(var PV: Record "Payment/Receipt Voucher")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPVDocForApprovalCode, PV);
    end;


    [EventSubscriber(ObjectType::Codeunit, 50044, 'OnCancelPVApprovalRequest', '', false, false)]
    //[Scope('OnPrem')]
    procedure RunWorkflowOnCancelPVApprovalRequest(var PV: Record "Payment/Receipt Voucher")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPVDocApprovalRequestCode, PV);
    end;


}