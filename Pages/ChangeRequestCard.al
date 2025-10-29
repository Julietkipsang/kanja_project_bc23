page 50021 "ChangeCard"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Related Information,Comments,Category 7,Category 8';
    RefreshOnActivate = true;
    SourceTable = ChangeRequest;
    layout
    {


        area(content)
        {
            group(Individual)
            {


                Caption = 'Individual';
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    //Editable = false;
                    trigger OnValidate()
                    var
                        myInt: Integer;

                    begin
                        IsFintech := false;
                        IsAgent := false;
                        // if Rec.Type = Rec.Type::" " then
                        //     PageEditable := false
                        // else
                        //     PageEditable := true;
                        if Rec.Type = Rec.Type::Sacco then
                            IsFintech := true
                        else
                            IsFintech := false;

                        if Rec.Type = Rec.Type::Merchant then
                            IsAgent := true else
                            IsAgent := false;

                    end;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field(OrgCode; Rec.OrgCode)
                {

                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                    Caption = 'Name';
                    Editable = PageEditable;
                }
                field(NewName; Rec.NewName)
                {

                }


                group(SaccoDetail)
                {
                    Caption = '';
                    Visible = IsFintech;
                    //  Editable = IsFintech;
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
                    // Editable = PageEditable;
                }
                field("Contact Name"; Rec."Contact Name")
                {

                }
                field(merchantType; Rec.merchantType)
                {

                }
                field(MerchantSaccoNo; Rec.MerchantSaccoNo)
                {

                }
                field(MerchantSaccoName; Rec.MerchantSaccoName)
                {

                }
                field(SaccoNo; Rec.SaccoNo)
                {

                }
                field(newSaccoNumber; Rec.newSaccoNumber)
                {

                }
                field(applicationNo; Rec.applicationNo)
                {

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
                    field("Fintech Name"; Rec."Fintech Name")
                    {
                        ApplicationArea = All;
                        Editable = false;

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
                        //Visible = IsAgent;
                    }
                    field("Agent Name"; Rec."Agent Name")

                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }




            }


            group(Communication)
            {
                Editable = PageEditable;
                field("E-mail"; Rec."E-mail")
                {
                    ShowMandatory = true;
                    Caption = 'Old E-Mail';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(newEmail; Rec.newEmail)
                {
                    ShowMandatory = true;
                    Caption = 'New E-Mail';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ShowMandatory = true;
                    Caption = 'Old Phone No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(newPhoneNo; Rec.newPhoneNo)
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
            group("Paybill Part")
            {
                part(Paybill; Paybill)
                {
                    ApplicationArea = All;
                    // RunPageLink = "Application No." = field("No.");
                    SubPageLink = applNo = field(applicationNo);

                }
            }
            group("Bank Details List")
            {
                part(BankDetails; BankDetails)
                {

                    //  Caption = 'Bank Details';
                    ApplicationArea = All;
                    SubPageLink = ApplicationNo = field(applicationNo);


                }
            }
            group("Change Subscription")
            {
                part("Change Entity Subscripted"; "Change Entity Subscripted")
                {
                    Caption = 'Change Entity Subscripted';
                    ApplicationArea = All;
                    // RunPageLink = "Application No." = field("No.");
                    SubPageLink = EntityNo = field(OrgCode);
                    // Editable = false;

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
                    Visible = isSend;
                    ToolTip = 'Request approval of the document.';


                    trigger OnAction()
                    begin
                        // if Confirm('Do you want to send for approval ') then begin
                        //     Rec.Status := Rec.Status::"Pending Approval";
                        //     Rec.Modify();
                        //     Message('Sent Successfully');
                        //     CurrPage.Close();

                        // end;
                        if Confirm('Do you want to send for approval ') then begin
                            if ApprovalsMgmtExt.CheckChangeRequestHeaderApprovalPossible(Rec) then begin
                                ApprovalsMgmtExt.OnSendChangeRequestForApproval(Rec);
                                FosaMangement.SendChangeRequestForApproval(Rec."No.");
                            end;
                            Message('Sent Successfully');
                            CurrPage.Close();
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
                        FileMgt: Codeunit "File Management";
                        TempBlob: Codeunit "Temp Blob";
                        OutStr: OutStream;
                        FilePath: Text;
                        FileName: Text;
                    begin
                        RecRef.GETTABLE(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RUNMODAL;
                    end;
                }

                action(Approve)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'ApproveRequest';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = isApprove;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()

                    begin
                        if Confirm('Do you want to approve') then begin
                            // Rec.Status := Rec.Status::Approved;
                            // Rec.Modify();
                            ChangeEntity.Reset();
                            ChangeEntity.SetRange(EntityNo, Rec.OrgCode);
                            ChangeEntity.SetFilter("Account Type", '<>%1', '');
                            if ChangeEntity.Findset() then begin
                                repeat
                                    EntityServices.Reset();
                                    EntityServices.SetRange(EntityNo, ChangeEntity.EntityNo);
                                    EntityServices.SetRange("Account Type", ChangeEntity."Account Type");
                                    if EntityServices.FindFirst() then begin
                                        //repeat

                                        EntityServices.Status := ChangeEntity.Status;
                                        EntityServices."Minimum Amount" := ChangeEntity."Minimum Amount";
                                        EntityServices."Maximum Amount" := ChangeEntity."Maximum Amount";
                                        EntityServices."Maximum Daily" := ChangeEntity."Maximum Daily";
                                        EntityServices.EntityName := Rec."Full Name";
                                        EntityServices.Modify();
                                        // Message('%1..%2', EntityServices.Status, ChangeEntity.Status);
                                        // until EntityServices.Next() = 0;

                                    end else begin
                                        EntityServices.Init();
                                        EntityServices."Account Type" := ChangeEntity."Account Type";
                                        EntityServices.Description := ChangeEntity.Description;
                                        EntityServices.Status := ChangeEntity.Status;
                                        EntityServices."Application No." := ChangeEntity."Application No.";
                                        EntityServices.EntityNo := ChangeEntity.EntityNo;
                                        EntityServices.EntityName := Rec."Full Name";
                                        EntityServices."Minimum Amount" := ChangeEntity."Minimum Amount";
                                        EntityServices."Maximum Amount" := ChangeEntity."Maximum Amount";
                                        EntityServices."Maximum Daily" := ChangeEntity."Maximum Daily";
                                        EntityServices.Insert();
                                    end;
                                until ChangeEntity.Next() = 0;
                            end;
                            Organization.Reset();
                            Organization.SetRange("No.", Rec.OrgCode);
                            if Organization.FindFirst() then begin
                                if Rec.newPhoneNo <> '' then begin
                                    Organization."Phone No." := Rec.newPhoneNo;
                                end;
                                if Rec.newEmail <> '' then begin
                                    Organization."E-mail" := Rec.newEmail;
                                end;
                                if Rec.NewName <> '' then begin
                                    Organization."Full Name" := Rec.NewName;
                                    updateFloatName(Organization."No.");
                                    updateCommisonName(Organization."No.");
                                end;
                                if Rec.newSaccoNumber <> '' then begin
                                    Organization.SaccoNo := Rec.newSaccoNumber;
                                end;
                                Organization.Modify();
                            end;
                            ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                            FosaMangement.ApproveChangeRequestForApproval(Rec."No.");
                            CurrPage.Close();
                            Message('Approved Successfully');
                            CurrPage.Close();


                        end;
                    end;


                }
                action(Reject)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = isReject;
                    ToolTip = 'Request approval of the document.';


                    trigger OnAction()
                    begin
                        if Confirm('Do you want to reject the approval ') then begin
                            // Rec.Status := Rec.Status::Rejected;
                            // Rec.Modify();
                            ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                            CurrPage.Close();
                            Message('Rejected Successfully');
                            CurrPage.Close();

                        end;
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
                    Visible = isReset;
                    ToolTip = 'Request approval of the document.';


                    trigger OnAction()
                    begin
                        if Confirm('Do you want to send the request back to application ') then begin
                            Rec.Status := Rec.Status::New;
                            Rec.Modify();
                            Message('Sent Successfully');
                            CurrPage.Close();

                        end;
                    end;


                }

            }
        }

    }
    var



    local procedure Visibility()
    begin
        //  Editable := Editing;
        if Rec.Status = Rec.Status::New then begin
            isSend := true;
            Editing := true;
        end;
        if Rec.Status = Rec.Status::"Pending Approval" then begin
            isApprove := true;
            isReset := true;
            isReject := true;
        end;
    end;

    procedure updateCommisonName(var orgCode: Code[40]): Code[100]
    var
        Vendor: Record Vendor;
    begin
        Vendor.Reset();
        Vendor.SetRange(OrgCode, orgCode);
        Vendor.SetRange(Commision, true);
        if Vendor.FindFirst() then begin
            Vendor.Name := Rec.NewName + ' Commission Account';
            Vendor.Modify();
            exit(Vendor.Name);
        end;
    end;

    procedure updateFloatName(var orgCode: Code[40]): Code[100]
    var
        Vendor: Record Vendor;
    begin
        Vendor.Reset();
        Vendor.SetRange(OrgCode, orgCode);
        Vendor.SetRange(Commision, false);
        if Vendor.FindFirst() then begin
            Vendor.Name := Rec.NewName + ' Float Account';
            Vendor.Modify();
            exit(Vendor.Name);
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        // if Rec.Type = Rec.type::" " then
        //     PageEditable := false
        // else
        PageEditable := true;



    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Visibility();
        // if Rec.Type = Rec.type::" " then begin
        //     PageEditable := false
        // end else begin
        //     PageEditable := true;
        // end;
        if Rec.Status = Rec.Status::"Pending Approval" then begin
            CurrPage.Editable := false;
        end;
        if Rec.Status = Rec.Status::Approved then begin
            CurrPage.Editable := false;
        end;





    end;


    var
        IsAgent: Boolean;
        Ismerchant: Boolean;
        IsFintech: Boolean;
        IsSaccoDetail: Boolean;
        PageEditable: Boolean;
        ChangeEntity: Record EntitySubscripted;
        EntityServices: Record "Entity Service Subscripted";
        isSend: Boolean;
        isApprove: Boolean;
        isReject: Boolean;
        Organization: Record Organisation;
        ApprovalsMgmtExt : Codeunit "Approvals Mgnt Ext";
        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
        FosaMangement : Codeunit "FOSA Management";
        isReset: Boolean;
        Editing: Boolean;




}

