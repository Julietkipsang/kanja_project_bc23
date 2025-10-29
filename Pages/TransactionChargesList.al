page 50088 "Transaction Charges-Flat"
{
    // version TL2.0

    //AutoSplitKey = true;
    Caption = 'Flat Charges Subform';
    PageType = List;
    SourceTable = "Transaction Charge";
    //SourceTableView = sorting("Minimum Amount") where("Calculation Method" = filter("Based Flat Amount"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    Editable = false;

                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;
                }

                //  field("Settlement Amount  (SACCO)"; rec."Settlement Amount  (SACCO)")
                //  {
                //      ApplicationArea = All;
                //  }

                //  field("Settlement Amount  (TL)"; Rec."Settlement Amount  (TL)")
                //  {
                //      ApplicationArea = All;
                //  }
                //  field("MPESA Charges"; Rec."MPESA Charges")
                //  {
                //      ApplicationArea = All;
                //  }
                //  field("Settlement Amount (COOP)"; Rec."Settlement Amount (COOP)")
                //  {
                //      ApplicationArea = All;
                //  }

                //  field("Settlement Amount (AGENT)"; Rec."Settlement Amount (AGENT)")
                //  {
                //      ApplicationArea = All;
                //  }

                //  field("Agent Type"; Rec."Agent Type")
                //  {
                //      ApplicationArea = All;
                //  }
                field("Total Charge Amount"; Rec."Total Charge Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
    end;

    trigger OnOpenPage()
    begin

    end;

    var



}
