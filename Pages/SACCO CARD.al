page 50065 "Sacco Application Card"
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
            group("Entity Details")
            {
                //Caption = 'General';
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    //Editable = false;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        Visibility();
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
                    Editable = PageEditable;
                }

                field("PIN No."; Rec."PIN No.")
                {
                    Caption = 'KRA PIN';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = PageEditable;
                }

                group(Agency)
                {
                    Visible = IsTarget;
                    field(AgencyTarget; Rec.AgencyTarget)
                    {
                        Caption = 'Agency Target';

                    }
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
                field("Date of Registration"; Rec."Date of Registration")
                {

                    ApplicationArea = All;
                    Editable = false;
                }




                group(test)

                {
                    Caption = '';
                    Visible = IsFintech;
                    field("Fintech Account"; Rec."Fintech Account")
                    {
                        ApplicationArea = All;
                        Editable = false;

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
                    field("Merchant Type"; Rec."Merchant Type")
                    {
                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            if Rec."Merchant Type" = Rec."Merchant Type"::"Sacco Merchant" then
                                Ismerchant := true
                            else
                                Ismerchant := true;
                        end;

                    }


                    group(test3)
                    {
                        Caption = '';
                        Visible = Ismerchant;
                        field("Merchant Sacco No"; Rec."Merchant Sacco No")
                        {
                            ApplicationArea = all;
                        }
                        field("Merchant Sacco Name"; Rec."Merchant Sacco Name")
                        {
                            ApplicationArea = all;

                        }
                        field("Sacco Account No"; Rec."Sacco Account No")
                        {

                        }
                    }


                    // Caption = 'Agent Details';
                    // Visible = IsAgent;
                    field("Agent Account"; Rec."Agent Account")
                    {
                        ApplicationArea = All;
                        Editable = PageEditable;
                        //Visible = false;
                        //Visible = IsAgent;
                    }
                    field("Agent Name"; Rec."Agent Name")

                    {
                        ApplicationArea = All;
                        Editable = false;
                        //Visible = false;
                    }



                }




            }


            group(Communication)
            {
                Editable = PageEditable;
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
                field("Alterntive Phone No."; Rec."Alterntive Phone No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(ContactPerson; Rec.ContactPerson)
                {
                    ApplicationArea = all;
                    Editable = PageEditable;
                }
                field("Contact Name"; Rec."Contact Name")
                {

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
                }/* 
                field(SubCounty; Rec.SubCounty)
                {

                    ShowMandatory = true;
                    ApplicationArea = All;

                    Caption = 'SubCounty';
                } */
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

            // group("Fintech List")
            // {

            part(FintechList; FintechList)
            {
                Visible = saccotype;
                //  Caption = 'Fintech List';
                ApplicationArea = All;
                // RunPageLink = "Application No." = field("No.");
                SubPageLink = applNo = field("No.");

            }

            //}


            // group("Settlement Bank Details")
            // {
            part(BankDetails; BankDetails)
            {
                ApplicationArea = All;
                SubPageLink = ApplicationNo = field("No.");


            }
            // }
            // group("Settlement Paybill Details")
            // {
            part(Paybill; Paybill)
            {
                // Caption = 'Settlement Paybill Details';
                ApplicationArea = All;
                SubPageLink = applNo = field("No.");

            }
            // }
            // group(ServiceTypeSubscription)
            // {

            part("Entity Service Sub List"; "Entity Service Sub List")
            {
                Visible = saccotype;
                //  Caption = 'Service Type Subscription';
                ApplicationArea = All;
                // RunPageLink = "Application No." = field("No.");
                SubPageLink = "Application No." = field("No.");

            }
            //  }
            group(Declaration)
            {
                field("CEO Name"; Rec."CEO Name")
                {

                }
                field(Picture1; Rec.Picture1)
                {
                    Caption = 'CEO Signature';
                }
                field("Chairmans Name"; Rec."Chairmans Name")
                {

                }
                field(Picture2; Rec.Picture2)
                {
                    Caption = 'Chairman Signature';
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
                    trigger OnAction()
                    var

                        ShowSuccessResetStatusMsg: Label 'Status has been reset successfully';
                        FosaSetup: Record "FOSA Setup";
                        ConfirmSendApprovalText: Label 'Do you wish to submit this application for approval?';
                        ShowSuccessSendApproval: Label 'The application has been sent for approval';
                        DocumentAttachment: Record "Document Attachment";
                        DocumentType: Record DocumentTypes;
                        DocumentTypeSetup: Record DocumentTypesSetup;
                        EntityServiceSubscription: Record "Entity Service Subscription";

                    begin
                        Rec.TestField("Full Name");
                        Rec.TestField("PIN No.");
                        Rec.TestField("E-mail");
                        Rec.TestField("Phone No.");



                        if Rec.Type = Rec.Type::Sacco then begin
                            Rec.TestField("Fintech Account");

                        end;
                        if Rec.Type = Rec.Type::Merchant then begin
                            Rec.TestField("Agent Account");
                        end;
                        DocumentTypeSetup.Reset();
                        DocumentTypeSetup.SetRange(EntityType, Rec.Type);
                        if DocumentTypeSetup.FindFirst() then begin
                            DocumentType.Reset();
                            DocumentType.SetRange(codes, DocumentTypeSetup.Nos);
                            DocumentType.SetRange(RequiresAttachment, true);
                            if DocumentType.FindSet() then begin
                                repeat
                                    DocumentAttachment.Reset();
                                    DocumentAttachment.SetRange("No.", Rec."No.");
                                    DocumentAttachment.SetRange(DocumentTypes, DocumentType.DocumentType);
                                    if not DocumentAttachment.FindFirst() then begin
                                        Error('Kindly attach %1', DocumentType.DocumentType);
                                    end;
                                until DocumentType.Next() = 0;
                            end;
                        end;
                        IF (Rec.Type = Rec.Type::Sacco) OR (Rec.Type = Rec.Type::Merchant) then begin
                            EntityServiceSubscription.Reset();
                            EntityServiceSubscription.SetRange("Application No.", Rec."No.");
                            if EntityServiceSubscription.FindFirst() then begin
                                // Error('%1', EntityServiceSubscription."Account Type");
                                if EntityServiceSubscription."Account Type" = '' then
                                    Error('Kindly Subscribe to one service');
                            end;
                        END;
                        //  Error('%1', EntityServiceSubscription."Application No.", Rec."No.");

                        if Rec.Type = Rec.Type::Acquirer then begin
                            Rec.TestField(AgencyTarget);
                        end;
                        // if Confirm(ConfirmSendApprovalText) then begin
                        //     Rec.Status := Rec.Status::"Pending Approval";
                        //     Rec."Created By" := UserId;
                        //     Rec."Created Date" := Today;
                        //     Rec."Created Time" := Time;
                        //     Rec.Modify();

                        // end;
                        if Confirm(ConfirmSendApprovalText) then begin
                            if ApprovalsMgmt.CheckSaccoApplicationApprovalPossible(Rec) then
                                ApprovalsMgmt.OnSendSaccoApplicationForApproval(Rec);
                        end;
                        Message(ShowSuccessSendApproval);
                        CurrPage.Close();


                    end;
                }

                // action(TakePicture)
                // {
                //     Visible = CameraAvailable;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     Image = Camera;

                //     trigger OnAction()
                //     begin
                //         Camera.RequestPictureAsync();
                //     end;
                // }
                // action(TakePictureHigh)
                // {
                //     Visible = CameraAvailable;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     Image = Camera;

                //     trigger OnAction()
                //     begin
                //         CameraOptions := CameraOptions.CameraOptions();
                //         CameraOptions.Quality := 100;
                //         Camera.RequestPictureAsync(CameraOptions);
                //     end;
                // }

                // action(TakePictureLow)
                // {
                //     Visible = CameraAvailable;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     Image = Camera;

                //     trigger OnAction()
                //     begin
                //         CameraOptions := CameraOptions.CameraOptions();
                //         CameraOptions.Quality := 10;
                //         Camera.RequestPictureAsync(CameraOptions);
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

            }
        }

    }


    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin

    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Visibility();
        // if Camera.IsAvailable() then begin
        //     Camera := Camera.Create();
        //     CameraAvailable := True;
        // end;

    end;

    local procedure Visibility()
    begin
        IsFintech := false;
        IsAgent := false;
        PageEditable := true;
        Ismerchant := true;
        if Rec.Type = Rec.Type::Sacco then begin
            IsFintech := true;
            saccotype := true;
        end
        else
            IsFintech := false;


        if Rec.Type = Rec.Type::Merchant then begin
            IsAgent := true;
            saccotype := true;
            // isSettlementSacco := true;
        end else begin
            IsAgent := false;
        end;

        if Rec.Type = Rec.Type::Acquirer then begin
            IsTarget := true;
            // isSettlementSacco := true;
            //     Ismerchant := false;
        end;
        if Rec.Type = Rec.Type::Fintech then begin
            isSettlementSacco := true;
        end;
    end;

    local procedure CheckFile(DocumentNo: Code[50]; File_Type: Enum "File Handler"): Boolean
    var
        FileHandler: Record "File Handler";
    begin
        FileHandler.Reset();
        if FileHandler.Get(DocumentNo, File_Type) then begin
            FileHandler.CalcFields(Content);
            if FileHandler.Content.HasValue then begin
                exit(true);
            end;
        end;
    end;

    // trigger Camera::PictureAvailable(PictureName: Text; PictureFilePath: Text)
    // begin
    //     IncomingFile.Open(PictureFilePath);
    //     Message('Picture size: %1', IncomingFile.Len());
    //     IncomingFile.Close();
    //     // It is important to clean up by using the File.Erase command to avoid accumulating image files.
    //     File.Erase(PictureFilePath);
    // end;

    var
        // [RunOnClient]
        // [WithEvents]
        // Camera: DotNet UT_CameraProvider;
        // CameraOptions: DotNet UT_CameraOptions;
        // Checks whether the current device has a camera.
        CameraAvailable: Boolean;
        IncomingFile: File;
        IsAgent: Boolean;
        IsSaccoMerchant: Boolean;
        Ismerchant: Boolean;
        IsTarget: Boolean;
        isSettlementSacco: Boolean;
        IsFintech: Boolean;
        IsSaccoDetail: Boolean;
        PageEditable: Boolean;
        ATTACHDoc: Boolean;
        File_Type: Enum "File Handler";
        Document_Email: Codeunit "Document & Email Management";
        Text0001: Label 'Please Attatch %1 for Sacco: %2-%3';
        saccotype: Boolean;

        EntityType: Enum EntityType;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmt: Codeunit "Approvals Mgnt Ext";


}

// dotnet
// {
//     assembly("Microsoft.Dynamics.Nav.ClientExtensions")
//     {

//         type("Microsoft.Dynamics.Nav.Client.Capabilities.CameraProvider"; "UT_CameraProvider")
//         {

//         }

//         type("Microsoft.Dynamics.Nav.Client.Capabilities.CameraOptions"; "UT_CameraOptions")
//         {

//         }
//     }
// }