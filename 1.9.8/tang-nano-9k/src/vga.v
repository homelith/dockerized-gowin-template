module vga
(
    input                   CLK,
    input                   ARST_N,

    input                   PixelClk,

    output                  LCD_DE,
    output                  LCD_HSYNC,
    output                  LCD_VSYNC,

    output          [4:0]   LCD_B,
    output          [5:0]   LCD_G,
    output          [4:0]   LCD_R
);

    reg         [11:0]  PixelCount;
    reg         [11:0]  LineCount;

    //Pulse include in back Pulse; t=Pulse, sync act; t=bp, data act; t=bp+height, data end

    // settings for Xiamen Zettler ATM0430D25
    localparam      WidthPixel  = 12'd480;
    localparam      H_BackPorch = 12'd43;
    localparam      H_FrontPorch= 12'd8;
    localparam      H_Pulse     = 12'd1;

    localparam      HeightPixel  = 12'd272;
    localparam      V_BackPorch = 12'd12;
    localparam      V_FrontPorch= 12'd4;
    localparam      V_Pulse     = 12'd10;

    /*
    // parameter for genuine TANG NANO display 800x480
    localparam      V_BackPorch = 16'd0;
    localparam      V_Pulse     = 16'd5;
    localparam      HeightPixel  = 16'd480;
    localparam      V_FrontPorch= 16'd45;

    localparam      H_BackPorch = 16'd182;
    localparam      H_Pulse     = 16'd1; 
    localparam      WidthPixel  = 16'd800;
    localparam      H_FrontPorch= 16'd210;
    */

    localparam      PixelForHS  =   WidthPixel + H_BackPorch + H_FrontPorch;
    localparam      LineForVS   =   HeightPixel + V_BackPorch + V_FrontPorch;

    always @(posedge PixelClk or negedge ARST_N)begin
        if(!ARST_N) begin
            LineCount <= 12'b0;
        end else if(PixelCount == PixelForHS - 1) begin
            if (LineCount == LineForVS - 1) begin
                LineCount <= 12'd0;
            end else begin
                LineCount <= LineCount + 1'b1;
            end
        end else begin
            LineCount <= LineCount;
        end
    end

    always @(posedge PixelClk or negedge ARST_N)begin
        if (!ARST_N) begin
            PixelCount <= 12'b0;
        end else if (PixelCount == PixelForHS - 1) begin
            PixelCount <= 12'b0;
        end else begin
            PixelCount <= PixelCount + 12'd1;
        end
    end

    assign LCD_HSYNC = (PixelCount <= H_Pulse) ? 1'b0 : 1'b1;
    assign LCD_VSYNC = (PixelCount <= H_Pulse && LineCount == 12'd0) ? 1'b0 : 1'b1;

    assign  LCD_DE = ((PixelCount >= H_BackPorch) && (PixelCount < H_BackPorch + WidthPixel) &&
                      ( LineCount >= V_BackPorch) && ( LineCount < V_BackPorch + HeightPixel)) ? 1'b1 : 1'b0;

    reg [14:0] trig_274_r;
    reg [11:0] offset_r;
    always @ (posedge PixelClk or negedge ARST_N) begin
        if (!ARST_N) begin
            trig_274_r <= 15'd0;
        end else begin
            trig_274_r <= trig_274_r - 15'd1;
        end
    end
    always @ (posedge PixelClk or negedge ARST_N) begin
        if (!ARST_N) begin
            offset_r <= 12'd0;
        end else if (trig_274_r == 15'd0) begin
            offset_r <= offset_r + 12'd1;
        end else begin
            offset_r <= offset_r;
        end
    end

    wire [11:0] x;
    wire [11:0] y;
    assign x = PixelCount + offset_r;
    assign y = LineCount + offset_r;

    assign  LCD_R = x[8:4];
    assign  LCD_G = 6'd63 - x[8:3];
    assign  LCD_B = y[8:4];
endmodule
