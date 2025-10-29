page 50046 "Organization  Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Related Information,Comments,Category 7,Category 8';
    RefreshOnActivate = true;
    SourceTable = Organisation;
    Editable = false;

    layout
    {
        area(content)
        {
            group(Individual)
            {
                Caption = 'Entity Details';
                field(Type; Rec.Type)
                {

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
                    Editable = PageEditable;
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
                part(BankDetails; BankDetails)
                {


                    ApplicationArea = All;
                    SubPageLink = ApplicationNo = field(applicationNo);


                }
            }
            group("Settlement Paybill Details")
            {
                part(Paybill; Paybill)
                {
                    // Caption = 'Settlement Paybill Details';
                    ApplicationArea = All;
                    SubPageLink = applNo = field(applicationNo);

                }
            }
            group("Fintech List")
            {
                //Visible = saccotype;
                part(FintechList; FintechList)
                {
                    //  Caption = 'Fintech List';
                    ApplicationArea = All;
                    // RunPageLink = "Application No." = field("No.");
                    SubPageLink = applNo = field(applicationNo);

                }

            }
            group(ServiceTypeSubscription)
            {
                // Visible = IsFintech;
                part("Entity Service Subscripted"; "Entity Service Subscripted")
                {
                    Caption = 'Service Type Subscription';
                    ApplicationArea = All;
                    // RunPageLink = "Application No." = field("No.");
                    SubPageLink = EntityNo = field("No.");
                    Editable = false;

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

    procedure Visibility()
    var
        myInt: Integer;
    begin


        IsFintech := false;
        IsAgent := false;
        //   if Rec.Type = Rec.Type::" " then
        // PageEditable := false
        // else
        //  PageEditable := true;
        if Rec.Type = Rec.Type::Sacco then
            IsFintech := true
        else
            IsFintech := false;

        if Rec.Type = Rec.Type::Merchant then
            IsAgent := true else
            IsAgent := false;


    end;

    /*trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        Rec."Created By" := UserId;

        Rec.Modify();
    end;*/
    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        // if Rec.Type = Rec.type::" " then
        //     PageEditable := false
        // else
        //     PageEditable := true;



    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Visibility();
        // if Rec.Type = Rec.type::" " then
        //     PageEditable := false
        // else
        //     PageEditable := true;

    end;

    var
        IsAgent: Boolean;
        Ismerchant: Boolean;
        IsFintech: Boolean;
        IsSaccoDetail: Boolean;
        PageEditable: Boolean;



}

