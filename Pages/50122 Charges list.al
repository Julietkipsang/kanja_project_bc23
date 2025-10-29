page 50000 Charges
{
    // version TL2.0

    PageType = List;
    SourceTable = "Charges Table";

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
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = All;
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
                field("Account No"; Rec."Account No.")
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

    actions
    {
        area(processing)
        {

            group("Approval Request")
            {
                action("Charges Range")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Charges Range';
                    Ellipsis = true;
                    Image = CalculateCalendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Charges Range';
                    RunObject = page "Charges Range";
                    RunPageLink = "Charge Code" = field(Code);
                }
                action("Fintech Split")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Fintech Split';
                    Ellipsis = true;
                    Image = CalculateCalendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Charges Range';
                    RunObject = page "MobileBanking/Cbs";
                    RunPageLink = "Charge Type" = field("Charge Type");
                }
            }
        }
    }
    trigger
    OnOpenPage()
    begin

    end;
}

