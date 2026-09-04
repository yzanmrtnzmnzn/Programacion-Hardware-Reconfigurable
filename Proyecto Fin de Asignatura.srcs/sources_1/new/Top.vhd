library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        enable     : in  std_logic;
        -- Entradas para ControlMotores
        sw_mover   : in  std_logic;
        sw_angle   : in  std_logic;
        sw_mover1  : in  std_logic;
        sw_angle1  : in  std_logic;
        -- Señales del ADC externo
        ADC_out    : in  std_logic;
        ADC_in     : out std_logic;
        ADCclk     : out std_logic;
        CS         : out std_logic;
        -- Display de 7 segmentos
        seg        : out std_logic_vector(6 downto 0);
        an         : out std_logic_vector(3 downto 0);
        -- PWM salidas a motores
        pwm        : out std_logic;
        pwm1       : out std_logic
    );
end Top;

architecture Behavioral of Top is

    -- Componente ControlMotores
    component ControlMotores
        Port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            sw_mover   : in  std_logic;
            sw_angle   : in  std_logic;
            sw_mover1  : in  std_logic;
            sw_angle1  : in  std_logic;
            pwm        : out std_logic;
            pwm1       : out std_logic
        );
    end component;

    -- Componente Ldrs
    component Ldrs
        Port (
            clk        : in  std_logic;
            enable     : in  std_logic;
            ADC_out    : in  std_logic;
            ADC_in     : out std_logic;
            ADCclk     : out std_logic;
            CS         : out std_logic;
            seg        : out std_logic_vector(6 downto 0);
            an         : out std_logic_vector(3 downto 0);
            led0_out   : out std_logic;
            led1_out   : out std_logic;
            led2_out   : out std_logic;
            led3_out   : out std_logic
        );
    end component;
    
    signal mover_sig, angle_sig, mover1_sig, angle1_sig : std_logic;
    signal led0_s, led1_s, led2_s, led3_s : std_logic;
    
    

begin
    
    mover_sig  <= '1' when enable = '1' else sw_mover;
    angle_sig  <= led0_s when enable = '1' else sw_angle;
    mover1_sig <= '1' when enable = '1' else sw_mover1;
    angle1_sig <= led1_s when enable = '1' else sw_angle1;
    -- Instancia del controlador de motores
    motores_inst : ControlMotores
        port map (
            clk        => clk,
            reset      => reset,
            sw_mover   => mover_sig,
            sw_angle   => angle_sig,
            sw_mover1  => mover1_sig,
            sw_angle1  => angle1_sig,
            pwm        => pwm,
            pwm1       => pwm1
        );

    -- Instancia del módulo de LDRs
    ldrs_inst : Ldrs
        port map (
            clk        => clk,
            enable     => '1',  -- Activación constante o puede venir de un switch
            ADC_out    => ADC_out,
            ADC_in     => ADC_in,
            ADCclk     => ADCclk,
            CS         => CS,
            seg        => seg,
            an         => an,
            led0_out   => led0_s,
            led1_out   => led1_s,
            led2_out   => led2_s,
            led3_out   => led3_s
        );       

end Behavioral;
