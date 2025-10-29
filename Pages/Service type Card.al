page 50080 "Service Type Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Services Type";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;

                }
                field("Minimum  Amount"; Rec."Minimum  Amount")
                {
                    ApplicationArea = All;

                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;

                }
                field("Maximum Daily  Amount"; Rec."Maximum Daily  Amount")
                {
                    ApplicationArea = all;
                }
                
            }
        }
    }
    actions
    {
        area(processing)
        {

            group("Charges")
            {
                action(TotalCharges)
                {
                    Ellipsis = true;
                    Image = ElectronicPayment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    RunObject = page "Transaction Charges-Flat";
                    // "Application No." = field("No.");
                    RunPageLink = Code = field(Code);
                    RunPageMode = Edit;
                    //   Visible = IsVisibleIndividual;
                }
                action(ChargesList)
                {
                    Ellipsis = true;
                    Image = ElectronicPayment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    RunObject = page Charges;
                    // "Application No." = field("No.");
                    RunPageLink = Code = field(Code);
                    RunPageMode = Edit;
                    //   Visible = IsVisibleIndividual;
                }

            }
        }


    }
}

