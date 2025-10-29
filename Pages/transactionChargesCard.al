page 50087 "Transaction Types Card"
{
    // version TL2.0

    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Settlement Charges";

    layout
    {
        area(content)
        {
            group(General)
            {

                field(settlementTypes; Rec.settlementTypes)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(settlementDescription; Rec.settlementDescription)
                {
                    Editable = false;
                }


            }
            group(Posting)
            {
                group(Kanja)
                {
                    field("Sett. Control Account Type"; Rec."Sett. Control Account Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Settlement Account No."; Rec."Settlement Account No.")
                    {
                        Caption = 'Kanja settlement Account';
                        ApplicationArea = All;
                    }
                }


                group(SAFARICOM)
                {

                    field("Settlement Account Type (Saf)"; Rec."Settlement Account Type (Saf)")
                    {
                        ApplicationArea = All;
                    }
                    field("Settlement Account No. (Saf)"; Rec."Settlement Account No. (Saf)")
                    {
                        ApplicationArea = All;
                    }
                }


                group("Statutory Deductions")
                {

                    field("Deduct Excise Duty"; Rec."Deduct Excise Duty")
                    {
                        ApplicationArea = All;
                    }
                    field("Excise %"; Rec."Excise %")
                    {
                        ApplicationArea = All;
                    }
                    field("Excise G/L Account"; Rec."Excise G/L Account")
                    {

                    }
                    field("Excise Discription"; Rec."Excise Discription")
                    {
                        Caption = 'Excise Description';
                    }


                }


            }

        }
    }

    actions
    {
        area(processing)
        {
            action("Charges Setup")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = true;
                RunObject = Page settlementSetup;
                RunPageLink = settlementTypes = field(settlementTypes);
                trigger OnAction()
                begin


                end;
            }
            //     action("Priority Posting2")
            //     {
            //         Image = Allocate;
            //         Promoted = true;
            //         PromotedCategory = Category7;
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         ApplicationArea = All;
            //         //RunObject = Page pri;
            //         // RunPageLink = "Transaction Type" = FIELD(Code);
            //         Visible = ShowPriorityPosting;
            //     }
            // }
        }
    }

    trigger OnOpenPage()
    begin
        Visibility();


    end;

    local procedure Visibility()
    begin
        if Rec."Calculation Method" = Rec."Calculation Method"::Range then begin
            isRange := true;
        end;

    end;


    var
        isRange: Boolean;
    // TransactionCharge: Record "Transaction Charge";
    // IsSaccoGroupVisible: Boolean;
    // IsTLGroupVisible: Boolean;
    // IsCOOPGroupVisible: Boolean;
    // IsAgentGroupVisible: Boolean;
    // ShowPriorityPosting: Boolean;
    // IsFlatPageVisible: Boolean;
    // IsPercentPageVisible: Boolean;


}

