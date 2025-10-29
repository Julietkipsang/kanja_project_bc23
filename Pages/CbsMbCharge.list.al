page 50092 "MobileBanking/Cbs"
{
    // version TL2.0

    PageType = List;
    SourceTable = "CBS Charges Table";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = All;
                }
                field("Fintech Type"; Rec."Fintech Type")
                {
                    ApplicationArea = all;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Charge Description"; Rec."Charge Description")
                {

                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Channel; Rec.Channel)
                {
                    ApplicationArea = All;
                }

                field("Calculation Mode"; Rec."Calculation Mode")
                {
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }

                field("Excise Account Type"; Rec."Excise Account Type")
                {
                    ApplicationArea = All;
                }
                field(ExciseGl; Rec.ExciseGl)
                {
                    ApplicationArea = All;
                }
                field("% of transaction"; Rec."% of transaction")
                {
                    Caption = 'Excise Duty %';
                    ApplicationArea = All;
                }
                field("Excise Description"; Rec."Excise Description")
                {

                }
                field("Applies to"; Rec."Applies to")
                {

                }
                // field(TotalAmount; Rec.TotalAmount)
                // {

                // }


            }
        }
    }
}

