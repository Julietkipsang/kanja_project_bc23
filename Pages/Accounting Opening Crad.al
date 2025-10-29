page 50005 "Account Opening Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Related,Approval Request,Comments,Category 7,Category 8';
    SourceTable = "Account Opening";

    layout
    {
        area(content)
        {

            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        SetVisible;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Sacco No."; Rec."Sacco No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sacco No.';
                }
                field("Sacco Name"; Rec."Sacco Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field("Fintech Account"; Rec."Fintech Account")

                {
                    ApplicationArea = all;
                }

                field("Fintech Name"; Rec."Fintech Name")

                {
                    ApplicationArea = all;
                }

                field("Create Float Account"; Rec."Create Float Account")

                {
                    ApplicationArea = all;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }

            }


            group(Audit)
            {
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; Rec."Created Time")
                {
                    ApplicationArea = All;
                }
               
            }
        }
        area(factboxes)
        {
            //   part(AccountMemberList;)
            //  {
            //      ApplicationArea = All;SubPageLink = Document "No."=FIELD("No.");
            //  } 
        }
    }

    actions
    {
        area(processing)
        {
            action(Approve)
            {
                ApplicationArea = Suite;
                Caption = 'Create Account';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Approve the requested changes.';

                trigger OnAction()
                var
                    ConfirmApproveMembershipMsg: Label 'Are you sure you want to create a new Account?';

                    // Usersetup: record "User Setup";
                    //  FOSASetup: Record "FOSA Setup";
                    ShowSuccessSendApproval: Label 'The Sacco has Been Approved and Created SuccessFully';
                    ShowCannotApproveErr: Label 'You cannot approve this application request!';
                    NoApproverCommentErr: Label 'Please fill in the Approver Comments!';
                    FosaSetup: Record "FOSA Setup";
                    UserSetup: Record "User Setup";
                    Text0005: Label 'Dear %1, please note that You have a Member %1,Pending Approval. Kind Regards, Shelloyees Sacco';
                    mailheader: text[100];
                    Mailbody: Text[500];
                    Mailbody1: Text[500];
                    mailheader1: text[100];
                    // EmailMessage: Codeunit "Email Message";
                    // Email: Codeunit Email;
                    FosaManagement: Codeunit "FOSA Management";
                begin
                    // IF REC."Approver Comments" = '' then
                    //    Error(NoApproverCommentErr);
                    FosaSetup.Reset();
                    FosaSetup.SetRange("Member Approver", true);
                    if FosaSetup.FindFirst then begin
                        IF FosaSetup."Member Approver" THEN begin
                            if Confirm(ConfirmApproveMembershipMsg) then begin
                                if Rec."Create Float Account" = true then begin
                                    FosaManagement.CreateSaccoFintechAccount(rec);
                                    Rec.Status := Rec.Status::Approved;
                                    //rec."Approved By" := FosaSetup."User ID";
                                    rec."Approved Date" := Today;
                                    rec."Approved Time" := Time;
                                    Rec.Modify();
                                    Message(ShowSuccessSendApproval);
                                end else begin
                                    
                                    Message('Accounts UPdated');
                                end;



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



        }
        area(navigation)
        {


        }
    }

    trigger OnOpenPage()
    begin
        SetVisible;
        SetEditable;
    end;

    var
        IsVisibleSendApprovalRequest: Boolean;
        Text000: Label 'Are you sure you want to send account %1 for approval?';
        Text001: Label 'Are you sure you want to cancel account %1?';
        Text002: Label 'Account %1 has been submitted successfully';
        Text003: Label 'Account %1 has been cancelled successfully';
        CapitalizeFDInterestConfirmsg: Label 'Do you want to Post the Fixed Deposit %1?';
        CapitalizeCDInterestConfirmsg: Label 'Do you want to Post the Call Deposit %1?';
        RevokeFDConfirmsg: Label 'Do you want to Revoke Fixed Deposit %1?';
        RevokeCDConfirmsg: Label 'Do you want to Revoke Call Deposit %1?';
        MatureFDConfirmsg: Label 'Do you want to Mature Fixed Deposit %1?';
        MatureCDConfirmsg: Label 'Do you want to Mature CD Deposit %1?';
        IsVisibleCancelApprovalRequest: Boolean;
        FOSAManagement: Codeunit "FOSA Management";
        IsVisibleJuniorAccount: Boolean;
        IsVisibleFDAccount: Boolean;
        AccountType: Record "Account Type";

        IsGAVisible: Boolean;
        ApprovalCommentLine: Record "Approval Comment Line";
        ApprovalComments: Page "Approval Comments";
        IsVisibleApprove: Boolean;
        IsVisibleReject: Boolean;
        IsVisibleDelegate: Boolean;
        HostMac: Text[50];
        HostName: Text[50];
        HostIP: Text[50];

    local procedure SetVisible()
    begin


    end;

    local procedure SetEditable()
    begin

    end;

    local procedure GetHostInfo()
    var

    begin

    end;

}

