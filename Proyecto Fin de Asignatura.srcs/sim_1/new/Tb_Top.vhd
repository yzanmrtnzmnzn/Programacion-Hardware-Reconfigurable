----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.06.2025 16:41:38
-- Design Name: 
-- Module Name: Tb_Top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


-- Testbench para el módulo Top que incluye ADC, LDRs y motores

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_tb is
end Top_tb;

architecture Behavioral of Top_tb is
    -- Señales para el DUT
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal enable    : std_logic := '0';
    signal sw_mover  : std_logic := '0';
    signal sw_angle  : std_logic := '0';
    signal sw_mover1 : std_logic := '0';
    signal sw_angle1 : std_logic := '0';
    signal ADC_out   : std_logic := '0';
    signal ADC_in    : std_logic;
    signal ADCclk    : std_logic;
    signal CS        : std_logic;
    signal seg       : std_logic_vector(6 downto 0);
    signal an        : std_logic_vector(3 downto 0);
    signal pwm       : std_logic;
    signal pwm1      : std_logic;

    component Top
        Port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            enable     : in  std_logic;
            sw_mover   : in  std_logic;
            sw_angle   : in  std_logic;
            sw_mover1  : in  std_logic;
            sw_angle1  : in  std_logic;
            ADC_out    : in  std_logic;
            ADC_in     : out std_logic;
            ADCclk     : out std_logic;
            CS         : out std_logic;
            seg        : out std_logic_vector(6 downto 0);
            an         : out std_logic_vector(3 downto 0);
            pwm        : out std_logic;
            pwm1       : out std_logic
        );
    end component;

begin

    -- Instancia del DUT
    uut: Top
        port map (
            clk        => clk,
            reset      => reset,
            enable     => enable,
            sw_mover   => sw_mover,
            sw_angle   => sw_angle,
            sw_mover1  => sw_mover1,
            sw_angle1  => sw_angle1,
            ADC_out    => ADC_out,
            ADC_in     => ADC_in,
            ADCclk     => ADCclk,
            CS         => CS,
            seg        => seg,
            an         => an,
            pwm        => pwm,
            pwm1       => pwm1
        );

    -- Generador de reloj de 100 MHz
    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- Estímulos de prueba
    stim_proc : process
    begin
        -- Reset inicial
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Activar el sistema (modo automático)
        enable <= '1';

        -- Simular señal de salida del ADC (esto puede ajustarse según pruebas)
        wait for 500 ns;
        for i in 0 to 100 loop
            ADC_out <= not ADC_out;
            wait for 1 us;
        end loop;

        wait;
    end process;

end Behavioral;
