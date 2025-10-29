page 50008 "Approved Sacco Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Related Information,Comments,Category 7,Category 8';
    RefreshOnActivate = true;
    SourceTable = "Sacco Application";

    layout
    {
        area(content)
        {
            group(Individual)

            {
                Caption = 'Entity Details';
                Editable = false;

                field("No."; Rec."No.")
                {
                    Editable = false;
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                    Caption = 'Name';


                }

                field("PIN No."; Rec."PIN No.")
                {
                    Caption = 'KRA PIN';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(SaccoSalesperson; Rec."Fintech Account")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Caption = 'Fintech Account';

                }
                field(SalepersonName; Rec."Fintech Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = false;
                }



                field(Status; rec.status)
                {
                    ApplicationArea = All;
                }
                field("Merchant Type"; Rec."Merchant Type")
                {

                }
                //field()

            }


            group(Communication)
            {
                Editable = false;

                field("E-mail"; Rec."E-mail")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }

                field("Postal Address"; Rec."Postal Address")
                {
                    ApplicationArea = All;
                }
                field(Town; Rec.Town)
                {
                    ApplicationArea = All;
                }
                field("Physical Address"; Rec."Physical Address")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }


            }
            group("Settlement Bank Details")
            {
                part(BankDetails; BankDetails)
                {


                    ApplicationArea = All;
                    Editable = false;
                    SubPageLink = ApplicationNo = field("No.");


                }
            }
            group("Settlement Paybill Details")
            {
                part(Paybill; Paybill)
                {
                    // Caption = 'Settlement Paybill Details';
                    ApplicationArea = All;
                    Editable = false;
                    SubPageLink = applNo = field("No.");

                }
            }
            group(ServiceTypeSubscription)
            {
                //Visible = saccotype;
                part("Entity Service Sub List"; "Entity Service Sub List")
                {
                    Caption = 'Service Type Subscription';
                    ApplicationArea = All;
                    Editable = false;
                    // RunPageLink = "Application No." = field("No.");
                    SubPageLink = "Application No." = field("No.");

                }
            }
            group(ApproverComments)

            {
                Editable = false;
                field("Approver Comments"; Rec."Approver Comments")
                {

                }
                field("Approver Reset Comments"; Rec."Approver Reset Comments")
                {

                }
            }


            group(Audit)
            {
                Editable = false;
                field("Approved By"; Rec."Approved By")
                {

                }
                field("Approved Date"; Rec."Approved Date")
                {

                }
                field("Approved Time"; Rec."Approved Time")
                {

                }
            }


        }

    }

    actions
    {
        area(processing)
        {

            group("Approval Request")
            {
                // action(SendApprovalRequest)
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Send A&pproval Request';
                //     Image = SendApprovalRequest;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     PromotedOnly = true;
                //     ToolTip = 'Request approval of the document.';
                //     Visible = false;
                //     trigger OnAction()
                //     var

                //         ShowSuccessResetStatusMsg: Label 'Status has been reset successfully';
                //         FosaSetup: Record "FOSA Setup";

                //     begin
                //         if FosaSetup.Get(UserId) then
                //             if FosaSetup."Member Activator" = true then begin
                //                 Rec.Status := Rec.Status::"Pending Approval";
                //                 Rec.Modify();
                //                 message('Sent for approval');
                //             end
                //             else
                //                 Error('You are not an Approver');

                //     end;
                // }
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
                action(ResetStatus)
                {

                    ApplicationArea = Basic, Suite;
                    Caption = 'Reset Status';
                    Image = ResetStatus;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;
                    trigger OnAction()
                    var
                        ConfirmResetStatusMsg: Label 'Are you sure you want to Reset the status of this application?';
                        ShowSuccessResetStatusMsg: Label 'Status has been reset successfully';
                        ConfirmSendApprovalText: Label 'Do you wish to submit this application for approval?';
                    begin
                        if Confirm(ConfirmResetStatusMsg) then begin
                            Rec.Status := Rec.Status::New;
                            Rec.Modify();
                            Message(ShowSuccessResetStatusMsg);

                        end;
                    end;
                }


                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;
                    ToolTip = 'Approve the requested changes.';
                    Visible = false;

                    trigger OnAction()
                    var
                        ConfirmApproveMembershipMsg: Label 'Are you sure you want to Approve this application?';

                        // Usersetup: record "User Setup";
                        //  FOSASetup: Record "FOSA Setup";
                        ShowSuccessSendApproval: Label 'The application has been approved';
                        ShowCannotApproveErr: Label 'You cannot approve this application request!';
                        NoApproverCommentErr: Label 'Please fill in the Approver Comments!';
                        FosaSetup: Record "FOSA Setup";
                        UserSetup: Record "User Setup";
                        Text0005: Label 'Dear %1, please note that You have a Member %1,Pending Approval. Kind Regards, Shelloyees Sacco';
                        mailheader: text[100];
                        Mailbody: Text[500];
                        Mailbody1: Text[500];
                        mailheader1: text[100];
                    //  EmailMessage: Codeunit "Email Message";
                    //   Email: Codeunit Email;
                    begin
                        IF REC."Approver Comments" = '' then
                            Error(NoApproverCommentErr);
                        FosaSetup.Reset();
                        FosaSetup.SetRange("Member Approver", true);
                        if FosaSetup.FindFirst then begin
                            IF FosaSetup."Member Approver" THEN begin
                                if Confirm(ConfirmApproveMembershipMsg) then begin
                                    Rec.Status := Rec.Status::Approved;
                                    rec."Approved By" := FosaSetup."User ID";
                                    rec."Approved Date" := Today;
                                    rec."Approved Time" := Time;
                                    Rec.Modify();
                                    Message(ShowSuccessSendApproval);

                                end
                            end
                            ELSE begin
                                Error(ShowCannotApproveErr);
                            end;

                        end ELSE begin
                            Error(ShowCannotApproveErr);
                        end;

                    end;
                }

                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;
                    ToolTip = 'Reject the approval request.';
                    Visible = false;

                    trigger OnAction()
                    var
                        ConfirmRejectMembershipMsg: Label 'Are you sure you want to reject this Application?';
                        ShowSuccessRejectMembershipMsg: Label 'Application has been reject successfully';
                        ShowCannotActivateErr: Label 'You cannot Reject this application request!';
                        NoCommentErr: Label 'Please fill in the approval Reset comments!';
                        FosaSetup: Record "FOSA Setup";
                        UserSetup: Record "User Setup";
                    begin
                        if rec."Approver Reset Comments" = '' then
                            Error(NoCommentErr);
                        FosaSetup.Reset();
                        FosaSetup.SetRange("Member Approver", true);
                        if FosaSetup.FindFirst then begin
                            IF FosaSetup."Member Approver" THEN begin
                                if Confirm(ConfirmRejectMembershipMsg) then begin
                                    Rec.Status := Rec.Status::Rejected;
                                    Rec.Modify();
                                    Message(ShowSuccessRejectMembershipMsg);

                                end
                            end
                            ELSE begin
                                Error(ShowCannotActivateErr);
                            end;

                        end ELSE begin
                            Error(ShowCannotActivateErr);
                        end;


                    end;
                }
                // action("Open KRA Pin Certificate")
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Open KRA Pin Certificate';
                //     Ellipsis = true;
                //     Image = Open;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     VISIBLE = true;
                //     ToolTip = 'KRA Pin Certificate';
                //     trigger OnAction()
                //     begin
                //         ViewDoc.Reset();
                //         ViewDoc.SetRange(ApplicationNo, Rec."No.");
                //         ViewDoc.SetRange(DocumentType, 'Sasra');
                //         if ViewDoc.FindFirst() then begin
                //             //ViewDoc.DocumentPath;
                //             // Error('kkk');
                //             //https+IsFintech;
                //             //HYPERLINK('http://192.168.0.77:8082/dms/docs/download/' + ViewDoc.DocumentType + Rec."No.");
                //             HYPERLINK('http://172.16.39.110:8077/dms/documents/fetchDmsDocumentsByReferenceNumber/' + Rec."No." + ViewDoc.DocumentType);


                //         end;
                //         // BankStatment := Format(File_Type::"Bank Statment").Trim() + '-' + Rec."No.";
                //         //  Document_Email.DownloadFile(Rec."No.", File_Type::"KRA Pin Certificate");
                //     end;
                // }


            }
        }

    }


    var
        ViewDoc: Record ViewDocument;



}

