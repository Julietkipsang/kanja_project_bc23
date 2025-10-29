page 50023 "Charges Entries Details"
{
    PageType = List;
    // CardPageId = "Receipt From Bank Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = " Charge Details";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt No."; Rec."Receipt No.")
                {

                }
                field(DocNo; Rec.DocNo)
                {
                    ApplicationArea = All;
                    Caption = 'Request Id';
                }
                field("Entity No."; Rec."Entity No.")
                {
                    Visible = false;
                }

                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Transaction Description"; Rec."Transaction Description")
                {

                }

                field("Received Amount"; Rec."Received Amount")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field(ChargeValue; Rec.ChargeValue)
                {
                    ApplicationArea = All;
                    Caption = 'Charge Amount';

                }
                field("Sender Phone No"; Rec."Sender Phone No")
                {
                    Visible = false;

                }


            }

        }

    }
    actions
    {
        area(Processing)
        {

        }
    }


}