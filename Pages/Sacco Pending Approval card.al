page 50066 "Sacco Pending Application Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Related Information,Comments,Category 7,Category 8';
    RefreshOnActivate = true;
    SourceTable = "Sacco Application";
    // Editable=FALSE

    layout
    {
        area(content)
        {
            group("Entity Details")
            {
                Caption = 'Entity Details';
                Editable = FALSE;
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    //Editable = false;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin


                    end;
                }
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
                    //   Editable = PageEditable;
                }

                field("PIN No."; Rec."PIN No.")
                {
                    Caption = 'KRA PIN';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = PageEditable;
                }
                field(Type1; Rec.Type)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Visible = false;
                    Editable = PageEditable;
                }
                group(SaccoDetail)
                {
                    Caption = '';
                    Visible = IsFintech;
                    Editable = PageEditable;
                    field("Type Of Sacco"; Rec."Type Of Sacco")
                    {
                        ApplicationArea = All;
                        ShowMandatory = true;
                        Editable = PageEditable;
                    }
                }
                field(PostingGroup; Rec.PostingGroup)
                {
                    ApplicationArea = All;

                    ShowMandatory = true;
                    Editable = false;
                    Visible = false;
                }




                field(Website; Rec.Website)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Editable = PageEditable;

                }
                field(Mission; Rec.Mission)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Editable = PageEditable;
                }
                field(Vision; Rec.Vision)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Editable = PageEditable;
                }
                field(Status; rec.status)
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field(ContactPerson; Rec.ContactPerson)
                {
                    ApplicationArea = all;
                    Editable = PageEditable;
                }
                group(test)

                {
                    Caption = '';
                    Visible = IsFintech;
                    field("Fintech Account"; Rec."Fintech Account")
                    {
                        ApplicationArea = All;
                        Editable = PageEditable;

                    }
                }

                group(test2)
                {
                    Caption = '';
                    Visible = IsAgent;
                    field("Agent Account"; Rec."Agent Account")
                    {
                        ApplicationArea = All;
                        Editable = PageEditable;
                        Visible = IsAgent;
                    }
                    field(AgencyTarget; Rec.AgencyTarget)
                    {

                    }

                }




            }


            group(Communication)
            {
                Editable = FALSE;
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
                field("Post code"; Rec."Post code")
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
                field("Country of Residence"; Rec."Country of Residence")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Caption = 'Country';
                }
                field(County; Rec.County)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Caption = 'County';
                }
                field(SubCounty; Rec.SubCounty)
                {

                    ShowMandatory = true;
                    ApplicationArea = All;

                    Caption = 'SubCounty';
                }
                group(Merchant)
                {
                    Caption = '';
                    Visible = IsAgent;
                    Editable = FALSE;

                    field(Longitude; Rec.Longitude)
                    {

                    }
                    field(Lattitude; Rec.Lattitude)
                    {

                    }
                    field("GPS Location Name"; Rec."GPS Location Name")
                    {

                    }
                }


            }
            group("Settlement Bank Details")
            {
                Editable = isBank;
                part(BankDetails; BankDetails)
                {


                    ApplicationArea = All;
                    SubPageLink = ApplicationNo = field("No.");


                }
            }
            group("Settlement Paybill Details")
            {
                part(Paybill; Paybill)
                {
                    Editable = isPaybill;
                    // Caption = 'Settlement Paybill Details';
                    ApplicationArea = All;
                    SubPageLink = applNo = field("No.");

                }
            }
            group(ServiceTypeSubscription)
            {
                Visible = IsFintech;
                part("Entity Service Sub List"; "Entity Service Sub List")
                {
                    Caption = 'Service Type Subscription';
                    ApplicationArea = All;
                    // RunPageLink = "Application No." = field("No.");
                    SubPageLink = "Application No." = field("No.");
                    Editable = false;

                }
            }
            group(ApproverComment)
            {
                field("Approver Comments"; Rec."Approver Comments")
                {

                    ApplicationArea = all;
                }
                field("Approver Reset Comments"; Rec."Approver Reset Comments")
                {

                    ApplicationArea = all;
                }
            }


            group(Audit)
            {
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Created Time"; Rec."Created Time")
                {
                    ApplicationArea = all;
                    Editable = false;
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
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';
                    Visible = false;
                    trigger OnAction()
                    var

                        ShowSuccessResetStatusMsg: Label 'Status has been reset successfully';
                        FosaSetup: Record "FOSA Setup";

                    begin
                        if FosaSetup.Get(UserId) then
                            if FosaSetup."Member Activator" = true then begin
                                Rec.Status := Rec.Status::"Pending Approval";
                                Rec.Modify();
                                message('Sent for approval');
                            end
                            else
                                Error('You are not an Approver');

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

                    trigger OnAction()
                    var
                        ConfirmApproveMembershipMsg: Label 'Are you sure you want to Approve this application?';
                        ShowSuccessSendApproval: Label 'The Entity has Been Approved and Created SuccessFully';
                        ShowCannotApproveErr: Label 'You cannot approve this application request!';
                        NoApproverCommentErr: Label 'Please fill in the Approver Comments!';
                        FosaSetup: Record "FOSA Setup";
                        UserSetup: Record "User Setup";
                        mailheader: text[100];
                        Mailbody: Text[500];
                        Mailbody1: Text[500];
                        mailheader1: text[100];
                        FosaManagement: Codeunit "FOSA Management";
                        OrgCode: code[20];
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);

                        // IF REC."Approver Comments" = '' then
                        //     Error(NoApproverCommentErr);
                        FosaSetup.Reset();
                        FosaSetup.SetRange("Member Approver", true);
                        if FosaSetup.FindFirst then begin
                            IF FosaSetup."Member Approver" THEN begin
                                if Confirm(ConfirmApproveMembershipMsg) then begin
                                    OrgCode := FosaManagement.CreateOrganisation(Rec);
                                    FosaManagement.CreateSaccoAccount(rec, OrgCode);
                                    Rec.Status := Rec.Status::Approved;
                                    rec."Approved By" := FosaSetup."User ID";
                                    rec."Approved Date" := Today;
                                    rec."Approved Time" := Time;
                                    // Rec.Modify();
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
                    trigger OnAction()
                    var
                        ConfirmRejectMembershipMsg: Label 'Are you sure you want to reject this Application?';
                        ShowSuccessRejectMembershipMsg: Label 'Application has been reject successfully';
                        ShowCannotActivateErr: Label 'You cannot Reject this application request!';
                        NoCommentErr: Label 'Please fill in the approval Reset comments!';
                        FosaSetup: Record "FOSA Setup";
                        UserSetup: Record "User Setup";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if Confirm(ConfirmRejectMembershipMsg) then begin
                            ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                            //Message(ShowSuccessRejectMembershipMsg);
                        end;

                        CurrPage.Close();
                        // FosaSetup.Reset();
                        // FosaSetup.SetRange("Member Approver", true);
                        // if FosaSetup.FindFirst then begin
                        //     IF FosaSetup."Member Approver" THEN begin
                        //         if Confirm(ConfirmRejectMembershipMsg) then begin
                        //             Rec.Status := Rec.Status::Rejected;
                        //             Rec.Modify();
                        //             Message(ShowSuccessRejectMembershipMsg);

                        //         end
                        //     end
                        //     ELSE begin
                        //         Error(ShowCannotActivateErr);
                        //     end;

                        // end ELSE begin
                        //     Error(ShowCannotActivateErr);
                        // end;
                    end;
                }

            }
        }

    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec.Type = Rec.Type::Sacco then
            IsFintech := true

        else
            IsFintech := false;
        if Rec.Type = Rec.Type::Merchant then
            IsAgent := true else
            IsAgent := false;
    end;

    var
        PageEditable: BOOLEAN;
        IsFintech: Boolean;
        IsAgent: Boolean;
        IsSaccoDetail: Boolean;
        Ismerchant: Boolean;
        ATTACHDoc: Boolean;
        File_Type: Enum "File Handler";
        Document_Email: Codeunit "Document & Email Management";
        saccotype: Boolean;
        ViewDoc: Record ViewDocument;
        isSettlement: Boolean;
        isBank: Boolean;
        isPaybill: Boolean;




}

