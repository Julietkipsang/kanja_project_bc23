page 50016 "CBS Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "CBS Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    //DeleteAllowed = false;
    //InsertAllowed = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Primary Key"; Rec."Primary Key")
                { }
                field("MA Individual Nos."; Rec."MA Individual Nos.")
                {

                }
                field("Member Nos."; Rec."Member Nos.")
                {

                }
                field("Account Opening Nos."; Rec."Account Opening Nos.")
                {

                }
                field(FintechNo; Rec.FintechNo)
                {

                }
                field(SaccoNo; Rec.SaccoNo)
                {

                }
                field(MerchantNo; Rec.MerchantNo)
                {


                }
                field(AgentNo; Rec.AgentNo)
                {

                }
                field(PartnerNo; Rec.PartnerNo)
                {

                }
                field("Phone No. Format"; Rec."Phone No. Format")
                {

                }
                field(PaymentVoucher; Rec.PaymentVoucher)
                {

                }
                field("Settlement Bank Account"; Rec."Settlement Bank Account")
                {

                }

                field(Prefix; Rec.Prefix)
                {
                    Caption = 'Customer Bases No Prefix';
                }
                field(EdmsPath; Rec.EdmsPath)
                {

                }


            }
            group("Posting")
            {
                field("Kanja General Template Name"; Rec."Kanja General Template Name")
                {
                }

                field("Kanja General Batch Name"; Rec."Kanja General Batch Name")
                {

                }

            }

        }
    }
}

