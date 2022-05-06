module top
(
	input           ARST_N,
	input           PSW,
	input           XTAL_IN,

	output          LCD_CLK,
	output          LCD_HSYNC,
	output          LCD_VSYNC,
	output          LCD_DEN,
	output  [4:0]   LCD_R,
	output  [5:0]   LCD_G,
	output  [4:0]   LCD_B,
	output  [5:0]   LED
);

	wire    CLK_SYS;
	wire    CLK_PIX;
	wire    oscout_o;

/*
	//Use internal clock
	Gowin_OSC chip_osc(
		.oscout(oscout_o) //output oscout
	);
*/

/*
	This program uses external crystal oscillator and PLL to generate 33.33mhz clock to the screen
	If you use our 4.3-inch screen, you need to modify the PLL parameters (tools - > IP core generator) 
	to make CLK_ Pix is between 8-12mhz (according to the specification of the screen)
*/

	Gowin_rPLL chip_pll(
		.clkout(CLK_SYS),  // output clkout    // 200M
		.clkoutd(CLK_PIX), // output clkoutd   // 33.33M
		.clkin(XTAL_IN)    // input clkin
	);


	vga vga_inst(
		.CLK      (CLK_SYS),
		.ARST_N    (ARST_N),

		.PixelClk (CLK_PIX),
		.LCD_DE   (LCD_DEN),
		.LCD_HSYNC(LCD_HSYNC),
		.LCD_VSYNC(LCD_VSYNC),

		.LCD_B    (LCD_B),
		.LCD_G    (LCD_G),
		.LCD_R    (LCD_R)
	);
	assign LCD_CLK = CLK_PIX;

	// drive LED
	reg     [31:0]  cnt_r;
	reg     [5:0]   led_r;
	assign LED = led_r;

	always @ (posedge XTAL_IN or negedge ARST_N) begin
		if (!ARST_N) begin
			cnt_r <= 24'd0;
		end else if (cnt_r < 24'd400_0000) begin
			cnt_r <= cnt_r + 1;
		end else begin
			cnt_r <= 24'd0;
		end
	end

	always @ (posedge XTAL_IN or negedge ARST_N) begin
		if (!ARST_N) begin
			led_r <= 6'b111110;
		end else if (cnt_r == 24'd400_0000) begin
			led_r[5:0] <= {led_r[4:0],led_r[5]};
		end else begin
			led_r <= led_r;
		end
	end
endmodule
