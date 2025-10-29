page 50064 "Member Application List"
{
    // version TL2.0

    Caption = 'New Sacco Applications';
    CardPageID = "Sacco Application Card";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Related Information,Approval Request,Comments,Category 7,Category 8';
    SourceTable = "Sacco Application";

    SourceTableView = where(Status = filter(New));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                    ApplicationArea = ALL;

                }

                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                }

                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetVisible;
        SetEditable;
    end;



    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        //Rec.Type := Rec.type::Sacco;
    end;

    trigger OnOpenPage()
    begin
        SetVisible;
        SetEditable;
        //  Rec.Type
    end;

    var
        //    BeneficiaryType: Record "Beneficiary Type";
        PageEditable: Boolean;
        ApprovalCommentLine: Record "Approval Comment Line";
        ApprovalComments: Page "Approval Comments";
        [InDataSet]
        IsVisibleIndividual: Boolean;
        [InDataSet]
        IsVisibleGroup: Boolean;
        [InDataSet]
        IsVisibleCompany: Boolean;
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;
        ////ApprovalsMgmt: Codeunit "1535";
        IsVisibleJoint: Boolean;
        IsVisibleSignature: Boolean;
        [InDataSet]
        IsVisiblePicture: Boolean;
        [InDataSet]
        IsVisibleFrontID: Boolean;
        [InDataSet]
        IsVisibleBackID: Boolean;
        IsVisibleCR: Boolean;
        CategoryOptions: Text[50];
        SelectedCategory: Integer;
    //  Agency: Record "Member Station";
    //  MemberContribution: Record "Member Contribution";
    // MemberApplication: Record "Member Application";

    local procedure SetVisible()
    begin

        IF Rec.Status = Rec.Status::New THEN BEGIN
            IsVisibleSendApprovalRequest := TRUE;
            IsVisibleCancelApprovalRequest := FALSE;
        END ELSE
            IF Rec.Status = Rec.Status::"Pending Approval" THEN BEGIN
                IsVisibleSendApprovalRequest := FALSE;
                IsVisibleCancelApprovalRequest := TRUE;
            END ELSE
                IF Rec.Status = Rec.Status::Approved THEN BEGIN
                    IsVisibleSendApprovalRequest := FALSE;
                    IsVisibleCancelApprovalRequest := FALSE;
                END ELSE
                    IF Rec.Status = Rec.Status::Rejected THEN BEGIN
                        IsVisibleSendApprovalRequest := FALSE;
                        IsVisibleCancelApprovalRequest := FALSE;
                    END;
    end;

    local procedure SetEditable()
    begin
        //  if Rec.Type = Rec.Type::" " then
        //  PageEditable := false;
        IF Rec.Status = Rec.Status::New THEN
            CurrPage.EDITABLE := FALSE
        ELSE
            IF Rec.Status = Rec.Status::"Pending Approval" THEN
                CurrPage.EDITABLE := FALSE
            ELSE
                IF Rec.Status = Rec.Status::Approved THEN
                    CurrPage.EDITABLE := FALSE
                ELSE
                    IF Rec.Status = Rec.Status::Rejected THEN
                        CurrPage.EDITABLE := FALSE
    end;
}

