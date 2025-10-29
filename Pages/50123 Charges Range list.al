page 50001 "Charges Range"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Charges Range";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                // field("Entry No."; Rec."Entry No.")
                // {
                //     ApplicationArea = all;
                // }
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = all;
                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = all;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = all;
                }
                field("Value Amount"; Rec."Value Amount")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    actions
    {
    }
}

