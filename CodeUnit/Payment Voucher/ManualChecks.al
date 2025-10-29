codeunit 50041 "PerformManualCheckandRelease"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnAfterValidateEvent', 'Status', false, false)]
    local procedure OnAfterValidateLocationCodePurchase(var Rec: Record "Approval Entry")
    begin
        UpdateSameLevelApprover(Rec);
    end;

    local procedure UpdateSameLevelApprover(Entry: Record "Approval Entry")
    var
        Entry1: Record "Approval Entry";
    begin
        Entry1.Reset();
        Entry1.SetRange("Table ID", Entry."Table ID");
        Entry1.SetRange("Document No.", Entry."Document No.");
        Entry1.SetRange("Sequence No.", Entry."Sequence No.");
        Entry1.SetRange(Status, Entry.Status::Open);
        if Entry1.FindSet() then begin
            repeat
                if Entry1."Approver ID" <> Entry."Approver ID" then begin
                    Entry1.Status := Entry.Status;
                    Entry1.Modify();
                end;
            until Entry1.Next() = 0;
        end;
    end;

    procedure FindReleaseDoc(DocumentNo: Code[20]; TableID: Integer): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Reset;
        ApprovalEntry.SetRange("Table ID", TableID);
        ApprovalEntry.SetRange("Document No.", DocumentNo);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        if ApprovalEntry.FindLast then begin
            exit(true)
        end else begin
            exit(false);
        end;
    end;

    procedure FindRejectedDoc(DocumentNo: Code[20]; TableID: Integer): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Reset;
        ApprovalEntry.SetRange("Table ID", TableID);
        ApprovalEntry.SetRange("Document No.", DocumentNo);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Rejected);
        if ApprovalEntry.FindLast then begin
            exit(true)
        end else begin
            exit(false);
        end;
    end;


    procedure ReleasePVDoc(var PV: Record "Payment/Receipt Voucher")
    begin
        //with PV do begin
            FindReleaseDoc(PV."Paying Code.", Database::"Payment/Receipt Voucher");
            if ApprovalsMgntExt.IsPVDocApprovalsWorkflowEnabled(PV) and (PV.Status = PV.Status::Open) then begin
                Error(Text002);
            end else begin
                PV.Status := PV.Status::Released;
                if PV.Modify(true) then begin
                    Message(Text004, PV."Document Type", PV."Paying Code.");
                end;
            end;
       // end;
    end;


    procedure ReOpenPV(var PV: Record "Payment/Receipt Voucher")
    begin
       // with PV do begin
            if PV.Status = PV.Status::Open then begin
                exit;
            end;
            if FindRejectedDoc(PV."Paying Code.", Database::"Payment/Receipt Voucher") then begin
                PV.Status := PV.Status::Open;
            end else begin
                PV.Status := PV.Status::Open;
            end;
            PV.Modify(true);
        //end;
    end;








    var
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2';
        Text002: Label 'This document can only be released when the approval process is complete';
        Text003: Label 'The apporval process must be cancelled or completed to reopen the document';
        Text004: Label '%1 %2 has been approved successfully';
        Text005: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2';
        Text006: Label 'There are unposted prepayment amount on the document of type %1 with the number %2';
        Text007: Label '%1 %2 has been automatically approved. The status has been changed to %1';
        ApprovalsMgntExt: Codeunit "Approvals Mgnt Ext";
    //BudgetManagement: Codeunit "Budget Management";
}