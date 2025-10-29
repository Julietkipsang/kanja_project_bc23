// codeunit 50005 Approvals
// {
//     trigger OnRun()
//     begin


//     end;


//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
//     local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; var ApprovalEntryArgument: Record "Approval Entry")
//     var
//         SaccoApplication: Record "Sacco Application";
//     begin
//         case RecRef.NUMBER of
//             DATABASE::"Sacco Application":
//                 begin
//                     RecRef.SETTABLE(SaccoApplication);
//                     ApprovalEntryArgument."Document No." := SaccoApplication."No.";
//                 end;
//         end;

//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
//     procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var isHandled: Boolean)
//     var
//         SaccoApplication: Record "Sacco Application";
//     begin
//         RecRef.GetTable(Variant);
//         case RecRef.Number of
//             DATABASE::"Sacco Application":
//                 begin
//                     RecRef.SetTable(SaccoApplication);
//                     SaccoApplication.Status := SaccoApplication.Status::"Pending Approval";
//                     SaccoApplication.Modify(true);
//                     isHandled := true;

//                 end;
//         end;
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
//     local procedure RejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
//     var
//     begin

//     end;

//     [IntegrationEvent(false, false)]
//     procedure OnSendSaccoApplicationForApproval(var SaccoApplication: Record "Sacco Application")
//     begin
//     end;
//     procedure OnSendFloatApplicationForApproval(var FloatApplication: Record "Float Management")
//     begin
//     end;

//     procedure OnCancelSaccoApplicationApprovalRequest(var saccoApplication: Record "Sacco Application")
//     begin
//     end;
//      procedure OnCancelFloatApplicationApprovalRequest(var FloatApplication: Record "Float Management")
//     begin
//     end;

//     procedure checkIfApprovalWorkflowIsEnabled(var saccoapplication: Record "Sacco Application"): Boolean
//     begin
//         // if not WorkflowEventHandlingExt.RunWorkflowOnSendSaccoApplicationForApprovalCode(saccoapplication) then
//         // Error(oWorkflowEnabledErr);
//         // exit(true);

//     end;

//     procedure IsSaccoApplicationApprovalsWorkflowEnabled(var saccoApplication: Record "Sacco Application"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(saccoApplication, WorkflowEventHandlingExt.RunWorkflowOnSendSaccoApplicationForApprovalCode));
//     end;



//     var
//         myInt: Integer;
//         WorkflowManagement: Codeunit "Workflow Management";
//         oWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
//         WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext";

// }