module top
(
	input           ARST_N,
	input           XTAL_IN,

	output          LCD_CLK,
	output          LCD_HSYNC,
	output          LCD_VSYNC,
	output          LCD_DEN,
	output  [4:0]   LCD_R,
	output  [5:0]   LCD_G,
	output  [4:0]   LCD_B,

	output          LED_R,
	output          LED_G,
	output          LED_B,
	input           KEY,
	input           GPIO
);

	wire            CLK_SYS;
	wire            CLK_PIX;
	wire            oscout_o;

	/*
	// Internal Oscillator
	Gowin_OSC chip_osc(
		.oscout(oscout_o) //output oscout
	);
	*/
	pll_lcd_ae chip_pll(
		.clkout(CLK_SYS),  // output 200M
		.clkoutd(CLK_PIX), // output 33.33M
		.clkin(XTAL_IN)    // input
	);

	vga vga_inst
	(
		.CLK      (CLK_SYS),
		.nRST     (ARST_N),

		.PixelClk (CLK_PIX),
		.LCD_DE   (LCD_DEN),
		.LCD_HSYNC(LCD_HSYNC),
		.LCD_VSYNC(LCD_VSYNC),

		.LCD_B    (LCD_B),
		.LCD_G    (LCD_G),
		.LCD_R    (LCD_R)
	);

	assign LCD_CLK = CLK_PIX;

	//RGB LED TEST
	reg     [31:0]  Count;
	reg     [1:0]   rgb_data;
	always @ (posedge CLK_SYS or negedge ARST_N) begin
		if (!ARST_N) begin
			Count <= 32'd0;
			rgb_data <= 2'b00;
		end else if (Count == 10000000) begin
			Count <= 4'b0;
			rgb_data <= rgb_data + 1'b1;
		end else begin
			Count <= Count + 1'b1;
		end
	end
	assign LED_R = ~(rgb_data == 2'b01);
	assign LED_G = ~(rgb_data == 2'b10);
	assign LED_B = ~(rgb_data == 2'b11);
endmodule
