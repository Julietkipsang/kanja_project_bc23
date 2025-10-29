page 50057 "Posted Sacco Transcation  List"
{
    PageType = List;
    // CardPageId = "Receipt From Bank Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sacco Transaction Management";
    SourceTableView = sorting("Receipt No") order(descending) where(Posted = const(true));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt No"; Rec."Receipt No")
                {
                    ApplicationArea = All;

                }
                field("Externa Doc No"; Rec."Externa Doc No")
                {
                    ApplicationArea = all;
                }
                field("Sending Sacco Name"; Rec."Sending Sacco Name")
                {
                    ApplicationArea = All;

                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ApplicationArea = All;

                }
                field("Associated Bank Account"; Rec."Associated Bank Account")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Received Amount"; Rec."Received Amount")
                {
                    ApplicationArea = All;

                }
                field("Sacco Name"; Rec."Sacco Name")
                {
                    ApplicationArea = all;
                    Caption = 'Receiving Sacco';

                }
                field(SenderCode; Rec.SenderCode)
                {
                    Caption = 'Sender Phone No.';
                    ApplicationArea = all;
                }

                field("Sending Sacco Description"; Rec."Sending Sacco Description")
                {
                    Visible = false;

                }
                field(RecepientCode; Rec.RecepientCode)
                {
                    Caption = 'Receiver';
                    ApplicationArea = all;


                }

                field("Receiving Sacco Description"; Rec."Receiving Sacco Description")
                {
                    Visible = false;

                }
                field("Sacco No"; Rec."Sacco No")
                {
                    ApplicationArea = All;
                    Visible = false;


                }
                field("Sacco Code"; Rec."Sacco Code")
                {
                    ApplicationArea = All;
                    Visible = false;

                }

                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;

                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;

                }
                field("Created Time"; Rec."Created Time")
                {
                    ApplicationArea = all;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;

                }


            }

        }

    }
    actions
    {
        area(Processing)
        {
            action("Post Transcation")
            {
                Caption = 'Post Transcation';
                Image = ApplyEntries;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Post Transcation ';
                trigger OnAction()
                var
                    FloatManagement: Codeunit "FOSA Management";
                begin
                    if Rec.Posted = true then
                        Error('This Document has been Posted');
                    FloatManagement.Deletejournline();

                    FloatManagement.PostToSaccoAccount(Rec);
                    Rec.Posted := true;
                    rec."Posted By" := UserId;
                    if Rec.Modify(true) then
                        Message('Posted Successfully');
                end;
            }

            action("Charges Details")
            {
                Caption = 'Charges Details';
                Image = ApplyEntries;
                Promoted = true;
                PromotedCategory = Process;
                // Visible = false;
                ApplicationArea = All;
                ToolTip = 'Charges Details ';
                RunObject = page "Charges Entries Details";
                RunPageLink = DocNo = field("Externa Doc No");
                trigger OnAction()
                var

                begin


                end;
            }
        }
    }


}